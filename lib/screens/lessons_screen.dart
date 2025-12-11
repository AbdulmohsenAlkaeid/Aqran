import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'lesson_details_screen.dart';

class LessonsScreen extends StatefulWidget {
  final String courseName;
  final String courseCode;

  const LessonsScreen({
    super.key,
    required this.courseName,
    required this.courseCode,
  });

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final user = FirebaseAuth.instance.currentUser;
    String firstName = '';
    if (user != null && user.displayName != null && user.displayName!.isNotEmpty) {
      firstName = user.displayName!.split(' ').first;
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start, 
                      children: [
                        Text(
                          'اهلًا فيك $firstName',
                          style: GoogleFonts.cairo(
                            color: Colors.white,
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Image.asset(
                          'assets/images/line.png',
                          width: screenWidth * 0.3, 
                          height: 5,
                          fit: BoxFit.contain,
                          errorBuilder: (c, e, s) => Container(width: 50, height: 2, color: Colors.green),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 24),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

            SizedBox(height: screenHeight * 0.02),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF474747),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withOpacity(0.5)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.courseName,
                              style: GoogleFonts.cairo(
                                color: const Color(0xFF45C588),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              widget.courseCode,
                              style: GoogleFonts.cairo(
                                color: const Color(0xFF45C588),
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        Image.asset(
                          'assets/images/UJ_logo.png',
                          height: 40,
                          width: 40,
                          color: Colors.white,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.school, color: Colors.white, size: 40),
                        ),
                      ],
                    ),
                  ),
                  
                  Divider(height: 1, color: Colors.white.withOpacity(0.2)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                    child: TextField(
                      controller: _searchController,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: GoogleFonts.cairo(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'بحث في الفصول',
                        hintStyle: GoogleFonts.cairo(color: Colors.grey[400]),
                        suffixIcon: const Icon(Icons.search, color: Colors.white),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: screenHeight * 0.02),
            
            if (widget.courseCode.contains('432'))
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildLessonCard(
                      title: 'الفصل الخامس',
                      instructor: 'بدر الغامدي',
                      count: '2/1',
                      onTap: () => _navigateToDetails(
                        context, 
                        'الفصل الخامس', 
                        '2/1',
                        videoPath: 'assets/Videos/Chapter5_1of2.mp4',
                      ),
                    ),
                    _buildLessonCard(
                      title: 'الفصل الخامس',
                      instructor: 'بدر الغامدي',
                      count: '2/2',
                      onTap: () => _navigateToDetails(
                        context, 
                        'الفصل الخامس', 
                        '2/2',
                        videoPath: 'assets/Videos/Chapter5_2of2.mp4',
                      ),
                    ),
                  ],
                ),
              )
            else ...[
              SizedBox(height: screenHeight * 0.15),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2C),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'ستتوفر فيديوهات الشرح قريبا',
                  style: GoogleFonts.cairo(
                    color: const Color(0xFF8B88F2),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
            ],
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToDetails(BuildContext context, String title, String count, {String? videoPath}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LessonDetailsScreen(
          lesson: {
            'title': title,
            'courseName': 'الحوسبة المتوازية الموزعة',
            'courseCode': 'CCCS 432',
            'instructor': 'بدر الغامدي',
            'count': count,
            'description': 'في هذا الفيديو نشرح الفصل الخامس من مقرر الحوسبة المتوازية الموزعة (CCCS 432) ضمن خطة جامعة جدة - كلية علوم وهندسة الحاسب، حيث نوضح أساسيات البرمجة المتوازية باستخدام OpenMP مع أمثلة وتطبيقات بسيطة تساعد على فهم المفاهيم وتطبيقها عمليًا.',
            'videoPath': videoPath ?? '', 
          },
        ),
      ),
    );
  }

  Widget _buildLessonCard({
    required String title,
    required String instructor,
    required String count,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF474747),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              color: const Color(0xFFB5A8F8),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              color: const Color(0xFF474747),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      count,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 30,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      instructor,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
