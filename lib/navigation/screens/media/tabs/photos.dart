import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pawssion/utils/utils.dart';

class PhotosTab extends StatefulWidget {
  const PhotosTab({super.key});

  @override
  State<PhotosTab> createState() => _PhotosTabState();
}

class _PhotosTabState extends State<PhotosTab> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("photos").snapshots(),
      builder: (context, snapshots) {
        if (!snapshots.hasData) return Utils().circularProgressIndicator();
        if (snapshots.hasError) return const Center(child: Icon(Icons.error));

        var photos = [];
        if (snapshots.hasData) {
          for (var snap in snapshots.data!.docs) {
            photos.add(snap.data());
          }
        }

        if (photos.isEmpty) {
          return const Center(
            child: Text(
              "No photos found...",
              style: TextStyle(fontSize: 18, fontFamily: "Montserrat"),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FirstRow(text: "These are photos of your virtual pets"),
              const SizedBox(height: 30),
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: photos.length,
                  separatorBuilder: (context, index) => const Divider(
                      height: 30, thickness: 0, color: Colors.transparent),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          imageUrl: photos[index]["photoUrl"],
                          placeholder: (context, url) =>
                              Utils().circularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          fit: BoxFit.cover,
                          height: MediaQuery.of(context).size.height * 0.4,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
