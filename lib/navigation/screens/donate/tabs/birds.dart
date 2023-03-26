import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pawssion/utils/utils.dart';

class BirdsTab extends StatefulWidget {
  const BirdsTab({super.key});

  @override
  State<BirdsTab> createState() => _BirdsTabState();
}

class _BirdsTabState extends State<BirdsTab> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("birds").snapshots(),
      builder: (context, snapshots) {
        var documents = [];
        if (!snapshots.hasData) return Utils().circularProgressIndicator();

        if (snapshots.hasData) {
          for (var snap in snapshots.data!.docs) {
            documents.add(snap.data());
          }
        }
        return CardContainer(
            documents: documents, context: context, animalCollection: "birds");
      },
    );
  }
}
