import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pawssion/utils/colors.dart';
import 'package:pawssion/utils/utils.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final _textStyle = const TextStyle(
    fontFamily: "Montserrat",
    letterSpacing: 2,
    fontWeight: FontWeight.bold,
    fontSize: 22,
    color: CustomColors.primaryContent,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: CustomColors.primaryBackground,
        actions: [
          Center(
            child: Text(
              "Add Post",
              style: _textStyle.copyWith(
                fontSize: 16,
                fontFamily: "CarterOne",
                color: CustomColors.primaryContent,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: CircleAvatar(
              backgroundColor: Colors.transparent.withOpacity(0.2),
              child: IconButton(
                icon: const Icon(Icons.add_circle),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return const AlertDialogBox();
                      });
                },
                color: CustomColors.primaryContent,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("posts")
                .orderBy("createdAt", descending: true)
                .snapshots(),
            builder: (context, snapshots) {
              if (!snapshots.hasData) {
                return Utils().circularProgressIndicator();
              }
              if (snapshots.hasError) {
                return const Center(child: Icon(Icons.error));
              }

              var posts = [];
              if (snapshots.hasData) {
                for (var snap in snapshots.data!.docs) {
                  posts.add(snap.data());
                }
              }

              if (posts.isEmpty) {
                return const Center(child: Text("No data found"));
              }

              return ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: posts.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 70,
                  thickness: 0,
                  color: CustomColors.tertiaryContent,
                ),
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          posts[index]["photoUrl"] == null
                              ? Center(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Center(
                                      child: Lottie.asset(
                                          "assets/70-image-icon-tadah.json"),
                                    ),
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CachedNetworkImage(
                                    imageUrl: posts[index]["photoUrl"],
                                    placeholder: (context, url) =>
                                        Utils().circularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    fit: BoxFit.cover,
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                  ),
                                ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                  posts[index]["title"] ?? "",
                                  textAlign: TextAlign.end,
                                  maxLines: 3,
                                  style: _textStyle.copyWith(
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  posts[index]["description"] ?? "",
                                  textAlign: TextAlign.end,
                                  maxLines: 10,
                                  overflow: TextOverflow.ellipsis,
                                  style: _textStyle.copyWith(
                                    fontSize: 14,
                                    color: Colors.white38,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1),
                        child: Row(
                          children: [
                            Text(
                              "Posted ${DateTime.now().difference(DateTime.parse(posts[index]["createdAt"].toDate().toString())).inDays.toString()} days ago",
                              style: const TextStyle(
                                fontFamily: "Montserrat",
                                color: CustomColors.tertiaryContent,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              posts[index]["name"],
                              style: const TextStyle(
                                fontFamily: "Montserrat",
                                color: CustomColors.tertiaryContent,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
