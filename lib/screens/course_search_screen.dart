import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'lessons_screen.dart';

class CourseSearchScreen extends StatefulWidget {
  final bool enableBackButton;
  const CourseSearchScreen({super.key, this.enableBackButton = true});

  @override
  State<CourseSearchScreen> createState() => _CourseSearchScreenState();
}

class _CourseSearchScreenState extends State<CourseSearchScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SizedBox(
              height: screenHeight * 0.6,
              child: Image.asset(
                'assets/images/main.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          
          Column(
            children: [
              _buildHeader(context, screenWidth, screenHeight),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.02),

                      _buildCourseGrid(screenWidth, screenHeight),

                      SizedBox(height: screenHeight * 0.03),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double screenWidth, double screenHeight) {
    final rectWidth = screenWidth * 1.15;
    final rectHeight = screenHeight * 0.35;
    
    return SizedBox(
      width: screenWidth,
      height: screenHeight * 0.25, 
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: -screenWidth * 0.05,
            top: -screenHeight * 0.05,
            child: Image.asset(
              'assets/images/rectangle.png',
              width: rectWidth,
              height: rectHeight,
              fit: BoxFit.fill,
              color: const Color(0xFFB5A8F8),
              colorBlendMode: BlendMode.srcATop,
            ),
          ),

          if (widget.enableBackButton)
            Positioned(
              left: 16,
              top: screenHeight * 0.05,
              child: SafeArea(
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          
          Positioned(
            top: screenHeight * 0.02,
            left: screenWidth * 0.08,
            right: screenWidth * 0.08,
            child: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF474747).withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'وش حاب تتعلم اليوم ؟',
                        style: GoogleFonts.cairo(
                          color: const Color(0xFF45C588),
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    
                    Container(
                      height: 1,
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    
                    TextField(
                      controller: _searchController,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        hintText: 'بحث',
                        hintStyle: GoogleFonts.cairo(
                          color: Colors.grey[400],
                          fontSize: 16,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 24,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseGrid(double screenWidth, double screenHeight) {
    final courses = [
      {
        'name': 'مقدمة برمجة',
        'code': 'CCCS 111',
      },
      {
        'name': 'الحوسبة المتوازية\nالموزعة',
        'code': 'CCCS 432',
      },
      {
        'name': 'بناء المترجمات',
        'code': 'CCCS 417',
      },
      {
        'name': 'البرمجة الشيئية',
        'code': 'CCCS 121',
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.25,
        ),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return _buildCourseCard(
            courses[index]['name']!,
            courses[index]['code']!,
            screenWidth,
          );
        },
      ),
    );
  }

  Widget _buildCourseCard(String name, String code, double screenWidth) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => LessonsScreen(
              courseName: name,
              courseCode: code,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E).withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white, width: 1.5),
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
            children: [
                Positioned.fill(
                    child: Opacity(
                        opacity: 0.1,
                        child: Image.asset(
                            'assets/images/UJ_logo.png',
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => const SizedBox(),
                        ),
                    ),
                ),
                
                Positioned.fill(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            name,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.cairo(
                              color: const Color(0xFF45C588),
                              fontSize: screenWidth * 0.032,
                              fontWeight: FontWeight.w700,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            code,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.cairo(
                              color: const Color(0xFF45C588),
                              fontSize: screenWidth * 0.038,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
        ),
      ),
    );
  }
}
