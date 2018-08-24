import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minesweeper/model/user_model.dart';

class LeaderboardPage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<LeaderboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Leaderboard"),
        centerTitle: true,
      ),
      body: Container(
        child: Center(
          child: StreamBuilder(
            stream: Firestore.instance.collection("users").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<DocumentSnapshot> documentSnapshotsList =
                    snapshot.data.documents;

                List<User> usersList = [];

                documentSnapshotsList.forEach((documentSnapshot) {
                  User user = User(
                    id: documentSnapshot["user_id"],
                    name: documentSnapshot["name"],
                    email: documentSnapshot["email"],
                    imageUrl: documentSnapshot["image_url"],
                    score: documentSnapshot["score"],
                  );

                  usersList.add(user);
                });

                //sort users on the basis of their time score
                usersList
                    .sort((user1, user2) => user1.score.compareTo(user2.score));

                return _buildLeaderboardList(usersList);
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

  Widget _buildLeaderboardList(List<User> usersList) {
    return ListView.builder(
      itemCount: usersList.length,
      itemBuilder: (context, index) {
        User user = usersList[index];

        return Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 8.0, 12.0, 8.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 70.0,
                height: 70.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(user.imageUrl),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                    child: Text(user.name, style: TextStyle(fontSize: 20.0))),
                flex: 3,
              ),
              Expanded(
                child: Container(
                  height: 50.0,
                  width: 50.0,
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    child: Text(user.score.toString(),
                        style: TextStyle(fontSize: 24.0)),
                  ),
                ),
                flex: 1,
              ),
            ],
          ),
        );
      },
    );
  }
}
