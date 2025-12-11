import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import '../services/course_service.dart';
import 'main_screen.dart';

class AddCourseScreen extends StatefulWidget {
  final String userName;
  const AddCourseScreen({super.key, required this.userName});

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final _courseNameController = TextEditingController();
  final _courseCodeController = TextEditingController();
  final _coursePrefixController = TextEditingController();
  final _detailsController = TextEditingController();
  
  String? _selectedGrade;
  final List<String> _grades = ['A+', 'A', 'B+', 'B', 'C+', 'C', 'D+', 'D', 'F'];
  
  PlatformFile? _attachedFile;
  
  final _courseService = CourseService();
  bool _isSubmitting = false;

  bool? _finishedCourse;
  bool _isPartsExpanded = false;
  
  int? _selectedPartIndex; 
  final List<String> _courseParts = [
    'كامل المنهج الدراسي',
    'نصف المنهج الدراسي',
    'اجزاء معينة من المنهج الدراسي'
  ];

  @override
  void dispose() {
    _courseNameController.dispose();
    _courseCodeController.dispose();
    _coursePrefixController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: screenHeight * 0.04),

                      Stack(
                        alignment: Alignment.bottomCenter,
                        clipBehavior: Clip.none,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              'حاب تشرح مادة ${widget.userName} ؟',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.cairo(
                                color: Colors.white,
                                fontSize: screenWidth * 0.05,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -5,
                            child: Image.asset(
                              'assets/images/line.png',
                              width: screenWidth * 0.35,
                              color: const Color(0xFF45C588),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: screenHeight * 0.04),

                      _buildLabel('اعطينا أسم المادة', screenWidth),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _courseNameController,
                        hint: 'بناء المترجمات...',
                        screenWidth: screenWidth,
                      ),

                      SizedBox(height: screenHeight * 0.025),

                      _buildLabel('اعطينا رمز المادة', screenWidth),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _courseCodeController,
                              hint: '417...',
                              screenWidth: screenWidth,
                              isCenter: true,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTextField(
                              controller: _coursePrefixController,
                              hint: 'CCCS...',
                              screenWidth: screenWidth,
                              isCenter: true,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: screenHeight * 0.025),

                      _buildLabel('هل أنهيت المادة في خطتك الدراسية؟', screenWidth, color: const Color(0xFF45C588)),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF121212),
                          border: Border.all(color: const Color(0xFF474747)),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _finishedCourse = true),
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: _finishedCourse == true 
                                      ? const Color(0xFFB4B1FA)
                                      : Colors.transparent,
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'نعم',
                                      style: GoogleFonts.cairo(
                                        color: Colors.white,
                                        fontSize: screenWidth * 0.038,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(width: 1, height: 50, color: const Color(0xFF474747)),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _finishedCourse = false),
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: _finishedCourse == false 
                                      ? const Color(0xFFB4B1FA)
                                      : Colors.transparent,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'لا',
                                      style: GoogleFonts.cairo(
                                        color: Colors.white,
                                        fontSize: screenWidth * 0.038,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      if (_finishedCourse == true) _buildFinishedCourseFields(screenWidth),
                      if (_finishedCourse == false) _buildNotFinishedCourseFields(screenWidth),
                      
                      SizedBox(height: screenHeight * 0.025),

                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isPartsExpanded = !_isPartsExpanded;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFF121212),
                            border: Border.all(color: const Color(0xFF474747)),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _selectedPartIndex != null 
                                        ? _courseParts[_selectedPartIndex!]
                                        : 'قم بتحديد الاجزاء اللي ودك تشرحها',
                                      style: GoogleFonts.cairo(
                                        color: _selectedPartIndex != null ? const Color(0xFF45C588) : Colors.white,
                                        fontSize: screenWidth * 0.035,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Icon(
                                      _isPartsExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_left, 
                                      color: Colors.white70
                                    ),
                                  ],
                                ),
                              ),
                              if (_isPartsExpanded)
                                Column(
                                  children: List.generate(_courseParts.length, (index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedPartIndex = index;
                                          _isPartsExpanded = false;
                                        });
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                        decoration: const BoxDecoration(
                                          border: Border(top: BorderSide(color: Color(0xFF474747))),
                                        ),
                                        child: Text(
                                          _courseParts[index],
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.cairo(
                                            color: const Color(0xFF45C588),
                                            fontSize: screenWidth * 0.035,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.025),

                      GestureDetector(
                        onTap: () async {
                          try {
                            final result = await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['mp4', 'mov', 'avi', 'mkv', 'webm'],
                              allowMultiple: false,
                            );
                            if (result != null && result.files.isNotEmpty) {
                              setState(() {
                                _attachedFile = result.files.first;
                              });
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'تم إرفاق: ${_attachedFile!.name}',
                                      textAlign: TextAlign.right,
                                    ),
                                    backgroundColor: const Color(0xFF45C588),
                                  ),
                                );
                              }
                            }
                          } catch (e) {
                            debugPrint('File picker error: $e');
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('خطأ في اختيار الملف: $e', textAlign: TextAlign.right),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF121212),
                            border: Border.all(
                              color: _attachedFile != null 
                                  ? const Color(0xFF45C588) 
                                  : const Color(0xFF474747),
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  _attachedFile != null 
                                      ? _attachedFile!.name 
                                      : 'إرفق فيديو شرح جزء من المنهج للتحقق',
                                  style: GoogleFonts.cairo(
                                    color: _attachedFile != null 
                                        ? const Color(0xFF45C588) 
                                        : Colors.white,
                                    fontSize: screenWidth * 0.035,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(
                                _attachedFile != null ? Icons.check_circle : Icons.attach_file,
                                color: _attachedFile != null 
                                    ? const Color(0xFF45C588) 
                                    : Colors.white70,
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.05),

                      SizedBox(
                        width: screenWidth * 0.5,
                        height: 55,
                        child: _isSubmitting 
                          ? const Center(child: CircularProgressIndicator(color: Color(0xFF45C588)))
                          : ElevatedButton(
                          onPressed: () async {
                             if (_courseNameController.text.isEmpty || _courseCodeController.text.isEmpty) {
                               ScaffoldMessenger.of(context).showSnackBar(
                                 const SnackBar(content: Text('الرجاء تعبئة الحقول المطلوبة', textAlign: TextAlign.right)),
                               );
                               return;
                             }
                             
                             setState(() => _isSubmitting = true);
                             try {
                               await _courseService.submitCourseRequest(
                                 courseName: _courseNameController.text,
                                 courseCode: _courseCodeController.text,
                                 coursePrefix: _coursePrefixController.text,
                                 userName: widget.userName,
                                 hasFinished: _finishedCourse ?? false,
                                 grade: _selectedGrade ?? '',
                                 details: _detailsController.text,
                                 selectedPart: _selectedPartIndex != null ? _courseParts[_selectedPartIndex!] : null,
                               );
                               
                               if (mounted) {
                                 ScaffoldMessenger.of(context).showSnackBar(
                                   const SnackBar(
                                       content: Text('تم تقديم الطلب بنجاح', textAlign: TextAlign.right),
                                       backgroundColor: Color(0xFF45C588),
                                   ),
                                 );
                                 Navigator.pop(context);
                               }
                             } catch (e) {
                               if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                   SnackBar(content: Text('حدث خطأ: $e', textAlign: TextAlign.right)),
                                 );
                               }
                             } finally {
                               if (mounted) setState(() => _isSubmitting = false);
                             }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF45C588),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'تقديم الطلب',
                            style: GoogleFonts.cairo(
                              color: Colors.black,
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      
                      SizedBox(height: screenHeight * 0.03),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                child: _buildBottomNavigation(screenWidth),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFinishedCourseFields(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: const BoxDecoration(
             color: Color(0xFF121212),
             border: Border(
                left: BorderSide(color: Color(0xFF474747)),
                right: BorderSide(color: Color(0xFF474747)),
                bottom: BorderSide(color: Color(0xFF474747)),
             ), 
             borderRadius: BorderRadius.only(
               bottomLeft: Radius.circular(16),
               bottomRight: Radius.circular(16),
             )
          ),
          child: Column(
            children: [
              _buildGradeDropdown(screenWidth),
              const Divider(color: Color(0xFF474747)),
              _buildTextFieldNoBorder(
                controller: _detailsController,
                hint: 'هل عززت معرفتك بالمادة بعد الانتهاء منها؟ مثل حصولك على شهادات احترافية في مجال المادة؟ أو تعليم ذاتي؟ (الرجاء كتابة التفاصيل)',
                screenWidth: screenWidth,
                maxLines: 4,
                hintColor: const Color(0xFF6B6B6B),
                fontSize: screenWidth * 0.032,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotFinishedCourseFields(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 0),
        Transform.translate(
           offset: const Offset(0, -5),
           child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
               color: Color(0xFF121212),
               border: Border(
                  left: BorderSide(color: Color(0xFF474747)),
                  right: BorderSide(color: Color(0xFF474747)),
                  bottom: BorderSide(color: Color(0xFF474747)),
               ), 
               borderRadius: BorderRadius.only(
                 bottomLeft: Radius.circular(16),
                 bottomRight: Radius.circular(16),
               )
            ),
            child: _buildTextFieldNoBorder(
              controller: _detailsController,
              hint: 'كيف تعلمت المادة؟ هل حصلت على شهادات احترافية في مجال المادة؟ أو تعليم ذاتي مثل متابعة شروحات علمية من أناس مختصين في المادة؟ (الرجاء كتابة التفاصيل)',
              screenWidth: screenWidth,
              maxLines: 4,
              hintColor: const Color(0xFF6B6B6B),
              fontSize: screenWidth * 0.032,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGradeDropdown(double screenWidth) {
    return DropdownButtonFormField<String>(
      value: _selectedGrade,
      hint: Text(
        'ايش كان تقديرك في المادة؟',
        style: GoogleFonts.cairo(
          color: const Color(0xFF6B6B6B),
          fontSize: screenWidth * 0.035,
        ),
        textAlign: TextAlign.center,
      ),
      decoration: const InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      ),
      dropdownColor: const Color(0xFF2A2A2A),
      icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF6B6B6B)),
      isExpanded: true,
      alignment: Alignment.center,
      style: GoogleFonts.cairo(color: Colors.white, fontSize: screenWidth * 0.035),
      items: _grades.map((grade) {
        return DropdownMenuItem<String>(
          value: grade,
          alignment: Alignment.center,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              grade,
              style: GoogleFonts.cairo(color: Colors.white, fontSize: screenWidth * 0.035),
            ),
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedGrade = value;
        });
      },
    );
  }

  Widget _buildTextFieldNoBorder({
    required TextEditingController controller,
    required String hint,
    required double screenWidth,
    int maxLines = 1,
    Color? hintColor,
    double? fontSize,
  }) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.center,
      textDirection: TextDirection.rtl,
      maxLines: maxLines,
      style: GoogleFonts.cairo(color: Colors.white, fontSize: fontSize ?? screenWidth * 0.035),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.cairo(
          color: hintColor ?? const Color(0xFF6B6B6B), 
          fontSize: fontSize ?? screenWidth * 0.035,
          height: 1.4,
        ),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      ),
    );
  }

  Widget _buildLabel(String text, double screenWidth, {Color? color}) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        text,
        style: GoogleFonts.cairo(
          color: color ?? Colors.white,
          fontSize: screenWidth * 0.038,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required double screenWidth,
    bool isCenter = false,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        border: Border.all(color: const Color(0xFF474747)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        textAlign: isCenter ? TextAlign.center : TextAlign.right,
        textDirection: TextDirection.rtl, 
        style: GoogleFonts.cairo(color: Colors.white, fontSize: screenWidth * 0.035),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.cairo(color: const Color(0xFF6B6B6B), fontSize: screenWidth * 0.035),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation(double screenWidth) {
    return Center(
      child: Container(
        height: 65,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF2F2F2F),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildNavButton(
              assetPath: 'assets/images/settings_icon.png',
              isSelected: false,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen(userName: widget.userName, initialNavIndex: 2)),
                );
              },
            ),
            const SizedBox(width: 15),
            
            _buildNavButton(
              assetPath: 'assets/images/home_icon.png',
              isSelected: true, 
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen(userName: widget.userName, initialNavIndex: 1)),
                );
              },
            ),
            const SizedBox(width: 15),
            
            _buildNavButton(
              assetPath: 'assets/images/course_icon.png',
              isSelected: false,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen(userName: widget.userName, initialNavIndex: 0)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton({
    required String assetPath,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF45C588) : const Color(0xFF474747),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Image.asset(
            assetPath,
            width: 26,
            height: 26,
          ),
        ),
      ),
    );
  }

}
