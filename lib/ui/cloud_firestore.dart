import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firestore_search/firestore_search.dart';

class CloudFirestoreSearch extends StatefulWidget {
  @override
  _CloudFirestoreSearchState createState() => _CloudFirestoreSearchState();
}

class _CloudFirestoreSearchState extends State<CloudFirestoreSearch> {
  String name = "";
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Card(
          child: TextField(
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.search), hintText: 'Search...'),
            onChanged: (val) {
              setState(() {
                name = val;
              });
            },
          ),
        ),
      ),
      //     body: StreamBuilder<QuerySnapshot>(
      //       stream: _usersStream,
      //       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //         if (snapshot.hasError) {
      //           return Text('Something went wrong');
      //         }

      //         if (snapshot.connectionState == ConnectionState.waiting) {
      //           return Text("Loading");
      //         }

      //         return ListView(
      //           children: snapshot.data!.docs.map((DocumentSnapshot document) {
      //             Map<String, dynamic> data =
      //                 document.data()! as Map<String, dynamic>;
      //             return ListTile(
      //               title: Text(data['first_name']),
      //               subtitle: Text(data['last_name']),
      //             );
      //           }).toList(),
      //         );
      //       },
      //     ),
      //   );
      // }
      body: StreamBuilder<QuerySnapshot>(
        stream: (name != "" && name != null)
            ? FirebaseFirestore.instance
                .collection('users')
                .where('name', isGreaterThanOrEqualTo: name)
                .snapshots()
            : FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (context, snapshot) {
          return (snapshot.connectionState == ConnectionState.waiting)
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot data = snapshot.data!.docs[index];
                    return Card(
                      child: Row(
                        children: <Widget>[
                          // Image.network(
                          //   data['imageURL'],
                          //   width: 150,
                          //   height: 100,
                          //   fit: BoxFit.fill,
                          // ),
                          SizedBox(
                            width: 25,
                          ),
                          Text(
                            data['first_name'],
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
        },
      ),
    );
  }

  // final TextEditingController searchController = TextEditingController();
  // @override
  // Widget build(BuildContext context){
  //   return Scaffold(floatingActionButton: FloatingActionButton(child: Icon.clear), onPressed: (){}),
  //   backgroundColor: Colors.black,
  //   appBar: AppBar(actions:[

  //   ])
  // }
}
