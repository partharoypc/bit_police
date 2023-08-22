import 'package:flutter/material.dart';

class MyColors {
  static const MaterialColor primaryColor = MaterialColor(
    _colorPrimaryValue,
    <int, Color>{
      50: Color(0xFF107CFA),
      100: Color(0xFF1272EA),
      200: Color(0xFF0E68D6),
      300: Color(0xFF0D54AC),
      400: Color(0xFF0C4DA2),
      500: Color(_colorPrimaryValue),
      600: Color(0xFF0A4184),
      700: Color(0xFF08376F),
      800: Color(0xFF072d5C),
      900: Color(0xFF052347),
    },
  );
  static const int _colorPrimaryValue = 0xFF0C4DA2;

  static const Color teal = const Color(0xFF008577);
  static const Color indigo = const Color(0xFF4267B2);
  static const Color violet = const Color(0xFF673AB7);
  static const Color cyan = const Color(0xFF049CC5);
  static const Color pink = const Color(0xFFFF4081);
  static const Color amber = const Color(0xFFF79E08);
}

