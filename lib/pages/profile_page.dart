import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minesweeper/model/user_model.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
      ),
      body: Container(
        child: Center(
          child: StreamBuilder(
            stream: Firestore.instance.collection("users").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                DocumentSnapshot documentSnapshot = snapshot.data.documents[0];

                User user = User(
                  id: documentSnapshot["user_id"],
                  name: documentSnapshot["name"],
                  email: documentSnapshot["email"],
                  imageUrl: documentSnapshot["image_url"],
                  score: documentSnapshot["score"],
                );

                return _buildUserProfile(user);
              } else if (snapshot.hasError)
                return Text("false");
              else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfile(User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28.0),
      child: Column(
        children: <Widget>[
          Container(
            width: 150.0,
            height: 150.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(user.imageUrl),
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Text(user.name, style: TextStyle(fontSize: 24.0)),
          SizedBox(height: 12.0),
          Text("Highscore: ${user.score}", style: TextStyle(fontSize: 20.0)),
          SizedBox(height: 12.0),
          Text(user.email),
        ],
      ),
    );
  }
}
