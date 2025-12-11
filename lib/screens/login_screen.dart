import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import 'signup_screen.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء تعبئة جميع الحقول', textAlign: TextAlign.right)),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = await _authService.signIn(email: email, password: password);
      if (user != null && mounted) {
        final fullName = user.displayName ?? 'مستخدم';
        final firstName = fullName.split(' ').first;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainScreen(userName: firstName)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString(), textAlign: TextAlign.right)),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    final titleSize = screenWidth * 0.065;
    final labelSize = screenWidth * 0.04;
    final buttonTextSize = screenWidth * 0.045;
    final smallTextSize = screenWidth * 0.035;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.02),

                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),

                SizedBox(height: screenHeight * 0.03),

                _buildFaceHeader(context, screenWidth, screenHeight, titleSize),

                SizedBox(height: screenHeight * 0.05),

                _buildTextField(
                  label: 'البريد الإلكتروني',
                  hint: 'أدخل بريدك الإلكتروني',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),

                SizedBox(height: screenHeight * 0.02),

                _buildTextField(
                  label: 'كلمة المرور',
                  hint: 'أدخل كلمة المرور',
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    child: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: const Color(0xFF9D9C9C),
                      size: 20,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'نسيت كلمة المرور؟',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cairo(
                      color: const Color(0xFFC3C3C3),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.underline,
                      decorationColor: const Color(0xFFC3C3C3),
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.1),

                Center(
                  child: GestureDetector(
                    onTap: _isLoading ? null : _handleLogin,
                    child: Container(
                      width: screenWidth * 0.48,
                      height: screenHeight * 0.065,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF45C588),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Center(
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Color(0xFF121212),
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'تسجيل دخول',
                                style: GoogleFonts.cairo(
                                  color: const Color(0xFF121212),
                                  fontSize: buttonTextSize,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.1),

                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const SignUpScreen()),
                      );
                    },
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'ما عندك حساب؟!  ',
                            style: GoogleFonts.cairo(
                              color: Colors.white,
                              fontSize: labelSize,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextSpan(
                            text: 'نسويلك حساب..',
                            style: GoogleFonts.cairo(
                              color: const Color(0xFF45C588),
                              fontSize: labelSize,
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.underline,
                              decorationColor: const Color(0xFF45C588),
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildFaceHeader(BuildContext context, double screenWidth, double screenHeight, double titleSize) {
    return Center(
      child: Image.asset(
        'assets/images/welcome.png',
        width: screenWidth * 0.9,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 46,
          decoration: ShapeDecoration(
            color: const Color(0xFF121212),
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                width: 1,
                color: Color(0xFF474747),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontSize: 15,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.cairo(
                color: const Color(0xFF9D9C9C),
                fontSize: 15,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              suffixIcon: suffixIcon,
            ),
          ),
        ),
      ],
    );
  }
}
