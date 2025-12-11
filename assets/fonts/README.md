# Custom Fonts for Aqran App

This directory should contain the following Arabic font files:

## Required Font Files:

### 1. RAOOF Font (for "أقران" title)
- `RAOOF-Regular.ttf` (or similar variant)
- `RAOOF-Bold.ttf` (optional, for bold text)

### 2. Ara ES Nawar Font (for "بدء" button)
- `AraESNawar-Regular.ttf` (or similar variant)

## Where to Get These Fonts:

### RAOOF Font
- You can download from: https://fonts.google.com/specimen/Reem+Kufi (similar alternative)
- Or search for "RAOOF Arabic font" online
- Common sources: Adobe Fonts, MyFonts, or Arabic font websites

### Ara ES Nawar Font
- Search for "Ara ES Nawar font" or "Arabic Nawar font"
- May need to purchase or find from Arabic font repositories

## Installation Steps:

1. Download the font files (.ttf or .otf format)
2. Rename them to match the names in `pubspec.yaml`:
   - `RAOOF-Regular.ttf`
   - `RAOOF-Bold.ttf`
   - `AraESNawar-Regular.ttf`
3. Place them in this directory (`assets/fonts/`)
4. Run `flutter pub get` to update dependencies
5. Restart your app

## Alternative: Use Google Fonts Package

If you can't find these exact fonts, you can use the `google_fonts` package:

1. Add to `pubspec.yaml`:
   ```yaml
   dependencies:
     google_fonts: ^6.1.0
   ```

2. Use in code:
   ```dart
   import 'package:google_fonts/google_fonts.dart';
   
   Text(
     'أقران',
     style: GoogleFonts.reemKufi(  // Similar to RAOOF
       fontSize: 80,
       fontWeight: FontWeight.w500,
     ),
   )
   ```

## Note:
The app will use the system default font until you add these font files.
