import 'package:flutter/material.dart';

abstract final class AppDimens {
  AppDimens._();

  // BorderRadius — panels read as quiet instruments: 14–16 for cards,
  // pills only on small controls.
  static const double radiusInput = 12;
  static const double radiusCard = 16;
  static const double radiusCardLg = 18;
  static const double radiusDialog = 20;
  static const double radiusPill = 22;
  static const double radiusXxl = 24;
  static const double radiusRound = 30;

  // EdgeInsets — one rhythm throughout; more air above headings than below.
  static const screenPadding = EdgeInsets.all(20);
  static const cardPadding = EdgeInsets.all(16);
  static const cardMargin = EdgeInsets.symmetric(horizontal: 16, vertical: 6);
  static const buttonPaddingV = EdgeInsets.symmetric(vertical: 14);
  static const listTileContent = EdgeInsets.symmetric(horizontal: 16, vertical: 8);
}
