// To parse this JSON data, do
//
//     final userDetails = userDetailsFromJson(jsonString);

import 'dart:convert';

List<UserDetails> userDetailsFromJson(String str) => List<UserDetails>.from(
    json.decode(str).map((x) => UserDetails.fromJson(x)));

String userDetailsToJson(List<UserDetails> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserDetails {
  int id;
  String imageUrl;
  String firstName;
  String lastName;
  String email;
  String contactNumber;
  int age;
  String dob;
  int salary;
  String address;

  UserDetails({
    required this.id,
    required this.imageUrl,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.contactNumber,
    required this.age,
    required this.dob,
    required this.salary,
    required this.address,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        id: json["id"],
        imageUrl: json["imageUrl"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        contactNumber: json["contactNumber"],
        age: json["age"],
        dob: json["dob"],
        salary: json["salary"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "imageUrl": imageUrl,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "contactNumber": contactNumber,
        "age": age,
        "dob": dob,
        "salary": salary,
        "address": address,
      };
}
