import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CourseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> submitCourseRequest({
    required String courseName,
    required String courseCode,
    required String coursePrefix,
    required String userName,
    required bool hasFinished,
    String? grade,
    String? details,
    String? selectedPart,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('يجب تسجيل الدخول أولاً');
    }

    try {
      await _firestore.collection('courses').add({
        'title': courseName,
        'code': courseCode,
        'prefix': coursePrefix,
        'instructorName': userName,
        'instructorId': user.uid,
        'status': 'pending', // pending, approved, rejected
        'hasCompletedCourse': hasFinished,
        'grade': grade,
        'details': details,
        'scope': selectedPart ?? 'Unknown',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('فشل في تقديم الطلب: $e');
    }
  }

  Stream<QuerySnapshot> getApprovedCourses() {
    return _firestore
        .collection('courses')
        .where('status', isEqualTo: 'approved')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getAllCourses() {
    return _firestore
        .collection('courses')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getUserCourses() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _firestore
        .collection('courses')
        .where('instructorId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
