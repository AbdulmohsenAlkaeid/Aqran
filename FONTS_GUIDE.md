# Font Setup Guide for Aqran App

## ✅ Current Setup: Google Fonts (Recommended)

I've configured your app to use **Google Fonts** which provides high-quality Arabic fonts that download automatically. No manual font file installation needed!

### Fonts Currently Used:

1. **Amiri** - For the "أقران" title
   - Beautiful Arabic font with traditional calligraphic style
   - Similar aesthetic to RAOOF
   - Weight: 700 (Bold)

2. **Cairo** - For the "بدء" button
   - Modern, clean Arabic font
   - Similar to Ara ES Nawar
   - Weight: 600 (Semi-bold)

### Advantages:
- ✅ No font files to download or manage
- ✅ Automatic font loading from Google
- ✅ High-quality, professionally designed Arabic fonts
- ✅ Works on all platforms (iOS, Android, Web, Desktop)
- ✅ Fonts are cached after first download

---

## 🔄 Alternative: Use Original Custom Fonts

If you want to use the exact fonts from your Figma design (RAOOF and Ara ES Nawar), follow these steps:

### Step 1: Get the Font Files

Download or obtain:
- `RAOOF-Regular.ttf` (or .otf)
- `RAOOF-Bold.ttf` (optional)
- `AraESNawar-Regular.ttf` (or .otf)

### Step 2: Add Font Files

Place the font files in: `assets/fonts/`

### Step 3: Update main.dart

Replace the Google Fonts code with custom fonts:

```dart
// Instead of:
style: GoogleFonts.amiri(...)

// Use:
style: TextStyle(
  fontFamily: 'RAOOF',
  ...
)
```

### Step 4: Restart App

Run:
```bash
flutter clean
flutter pub get
flutter run
```

---

## 🎨 Try Different Google Fonts

You can experiment with other Arabic fonts from Google Fonts:

### For Title "أقران":
- `GoogleFonts.amiri()` - Traditional calligraphic (current)
- `GoogleFonts.lateef()` - Classical Arabic style
- `GoogleFonts.scheherazade()` - Elegant traditional
- `GoogleFonts.reemKufi()` - Modern geometric

### For Button "بدء":
- `GoogleFonts.cairo()` - Modern clean (current)
- `GoogleFonts.tajawal()` - Contemporary sans-serif
- `GoogleFonts.almarai()` - Clean and modern
- `GoogleFonts.changa()` - Bold and strong

### How to Change:

Just replace the font name in `main.dart`:

```dart
// For title
style: GoogleFonts.reemKufi(  // Change this
  color: const Color(0xFF121212),
  fontSize: screenWidth * 0.45,
  fontWeight: FontWeight.w700,
  height: 1.0,
)

// For button
style: GoogleFonts.tajawal(  // Change this
  color: Colors.white,
  fontSize: 40,
  fontWeight: FontWeight.w600,
)
```

---

## 📱 Testing

Run your app to see the fonts:
```bash
flutter run
```

The first time you run the app, it will download the fonts from Google. After that, they'll be cached locally.

---

## 🌐 Browse All Google Fonts

Visit: https://fonts.google.com/?subset=arabic

Filter by "Arabic" to see all available Arabic fonts.
