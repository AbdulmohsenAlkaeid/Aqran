import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'main_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _obscurePassword = true;
  bool _isLoading = false;

  String? _selectedDay;
  String? _selectedMonth;
  String? _selectedYear;
  String? _selectedMajor;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (firstName.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء تعبئة جميع الحقول المطلوبة', textAlign: TextAlign.right)),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final fullName = '$firstName $lastName'.trim();
      final user = await _authService.signUp(
        email: email,
        password: password,
        name: fullName,
      );

      if (user != null && mounted) {
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
    
    final titleSize = screenWidth * 0.055;
    final labelSize = screenWidth * 0.038;
    final buttonTextSize = screenWidth * 0.045;
    final smallTextSize = screenWidth * 0.032;

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

                SizedBox(height: screenHeight * 0.02),

                Center(
                  child: Text(
                    'أنشئ حسابك وأنضم معنا..',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cairo(
                      color: Colors.white,
                      fontSize: titleSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.04),

                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        label: 'الأسم الأول',
                        hint: 'اسمك الأول هنا',
                        controller: _firstNameController,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        label: 'الأسم الأخير',
                        hint: 'اسمك الأخير هنا',
                        controller: _lastNameController,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.02),

                _buildTextField(
                  label: 'البريد الإلكتروني',
                  hint: 'E-mail@hotmail.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),

                SizedBox(height: screenHeight * 0.02),

                _buildTextField(
                  label: 'كلمة المرور',
                  hint: '*******************',
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

                SizedBox(height: screenHeight * 0.02),

                Text(
                  'تاريخ الميلاد',
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontSize: labelSize,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: _buildDropdown(
                        hint: 'اليوم',
                        value: _selectedDay,
                        items: List.generate(31, (i) => '${i + 1}'),
                        onChanged: (val) => setState(() => _selectedDay = val),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDropdown(
                        hint: 'الشهر',
                        value: _selectedMonth,
                        items: List.generate(12, (i) => '${i + 1}'),
                        onChanged: (val) => setState(() => _selectedMonth = val),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDropdown(
                        hint: 'السنة',
                        value: _selectedYear,
                        items: List.generate(50, (i) => '${2010 - i}'),
                        onChanged: (val) => setState(() => _selectedYear = val),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.02),

                Text(
                  'التخصص',
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontSize: labelSize,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),

                Container(
                  width: double.infinity,
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
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
                  child: Row(
                    children: [
                      const Icon(
                        Icons.school_outlined,
                        color: Color(0xFF9D9C9C),
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedMajor,
                            hint: Text(
                              'ايش تخصصك في كلية هندسة وعلوم الحاسب؟',
                              textAlign: TextAlign.right,
                              style: GoogleFonts.cairo(
                                color: const Color(0xFF9D9C9C),
                                fontSize: 14,
                              ),
                            ),
                            isExpanded: true,
                            dropdownColor: const Color(0xFF121212),
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Color(0xFF9D9C9C),
                            ),
                            items: [
                              'علوم الحاسب',
                              'هندسة البرمجيات',
                              'نظم المعلومات',
                              'الذكاء الاصطناعي',
                              'الأمن السيبراني',
                            ].map((major) {
                              return DropdownMenuItem(
                                value: major,
                                child: Text(
                                  major,
                                  style: GoogleFonts.cairo(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) => setState(() => _selectedMajor = val),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.06),

                Center(
                  child: GestureDetector(
                    onTap: _isLoading ? null : _handleSignUp,
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
                                'انشاء الحساب',
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

                SizedBox(height: screenHeight * 0.06),

                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'عندك حساب؟!  ',
                            style: GoogleFonts.cairo(
                              color: Colors.white,
                              fontSize: labelSize,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextSpan(
                            text: 'سجل دخولك..',
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
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 44,
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

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 10),
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
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hint,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              color: const Color(0xFF9D9C9C),
              fontSize: 15,
            ),
          ),
          isExpanded: true,
          dropdownColor: const Color(0xFF121212),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Color(0xFF9D9C9C),
            size: 20,
          ),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Center(
                child: Text(
                  item,
                  style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
