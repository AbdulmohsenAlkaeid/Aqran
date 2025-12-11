import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'course_search_screen.dart';
import 'add_course_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  final String userName;
  final int initialNavIndex;
  const MainScreen({super.key, required this.userName, this.initialNavIndex = 1});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _selectedNavIndex;
  late int _selectedDayIndex;
  late List<DateTime> _weekDates;

  final List<String> _weekDayNames = ['أحد', 'أثنين', 'ثلاثاء', 'اربعاء', 'خميس', 'جمعة', 'سبت'];

  @override
  void initState() {
    super.initState();
    _selectedNavIndex = widget.initialNavIndex;
    _initializeWeekDates();
  }

  void _initializeWeekDates() {
    final now = DateTime.now();
    final sunday = now.subtract(Duration(days: now.weekday % 7));
    _weekDates = List.generate(7, (i) => sunday.add(Duration(days: i)));
    _selectedDayIndex = now.weekday % 7;
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
                child: _selectedNavIndex == 1
                    ? _buildHomeContent(screenWidth, screenHeight)
                    : _selectedNavIndex == 0
                        ? const CourseSearchScreen(enableBackButton: false)
                        : const SettingsScreen(),
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

  Widget _buildHomeContent(double screenWidth, double screenHeight) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: screenHeight * 0.03),

          _buildWelcomeMessage(screenWidth),

          SizedBox(height: screenHeight * 0.025),

          _buildNotificationsSection(screenWidth),

          SizedBox(height: screenHeight * 0.025),

          _buildWeekCalendar(screenWidth),

          SizedBox(height: screenHeight * 0.03),

          _buildRequestExplanationSection(screenWidth),

          SizedBox(height: screenHeight * 0.04),
        ],
      ),
    );
  }

  Widget _buildWelcomeMessage(double screenWidth) {
    return Center(
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              'ياهلا فيك ${widget.userName}',
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: GoogleFonts.cairo(
                color: Colors.white,
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Positioned(
            bottom: -5,
            child: Image.asset(
              'assets/images/line.png',
              width: screenWidth * 0.35,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsSection(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'الإشعارات',
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontSize: screenWidth * 0.05,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0x99474747),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'ما عندك إشعارات للآن، استمتع بوقتك',
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: GoogleFonts.cairo(
              color: const Color(0xFF8B88F2), 
              fontSize: screenWidth * 0.035,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeekCalendar(double screenWidth) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (index) {
          final isSelected = index == _selectedDayIndex;
          final date = _weekDates[index];
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDayIndex = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: isSelected
                    ? BoxDecoration(
                        color: const Color(0xFF8B88F2),
                        borderRadius: BorderRadius.circular(50),
                      )
                    : null,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _weekDayNames[index],
                      style: GoogleFonts.cairo(
                        color: Colors.black,
                        fontSize: screenWidth * 0.03,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: isSelected
                          ? const BoxDecoration(
                              color: Color(0xFF121212),
                              shape: BoxShape.circle,
                            )
                          : null,
                      child: Center(
                        child: Text(
                          '${date.day}',
                          style: GoogleFonts.cairo(
                            color: isSelected ? Colors.white : Colors.black,
                            fontSize: screenWidth * 0.038,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildRequestExplanationSection(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'تقديم طلب شرح مادة دراسية',
                textDirection: TextDirection.rtl,
                style: GoogleFonts.cairo(
                  color: const Color(0xFF45C588),
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddCourseScreen(userName: widget.userName),
                  ),
                );
              },
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: Color(0xFF474747),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.white70,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF474747),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'حاب تشرح مادتك المفضلة وتساعد اصدقائك يفهمونها ويبدعون فيها مثلك؟ وعلى فكرة ما نسيناك من الفائدة حتى أنت بتستفيد مثلهم.',
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontSize: screenWidth * 0.038,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
        ),
        
        const SizedBox(height: 20),
        
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedNavIndex = 0;
            });
          },
          child: Container(
            height: 55,
            decoration: BoxDecoration(
              color: const Color(0xFF8B88F2), 
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child: Text(
                'شروحات المواد الدراسية',
                style: GoogleFonts.cairo(
                  color: Colors.black,
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
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
              index: 2,
              assetPath: 'assets/images/settings_icon.png',
              isSelected: _selectedNavIndex == 2,
              onTap: () {
                setState(() {
                  _selectedNavIndex = 2;
                });
              },
            ),
            const SizedBox(width: 15),
            
            _buildNavButton(
              index: 1,
              assetPath: 'assets/images/home_icon.png',
              isSelected: _selectedNavIndex == 1,
              onTap: () {
                setState(() {
                  _selectedNavIndex = 1;
                });
              },
            ),
            const SizedBox(width: 15),
            
            _buildNavButton(
              index: 0,
              assetPath: 'assets/images/course_icon.png',
              isSelected: _selectedNavIndex == 0,
              onTap: () {
                setState(() {
                  _selectedNavIndex = 0;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton({
    required int index,
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
