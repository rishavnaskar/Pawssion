import 'package:better_player/better_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pawssion/utils/utils.dart';

class VideosTab extends StatefulWidget {
  const VideosTab({super.key});

  @override
  State<VideosTab> createState() => _VideosTabState();
}

class _VideosTabState extends State<VideosTab> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("videos").snapshots(),
      builder: (context, snapshots) {
        if (!snapshots.hasData) return Utils().circularProgressIndicator();
        if (snapshots.hasError) return const Center(child: Icon(Icons.error));

        var videos = [];
        if (snapshots.hasData) {
          for (var snap in snapshots.data!.docs) {
            videos.add(snap.data());
          }
        }

        if (videos.isEmpty) {
          return const Center(
            child: Text(
              "No videos found...",
              style: TextStyle(fontSize: 18, fontFamily: "Montserrat"),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FirstRow(text: "These are videos of your virtual pets"),
              const SizedBox(height: 30),
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: videos.length,
                  separatorBuilder: (context, index) => const Divider(
                      height: 30, thickness: 0, color: Colors.transparent),
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: BetterPlayer.network(
                          videos[index]["photoUrl"],
                          betterPlayerConfiguration:
                              const BetterPlayerConfiguration(
                            aspectRatio: 16 / 9,
                          ),
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
