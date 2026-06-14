import 'dart:io';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../models/food.dart';
import '../core/utils/meal_type_localizer.dart';
import '../services/meal_history_service.dart';

/// Thrown when the date range has no entries.
class PdfEmptyException implements Exception {
  const PdfEmptyException();
}

/// Generates a professional PDF report for doctor visits.
class PdfReportService {
  static pw.MemoryImage? _logoImage;

  /// Generate and share a PDF report for the given user.
  static Future<File?> generateReport({
    required String uid,
    required AppLocalizations l10n,
    required String locale,
    required String userName,
    required DateTime from,
    required DateTime to,
  }) async {
    final toEnd = DateTime(to.year, to.month, to.day + 1);
    final entries = await MealHistoryService.fetchAll(uid);

    // Filter by date range
    final filtered = entries
        .where(
          (e) => !e.timestamp.isBefore(from) && e.timestamp.isBefore(toEnd),
        )
        .toList();
    if (filtered.isEmpty) throw const PdfEmptyException();

    // Load logo once
    _logoImage ??= await _loadLogo();

    // Sort by date ascending
    filtered.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    // ── Useful stats ──
    final days = _uniqueDays(filtered);
    final mealCount = filtered.length;
    final avgCarbsPerDay =
        filtered.fold<double>(0, (s, e) => s + e.totalCarbs) / days;
    final glucoses = filtered
        .where((e) => e.glucose != null)
        .map((e) => e.glucose!)
        .toList();
    final avgGlucose = glucoses.isNotEmpty
        ? glucoses.reduce((a, b) => a + b) / glucoses.length
        : null;
    final insulinDoses = filtered
        .where((e) => e.totalBolus != null)
        .map((e) => e.totalBolus!)
        .toList();
    final avgInsulin = insulinDoses.isNotEmpty
        ? insulinDoses.reduce((a, b) => a + b) / insulinDoses.length
        : null;

    final now = DateTime.now();
    final dateStr = DateFormat('dd/MM/yyyy', locale).format(now);
    final fromStr = DateFormat('dd/MM/yyyy', locale).format(from);
    final toStr = DateFormat('dd/MM/yyyy', locale).format(to);

    // ── Build PDF ──
    final pdf = pw.Document(title: l10n.historyPdfTitle, author: userName);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        footer: (context) {
          return pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              if (_logoImage != null)
                pw.Opacity(
                  opacity: 0.3,
                  child: pw.Container(
                    width: 18,
                    height: 18,
                    child: pw.ClipOval(child: pw.Image(_logoImage!)),
                  ),
                ),
              pw.Text(
                'Libreta Dulce · ${l10n.historyPdfFileName.replaceAll('.pdf', '')}',
                style: pw.TextStyle(fontSize: 7, color: PdfColors.grey400),
              ),
              pw.Text(
                '${context.pageNumber}/${context.pagesCount}',
                style: const pw.TextStyle(
                  fontSize: 7,
                  color: PdfColors.grey400,
                ),
              ),
            ],
          );
        },
        build: (context) {
          return [
            // ── Header with logo ──
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                if (_logoImage != null)
                  pw.Container(
                    width: 40,
                    height: 40,
                    margin: const pw.EdgeInsets.only(right: 12),
                    child: pw.ClipOval(child: pw.Image(_logoImage!)),
                  ),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        l10n.historyPdfTitle,
                        style: pw.TextStyle(
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.teal,
                        ),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        l10n.historyPdfSubtitle(userName, dateStr),
                        style: pw.TextStyle(fontSize: 9, color: PdfColors.grey),
                      ),
                      pw.Text(
                        '${l10n.historyPdfPeriod}: $fromStr – $toStr',
                        style: pw.TextStyle(fontSize: 9, color: PdfColors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 20),

            // ── Summary stats ──
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.teal50,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
                border: pw.Border.all(color: PdfColors.teal100),
              ),
              child: pw.Wrap(
                spacing: 16,
                runSpacing: 8,
                alignment: pw.WrapAlignment.spaceAround,
                children: [
                  _statCell(l10n.historyPdfDays, days.toString()),
                  _statCell(l10n.historyPdfMeals, mealCount.toString()),
                  _statCell(
                    l10n.historyPdfAvgCarbs,
                    '${avgCarbsPerDay.toStringAsFixed(0)}g',
                  ),
                  if (avgGlucose != null)
                    _statCell(
                      l10n.historyPdfAvgGlucose,
                      '${avgGlucose.toStringAsFixed(0)} mg/dL',
                    ),
                  if (avgInsulin != null)
                    _statCell(
                      l10n.historyPdfAvgInsulin,
                      '${avgInsulin.toStringAsFixed(1)} U',
                    ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),

            pw.SizedBox(height: 20),

            // ── Master table ──
            pw.LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints?.maxWidth ?? 547.0;
                // Fixed widths from proportions 1.6:1.4:0.8:0.8:0.8:0.8
                final colW = <int, pw.TableColumnWidth>{
                  0: pw.FixedColumnWidth(w * 1.6 / 6.2),
                  1: pw.FixedColumnWidth(w * 1.4 / 6.2),
                  2: pw.FixedColumnWidth(w * 0.8 / 6.2),
                  3: pw.FixedColumnWidth(w * 0.8 / 6.2),
                  4: pw.FixedColumnWidth(w * 0.8 / 6.2),
                  5: pw.FixedColumnWidth(w * 0.8 / 6.2),
                };

                final rows = <pw.TableRow>[
                  // Header
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(
                      border: pw.Border(
                        bottom: pw.BorderSide(
                          color: PdfColors.teal,
                          width: 1.5,
                        ),
                      ),
                    ),
                    children: [
                      _tableHeader(l10n.historyPdfFood),
                      _tableHeader(l10n.historyPdfMealType),
                      _tableHeader(l10n.photoTableGrams),
                      _tableHeader(l10n.photoTableCarbs),
                      _tableHeader(l10n.photoTableRations),
                      _tableHeader(l10n.historyPdfGlucose),
                    ],
                  ),
                ];

                for (final entry in filtered) {
                  final dateHeader = DateFormat(
                    'dd/MM HH:mm',
                    locale,
                  ).format(entry.timestamp);
                  final mealTypeLabel = mealTypeLocalizedLabel(
                    entry.mealType,
                    l10n,
                  );
                  final glucose = entry.glucose?.toStringAsFixed(0) ?? '–';
                  final bolus = entry.totalBolus;
                  final items = entry.items;

                  // Group header row
                  rows.add(
                    pw.TableRow(
                      decoration: const pw.BoxDecoration(
                        color: PdfColors.teal50,
                      ),
                      children: List.generate(6, (i) {
                        if (i == 0) {
                          return pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(
                              vertical: 3,
                              horizontal: 2,
                            ),
                            child: pw.Row(
                              children: [
                                pw.Expanded(
                                  child: pw.Text(
                                    dateHeader,
                                    style: pw.TextStyle(
                                      fontSize: 7,
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.teal800,
                                    ),
                                  ),
                                ),
                                if (bolus != null)
                                  pw.Text(
                                    '${l10n.calcBolusTotal}: ${bolus.toStringAsFixed(1)}',
                                    style: pw.TextStyle(
                                      fontSize: 7,
                                      color: PdfColors.teal700,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }
                        return pw.SizedBox.shrink();
                      }),
                    ),
                  );

                  // Food item rows
                  for (final item in items) {
                    rows.add(
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.only(
                              left: 4,
                              top: 2,
                              bottom: 2,
                            ),
                            child: pw.Text(
                              item.name,
                              style: const pw.TextStyle(fontSize: 8),
                            ),
                          ),
                          _tableCellSmall(mealTypeLabel),
                          _tableCellSmall('${item.grams.toStringAsFixed(0)}g'),
                          _tableCellSmall(item.carbs.toStringAsFixed(1)),
                          _tableCellSmall(item.raciones.toStringAsFixed(1)),
                          _tableCellSmall(glucose),
                        ],
                      ),
                    );
                  }

                  // Subtotal row
                  rows.add(
                    pw.TableRow(
                      decoration: const pw.BoxDecoration(
                        border: pw.Border(
                          bottom: pw.BorderSide(
                            color: PdfColors.grey300,
                            width: 0.5,
                          ),
                        ),
                      ),
                      children: List.generate(6, (i) {
                        if (i == 0) {
                          return pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(
                              vertical: 2,
                              horizontal: 2,
                            ),
                            child: pw.Row(
                              children: [
                                pw.Text(
                                  l10n.calcTotalPlate,
                                  style: pw.TextStyle(
                                    fontSize: 7,
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColors.teal700,
                                  ),
                                ),
                                pw.Spacer(),
                                pw.Text(
                                  '${entry.totalCarbs.toStringAsFixed(1)}g HC · ${entry.totalRations.toStringAsFixed(1)} ${l10n.photoTableRations}',
                                  style: pw.TextStyle(
                                    fontSize: 7,
                                    color: PdfColors.teal700,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return pw.SizedBox.shrink();
                      }),
                    ),
                  );
                }

                return pw.Table(columnWidths: colW, children: rows);
              },
            ),

            pw.SizedBox(height: 20),

            // ── Footer disclaimer ──
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                color: PdfColors.orange50,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
              ),
              child: pw.Text(
                l10n.historyPdfDisclaimer,
                style: pw.TextStyle(
                  fontSize: 8,
                  color: PdfColors.grey700,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
            ),
          ];
        },
      ),
    );

    // ── Save and share ──
    final tempDir = await Directory.systemTemp.createTemp('libretadulce_pdf');
    final file = File('${tempDir.path}/${l10n.historyPdfFileName}');
    await file.writeAsBytes(await pdf.save());

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: l10n.historyPdfFileName,
    );

    return file;
  }

  static int _uniqueDays(List<MealEntry> entries) {
    final days = <String>{};
    for (final e in entries) {
      days.add(DateFormat('yyyyMMdd').format(e.timestamp));
    }
    return days.length.clamp(1, 999);
  }

  static pw.Widget _statCell(String label, String value) {
    return pw.Column(
      children: [
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 13,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.teal,
          ),
        ),
        pw.SizedBox(height: 1),
        pw.Text(
          label,
          style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey600),
          textAlign: pw.TextAlign.center,
        ),
      ],
    );
  }

  static pw.Widget _tableHeader(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
          fontSize: 8,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.teal,
        ),
      ),
    );
  }

  static pw.Widget _tableCellSmall(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Text(
        text,
        style: const pw.TextStyle(fontSize: 8),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  static Future<pw.MemoryImage?> _loadLogo() async {
    try {
      final data = await rootBundle.load('assets/icon.png');
      return pw.MemoryImage(data.buffer.asUint8List());
    } catch (e) {
      return null;
    }
  }
}
