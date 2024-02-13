import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  late String id;
  late String username;
  late double points;
  late String countryName;
  late String countryFlagCode;
  UserModel({
    required this.id,
    required this.points,
    required this.username,
    required this.countryFlagCode,
    required this.countryName,
  }); 

  UserModel.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    id = documentSnapshot.id;
    username = documentSnapshot['username'];
    points = documentSnapshot['points'];
    countryName = documentSnapshot['country'];
    countryFlagCode = documentSnapshot['countryCode'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'points': points,
      'country': countryName,
      'countryCode': countryFlagCode,
    };
  }
}
