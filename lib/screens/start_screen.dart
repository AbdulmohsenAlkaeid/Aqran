import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'welcome_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    final logoFontSize = screenWidth * 0.35;
    final buttonSize = screenWidth * 0.24;
    final buttonRadius = buttonSize * 0.28;
    final whiteOvalWidth = screenWidth * 0.48;
    final whiteOvalHeight = screenHeight * 0.035;
    final blackArcWidth = screenWidth * 0.55;
    final blackArcHeight = screenHeight * 0.045;

    return Scaffold(
      backgroundColor: const Color(0xFF45C588),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.08),

            SizedBox(
              height: screenHeight * 0.28,
              child: Stack(
                alignment: Alignment.bottomCenter,
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: blackArcWidth,
                      height: blackArcHeight,
                      decoration: const ShapeDecoration(
                        color: Color(0xFF121212),
                        shape: OvalBorder(),
                      ),
                    ),
                  ),
                  
                  Positioned(
                    bottom: blackArcHeight * 0.3,
                    child: Container(
                      width: whiteOvalWidth,
                      height: whiteOvalHeight,
                      decoration: const ShapeDecoration(
                        color: Colors.white,
                        shape: OvalBorder(),
                      ),
                    ),
                  ),
                  
                  Positioned(
                    bottom: blackArcHeight * 0.25,
                    child: Text(
                      'أقران',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'RAOOF',
                        color: const Color(0xFF121212),
                        fontSize: logoFontSize,
                        fontWeight: FontWeight.w400,
                        height: 1.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                );
              },
              child: Container(
                width: buttonSize,
                height: buttonSize,
                decoration: ShapeDecoration(
                  color: const Color(0xFF121212),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(buttonRadius),
                  ),
                ),
                child: Center(
                  child: Text(
                    'بدء',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cairo(
                      color: Colors.white,
                      fontSize: buttonSize * 0.3,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.04),
          ],
        ),
      ),
    );
  }
}
