import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signup_screen.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    final titleSize = screenWidth * 0.08; 
    final bodySize = screenWidth * 0.04; 
    final subtitleSize = screenWidth * 0.05; 

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.02),

                _buildIllustration(screenWidth),

                SizedBox(height: screenHeight * 0.02),

                Text(
                  'يالله حيييه..',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    color: const Color(0xFF45C588),
                    fontSize: titleSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: screenHeight * 0.015),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    'وصلت لمكان بيساعدك على تنظيم وتنسيق كل ما يتعلق بدراستك بكل سهولة. خلك مستعد يا مجتهد لتجربة جديدة تتيح لك التفاعل، التعاون، وتحقيق أهدافك الأكاديمية بشكل أكثر فاعلية و سلاسة.',
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: GoogleFonts.cairo(
                      color: Colors.white,
                      fontSize: bodySize,
                      fontWeight: FontWeight.w400,
                      height: 1.6,
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.03),

                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'ابدأ الآن،',
                        style: GoogleFonts.cairo(
                          color: const Color(0xFF45C588),
                          fontSize: subtitleSize,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: '\nوخلّ دراستك أسهل ونحقق النجاح معاً',
                        style: GoogleFonts.cairo(
                          color: Colors.white,
                          fontSize: bodySize,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),

                SizedBox(height: screenHeight * 0.04),

                _buildJoinBanner(context, screenWidth),

                SizedBox(height: screenHeight * 0.02),

                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'عندك حساب؟  ',
                          style: GoogleFonts.cairo(
                            color: Colors.white,
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: 'سجل دخول',
                          style: GoogleFonts.cairo(
                            color: const Color(0xFF45C588),
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.underline,
                            decorationColor: const Color(0xFF45C588),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.04),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIllustration(double screenWidth) {
    final illustrationHeight = screenWidth * 0.7; 
    
    return SizedBox(
      width: screenWidth * 0.85,
      height: illustrationHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ..._buildCloudOvals(screenWidth),
          Positioned(
            top: illustrationHeight * 0.1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/1.jpeg',
                width: screenWidth * 0.55,
                height: illustrationHeight * 0.78,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCloudOvals(double screenWidth) {
    final scale = screenWidth / 400; 
    final ovalSize = 70 * scale; 
    
    final List<Map<String, double>> ovalPositions = [
      {'left': 15, 'top': 195},
      {'left': 25, 'top': 130},
      {'left': 10, 'top': 55},
      {'left': 15, 'top': 15},
      {'left': 85, 'top': 10},
      {'left': 140, 'top': 25},
      {'left': 195, 'top': 15},
      {'left': 260, 'top': 10},
      {'left': 245, 'top': 45},
      {'left': 240, 'top': 95},
      {'left': 250, 'top': 150},
      {'left': 245, 'top': 200},
      {'left': 185, 'top': 190},
      {'left': 130, 'top': 200},
      {'left': 80, 'top': 190},
    ];

    return ovalPositions.map((pos) {
      return Positioned(
        left: pos['left']! * scale * 0.9,
        top: pos['top']! * scale * 0.9,
        child: Container(
          width: ovalSize,
          height: ovalSize * 0.95,
          decoration: const ShapeDecoration(
            color: Colors.white,
            shape: OvalBorder(),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildJoinBanner(BuildContext context, double screenWidth) {
    final bannerHeight = screenWidth * 0.13;
    
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const SignUpScreen()),
        );
      },
      child: Container(
        width: screenWidth * 0.6,
        height: bannerHeight,
        decoration: BoxDecoration(
          color: const Color(0xFF45C588),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            'أنضم معنا',
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
