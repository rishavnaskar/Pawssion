import 'package:flutter/material.dart';
import 'package:pawssion/navigation/screens/donate/tabs/birds.dart';
import 'package:pawssion/navigation/screens/donate/tabs/cats.dart';
import 'package:pawssion/navigation/screens/donate/tabs/dogs.dart';
import 'package:pawssion/utils/colors.dart';

class DonateScreen extends StatefulWidget {
  const DonateScreen({super.key});

  @override
  State<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: CustomColors.primaryBackground,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: AppBar(
                backgroundColor: CustomColors.primaryBackground,
                elevation: 10,
                bottom: const TabBar(
                  indicatorColor: CustomColors.primaryContent,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelStyle: TextStyle(
                      fontFamily: "CarterOne",
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3),
                  tabs: [
                    Tab(text: "Dogs"),
                    Tab(text: "Cats"),
                    Tab(text: "Birds")
                  ],
                )),
          ),
          body: const TabBarView(
            children: [DogsTab(), CatsTab(), BirdsTab()],
          ),
        ),
      ),
    );
  }
}
