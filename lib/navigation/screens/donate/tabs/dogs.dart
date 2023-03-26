import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pawssion/utils/utils.dart';

class DogsTab extends StatefulWidget {
  const DogsTab({super.key});

  @override
  State<DogsTab> createState() => _DogsTabState();
}

class _DogsTabState extends State<DogsTab> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("dogs").snapshots(),
      builder: (context, snapshots) {
        var documents = [];
        if (!snapshots.hasData) return Utils().circularProgressIndicator();

        if (snapshots.hasData) {
          for (var snap in snapshots.data!.docs) {
            documents.add(snap.data());
          }
        }
        return CardContainer(
          documents: documents,
          context: context,
          animalCollection: "dogs",
        );
      },
    );
  }
}
