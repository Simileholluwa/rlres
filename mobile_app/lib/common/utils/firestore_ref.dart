import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final fireStore = FirebaseFirestore.instance;
final videoRF = fireStore.collection(FirebaseAuth.instance.currentUser!.uid).doc("all_videos").collection("videos");
final historyRF = fireStore.collection(FirebaseAuth.instance.currentUser!.uid).doc("histories").collection("history");
final violatorsRF = fireStore.collection(FirebaseAuth.instance.currentUser!.uid).doc("all_violators").collection("violators");
final userRF = fireStore.collection(FirebaseAuth.instance.currentUser!.uid).doc(FirebaseAuth.instance.currentUser!.uid).collection('videos');
final allViolators = fireStore.collection('all_violators');
final allPlateNumbers = fireStore.collection('plate_numbers');