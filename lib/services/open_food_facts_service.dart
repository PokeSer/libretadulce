import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:flutter/material.dart';

class FoodScanResult {
  final String name;
  final String brand;
  final double? carbsPer100g;
  final double? kcalPer100g;
  final double? proteinsPer100g;
  final double? fatsPer100g;

  const FoodScanResult({
    required this.name,
    this.brand = '',
    this.carbsPer100g,
    this.kcalPer100g,
    this.proteinsPer100g,
    this.fatsPer100g,
  });
}

class OpenFoodFactsService {
  static const _baseUrl = 'https://world.openfoodfacts.org/api/v0/product';

  static Future<String?> scanBarcode(BuildContext context) async {
    return SimpleBarcodeScanner.scanBarcode(
      context,
      barcodeAppBar: const BarcodeAppBar(
        appBarTitle: 'Escanea el codigo de barras',
        centerTitle: false,
        enableBackButton: true,
        backButtonIcon: Icon(Icons.arrow_back_ios),
      ),
      isShowFlashIcon: true,
      delayMillis: 1000,
      cameraFace: CameraFace.back,
    );
  }

  static Future<FoodScanResult?> lookupBarcode(String barcode) async {
    final url = Uri.parse('$_baseUrl/$barcode.json');
    final response = await http.get(url);

    if (response.statusCode != 200) return null;

    final data = jsonDecode(response.body);
    if (data['status'] != 1) return null;

    final product = data['product'];
    final nutriments = product['nutriments'];

    return FoodScanResult(
      name: product['product_name_es'] ??
          product['product_name'] ??
          'Alimento escaneado',
      brand: product['brands'] ?? '',
      carbsPer100g: nutriments?['carbohydrates_100g'] is num
          ? (nutriments['carbohydrates_100g'] as num).toDouble()
          : null,
      kcalPer100g: nutriments != null
          ? ((nutriments['energy-kcal_100g'] ?? nutriments['energy_100g']) as num?)
              ?.toDouble()
          : null,
      proteinsPer100g: nutriments?['proteins_100g'] is num
          ? (nutriments['proteins_100g'] as num).toDouble()
          : null,
      fatsPer100g: nutriments?['fat_100g'] is num
          ? (nutriments['fat_100g'] as num).toDouble()
          : null,
    );
  }
}
