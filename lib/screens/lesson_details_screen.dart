import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

class LessonDetailsScreen extends StatefulWidget {
  final Map<String, String> lesson;

  const LessonDetailsScreen({super.key, required this.lesson});

  @override
  State<LessonDetailsScreen> createState() => _LessonDetailsScreenState();
}

class _LessonDetailsScreenState extends State<LessonDetailsScreen> {
  VideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;
  bool isPlaying = false;
  double _currentSliderValue = 0.0;
  String _currentDuration = "00:00";
  String _totalDuration = "00:00";
  String? _videoError;

  @override
  void initState() {
    super.initState();
    final videoPath = widget.lesson['videoPath'];
    debugPrint('Video path: $videoPath');
    if (videoPath != null && videoPath.isNotEmpty) {
      _controller = VideoPlayerController.asset(videoPath);
      _initializeVideoPlayerFuture = _controller!.initialize().then((_) {
        debugPrint('Video initialized successfully');
        setState(() {
          _totalDuration = _formatDuration(_controller!.value.duration);
        });
      }).catchError((error) {
        debugPrint('Video initialization error: $error');
        setState(() {
          _videoError = error.toString();
        });
      });

      _controller!.addListener(() {
        if (_controller != null) {
          setState(() {
            isPlaying = _controller!.value.isPlaying;
            _currentSliderValue = _controller!.value.position.inSeconds.toDouble();
            _currentDuration = _formatDuration(_controller!.value.position);
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, screenWidth, screenHeight),
            _buildVideoPlayer(screenWidth, screenHeight),
            Expanded(
              child: _buildLessonDetails(screenWidth),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double screenWidth, double screenHeight) {
    final user = FirebaseAuth.instance.currentUser;
    String firstName = '';
    if (user != null && user.displayName != null && user.displayName!.isNotEmpty) {
      firstName = user.displayName!.split(' ').first;
    }

    return Padding(
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
            icon: const Directionality(
              textDirection: TextDirection.ltr,
              child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 24),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer(double screenWidth, double screenHeight) {
    if (_controller == null || _initializeVideoPlayerFuture == null) {
      return Container(
        width: screenWidth,
        height: screenWidth * 0.6,
        margin: const EdgeInsets.symmetric(vertical: 10),
        color: Colors.black,
        alignment: Alignment.center,
        child: Text("No Video Available", style: GoogleFonts.cairo(color: Colors.white)),
      );
    }

    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError || _videoError != null) {
          return Container(
            width: screenWidth,
            height: screenWidth * 0.6,
            margin: const EdgeInsets.symmetric(vertical: 10),
            color: Colors.black,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 48),
                SizedBox(height: 8),
                Text(
                  "خطأ في تحميل الفيديو",
                  style: GoogleFonts.cairo(color: Colors.white, fontSize: 16),
                ),
                SizedBox(height: 4),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    _videoError ?? snapshot.error.toString(),
                    style: GoogleFonts.cairo(color: Colors.grey, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        }
        
        if (snapshot.connectionState == ConnectionState.done && _controller!.value.isInitialized) {
          return Container(
            width: screenWidth,
            height: screenWidth * 0.6,
            margin: const EdgeInsets.symmetric(vertical: 10),
            color: Colors.black,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                ),
                
                if (!isPlaying)
                  GestureDetector(
                    onTap: () {
                      _controller!.play();
                    },
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xFF45C588).withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.play_arrow, color: Colors.white, size: 50),
                    ),
                  ),
                
                GestureDetector(
                  onTap: () {
                    if (_controller!.value.isPlaying) {
                      _controller!.pause();
                    } else {
                      _controller!.play();
                    }
                  },
                  child: Container(color: Colors.transparent, width: double.infinity, height: double.infinity),
                ),

                Positioned(
                  bottom: 50, 
                  right: 16,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '$_currentDuration / $_totalDuration',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),

                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Column(
                      children: [
                        SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 2,
                            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                            overlayShape: RoundSliderOverlayShape(overlayRadius: 12),
                            activeTrackColor: Color(0xFF45C588),
                            inactiveTrackColor: Colors.grey,
                            thumbColor: Color(0xFF45C588),
                          ),
                          child: Slider(
                            value: _currentSliderValue,
                            min: 0.0,
                            max: _controller!.value.duration.inSeconds.toDouble(),
                            onChanged: (value) {
                              setState(() {
                                _controller!.seekTo(Duration(seconds: value.toInt()));
                              });
                            },
                          ),
                        ),
                        
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0, left: 16, right: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                               IconButton(
                                 icon: Icon(Icons.replay_10, color: Colors.white),
                                 onPressed: () {
                                   final newPos = _controller!.value.position - Duration(seconds: 10);
                                   _controller!.seekTo(newPos);
                                 },
                               ),
                               SizedBox(width: 10),
                               IconButton(
                                 icon: Icon(
                                   isPlaying ? Icons.pause : Icons.play_arrow, 
                                   color: Colors.white, size: 32
                                 ),
                                 onPressed: () {
                                    if (isPlaying) _controller!.pause();
                                    else _controller!.play();
                                 },
                               ),
                               SizedBox(width: 10),
                               IconButton(
                                 icon: Icon(Icons.forward_10, color: Colors.white),
                                 onPressed: () {
                                   final newPos = _controller!.value.position + Duration(seconds: 10);
                                   _controller!.seekTo(newPos);
                                 },
                               ),
                               Spacer(),
                               Icon(Icons.fullscreen, color: Colors.white),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container(
            width: screenWidth,
            height: screenWidth * 0.6,
            color: Colors.black,
            alignment: Alignment.center,
            child: CircularProgressIndicator(color:  Color(0xFF45C588)),
          );
        }
      },
    );
  }

  Widget _buildLessonDetails(double screenWidth) {
    final title = widget.lesson['title'] ?? 'عنوان الدرس';
    final courseName = widget.lesson['courseName'] ?? 'اسم الكورس';
    final courseCode = widget.lesson['courseCode'] ?? 'CODE';
    final instructor = widget.lesson['instructor'] ?? 'المدرب';
    final count = widget.lesson['count'] ?? '1/1';
    final description = widget.lesson['description'] ?? 'وصف الدرس...';

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF474747),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16),
              color: Color(0xFFB5A8F8),
              child: Column(
                children: [
                  Text(
                    courseName,
                    style: GoogleFonts.cairo(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                   Text(
                    courseCode,
                    style: GoogleFonts.cairo(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.5))),
              ),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.5))),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(right: BorderSide(color: Colors.grey.withOpacity(0.5))),
                      ),
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
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'تقديم: $instructor',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
