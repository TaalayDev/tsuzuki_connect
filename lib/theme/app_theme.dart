import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Color tokens ported 1:1 from the `:root` CSS custom properties in
/// `css/main.css` ("Pastel Glass Theme"), so the Flutter UI can match the
/// original web app's look without re-deriving a palette from scratch.
class AppColors {
  AppColors._();

  static const cream = Color(0xFFFDEDE3);
  static const creamLight = Color(0xFFFFFFFF);
  static const brown = Color(0xFF6F52B5);
  static const brownDark = Color(0xFF3A2E4D);
  static const orange = Color(0xFFE8946F);
  static const orangeLight = Color(0xFFF2AF8C);
  static const green = Color(0xFF8FB49F);
  static const greenDark = Color(0xFF4E8A6C);
  static const purple = Color(0xFF6F52B5);
  static const purpleDark = Color(0xFF4A3D6B);
  static const purpleLight = Color(0xFF8C6FD1);
  static const mintText = Color(0xFF365A48);

  static const glassBg = Color(0x80FFFFFF); // rgba(255,255,255,0.5)
  static const glassBgStrong = Color(0xA6FFFFFF); // 0.65
  static const glassBgSoft = Color(0x66FFFFFF); // 0.4
  static const glassBorder = Color(0xA6FFFFFF);

  /// `.menu-btn`'s background over the main-menu video (`rgba(255,255,255,
  /// 0.14)`) — much fainter than [glassBgStrong], since it's meant to sit
  /// on top of a busy photo/video rather than the plain menu-less gradient
  /// the rest of the app uses.
  static const menuGlassBg = Color(0x24FFFFFF);

  /// `.menu-bg-overlay` — darkens the main-menu background video so white
  /// button/title text stays legible.
  static const menuOverlayGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment(0.7, 0.3),
    colors: [Color(0xC72A2118), Color(0x662A2118), Color(0x2E2A2118)],
  );

  /// The main-menu diagonal sky gradient from `body { background: ... }`.
  static const backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFDEDE3), Color(0xFFF3E9F7), Color(0xFFE4F6ED)],
    stops: [0.0, 0.5, 1.0],
  );

  /// `.menu-btn-primary` / `#btn-new-game` gradient.
  static const primaryButtonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFD9C0), Color(0xFFF7C7DA)],
  );
  static const primaryButtonText = Color(0xFF5A3A2E);

  /// `.menu-btn-premium` gradient.
  static const premiumButtonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF7D488), Color(0xFFF0A868)],
  );
  static const premiumButtonText = Color(0xFF4A2E1A);
}

/// Corner radii ported from `css/main.css` (`--radius-pill`, dialogue box
/// `border-radius: 32px`, card-style panels `border-radius: 16px`).
class AppRadii {
  AppRadii._();

  static const pill = 999.0;
  static const card = 16.0;
  static const dialogueBox = 32.0;
}

/// `backdrop-filter: blur(...)` sigma values from `css/main.css`. Flutter's
/// `ImageFilter.blur` sigma isn't a 1:1 unit match for CSS blur px, but
/// these are close enough to read as the same "frosted glass" strength.
class AppBlur {
  AppBlur._();

  static const button = 14.0;
  static const dialogueBox = 16.0;
}

/// Drop shadows ported from `css/main.css` — purple-tinted for glass
/// panels/buttons, peach-tinted for the primary/premium gradient buttons.
class AppShadows {
  AppShadows._();

  static const glass = [
    BoxShadow(color: Color(0x29906FD1), blurRadius: 22, offset: Offset(0, 8)),
  ];

  static const dialogueBox = [
    BoxShadow(color: Color(0x38906FD1), blurRadius: 46, offset: Offset(0, 16)),
  ];

  static const primaryButton = [
    BoxShadow(color: Color(0x59E8946F), blurRadius: 24, offset: Offset(0, 10)),
  ];

  static const premiumButton = [
    BoxShadow(color: Color(0x59D8943F), blurRadius: 24, offset: Offset(0, 10)),
  ];
}

class AppTheme {
  AppTheme._();

  /// `--font-english: 'Fredoka'` — used for titles, buttons, and numerals.
  static TextStyle englishFont({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) =>
      GoogleFonts.fredoka(fontSize: fontSize, fontWeight: fontWeight, color: color);

  /// `--font-japanese: 'Zen Maru Gothic'` — the base body/UI font for
  /// everything that isn't an English-set heading or button label.
  static TextStyle japaneseFont({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) =>
      GoogleFonts.zenMaruGothic(fontSize: fontSize, fontWeight: fontWeight, color: color);

  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.purple,
        primary: AppColors.orange,
        secondary: AppColors.purple,
      ),
      scaffoldBackgroundColor: AppColors.cream,
    );

    final bodyTextTheme = GoogleFonts.zenMaruGothicTextTheme(base.textTheme).apply(
      bodyColor: AppColors.brownDark,
      displayColor: AppColors.brownDark,
    );

    return base.copyWith(
      textTheme: bodyTextTheme.copyWith(
        // Headlines/titles use the English display font, matching how
        // `.game-title`/`h1`-style elements set `font-family:
        // var(--font-english)` explicitly against the Zen Maru Gothic body
        // default in css/main.css.
        headlineLarge: GoogleFonts.fredoka(textStyle: bodyTextTheme.headlineLarge),
        headlineMedium: GoogleFonts.fredoka(textStyle: bodyTextTheme.headlineMedium),
        headlineSmall: GoogleFonts.fredoka(textStyle: bodyTextTheme.headlineSmall),
        titleLarge: GoogleFonts.fredoka(textStyle: bodyTextTheme.titleLarge),
        titleMedium: GoogleFonts.fredoka(textStyle: bodyTextTheme.titleMedium),
        labelLarge: GoogleFonts.fredoka(
          textStyle: bodyTextTheme.labelLarge,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
