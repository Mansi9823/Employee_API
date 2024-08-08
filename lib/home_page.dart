import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:employee_list/model.dart'; // Import your UserDetails model from model.dart

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<UserDetails>> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee List'),
      ),
      body: FutureBuilder<List<UserDetails>>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                UserDetails user = snapshot.data![index];

                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.imageUrl),
                    ),
                    title: Text('${user.firstName} ${user.lastName}'),
                    subtitle: Text('${user.email} - ${user.contactNumber}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserDetailsPage(user: user),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<List<UserDetails>> getData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://hub.dummyapis.com/employee?noofRecords=10&idStarts=1001'));

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body) as List;
        List<UserDetails> userDetailsList =
            jsonData.map((item) => UserDetails.fromJson(item)).toList();
        return userDetailsList;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }
}

class UserDetailsPage extends StatelessWidget {
  final UserDetails user;

  const UserDetailsPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${user.firstName} ${user.lastName} Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${user.id}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Image.network(
              user.imageUrl,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
            ),
            Text('Email: ${user.email}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Contact Number: ${user.contactNumber}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Age: ${user.age}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Date of Birth: ${user.dob}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Salary: ${user.salary}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Address: ${user.address}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
