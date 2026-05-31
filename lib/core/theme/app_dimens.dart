import 'package:flutter/material.dart';

abstract final class AppDimens {
  AppDimens._();

  // BorderRadius
  static const double radiusInput = 8;
  static const double radiusCard = 12;
  static const double radiusCardLg = 14;
  static const double radiusDialog = 16;
  static const double radiusPill = 20;
  static const double radiusXxl = 24;
  static const double radiusRound = 30;

  // EdgeInsets
  static const screenPadding = EdgeInsets.all(24);
  static const cardPadding = EdgeInsets.all(16);
  static const cardMargin = EdgeInsets.symmetric(horizontal: 16, vertical: 6);
  static const buttonPaddingV = EdgeInsets.symmetric(vertical: 14);
  static const listTileContent = EdgeInsets.symmetric(horizontal: 16, vertical: 8);
}
