import 'package:flutter/material.dart';
import 'package:pawssion/navigation/screens/media/tabs/photos.dart';
import 'package:pawssion/navigation/screens/media/tabs/videos.dart';
import 'package:pawssion/utils/colors.dart';

class MediaScreen extends StatefulWidget {
  const MediaScreen({super.key});

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: CustomColors.primaryBackground,
          appBar: AppBar(
              backgroundColor: CustomColors.primaryBackground,
              actions: const [
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text(
                      "Updates from the NGO",
                      style: TextStyle(
                        fontFamily: "CarterOne",
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        letterSpacing: 2,
                        color: CustomColors.primaryContent,
                      ),
                    ),
                  ),
                )
              ],
              elevation: 10,
              bottom: const TabBar(
                indicatorColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.label,
                labelStyle: TextStyle(
                  fontFamily: "CarterOne",
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                  color: CustomColors.primaryContent,
                ),
                tabs: [
                  Tab(text: "Photos"),
                  Tab(text: "Videos"),
                ],
              )),
          body: const TabBarView(
            children: [
              PhotosTab(),
              VideosTab(),
            ],
          ),
        ),
      ),
    );
  }
}
