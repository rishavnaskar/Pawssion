import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pawssion/utils/utils.dart';

class CatsTab extends StatefulWidget {
  const CatsTab({super.key});

  @override
  State<CatsTab> createState() => _CatsTabState();
}

class _CatsTabState extends State<CatsTab> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("cats").snapshots(),
      builder: (context, snapshots) {
        var documents = [];
        if (!snapshots.hasData) return Utils().circularProgressIndicator();

        if (snapshots.hasData) {
          for (var snap in snapshots.data!.docs) {
            documents.add(snap.data());
          }
        }
        return CardContainer(
            documents: documents, context: context, animalCollection: "cats");
      },
    );
  }
}
