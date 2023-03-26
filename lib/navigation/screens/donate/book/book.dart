import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pawssion/utils/colors.dart';
import 'package:pawssion/utils/helper.dart';
import 'package:pawssion/utils/utils.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen(
      {super.key, required this.document, required this.animalCollection});
  final document;
  final String animalCollection;

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final TextStyle _textStyle = const TextStyle(
    fontFamily: "Montserrat",
    fontSize: 25,
    fontWeight: FontWeight.bold,
    letterSpacing: 2,
    color: CustomColors.primaryContent,
  );

  int _selectedIndex = 6;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      progressIndicator: Utils().circularProgressIndicator(),
      child: Scaffold(
        backgroundColor: CustomColors.primaryBackground,
        appBar: AppBar(
          backgroundColor: CustomColors.primaryBackground,
          elevation: 10,
          title: Text(
            "Petting ${widget.document["name"]}",
            style: const TextStyle(
              fontFamily: "CarterOne",
              letterSpacing: 2,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: CustomColors.auxilliaryContent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Flexible(
                      flex: 3,
                      child: Hero(
                        tag: "${widget.document["name"]}",
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                            imageUrl: widget.document["photoUrl"],
                            placeholder: (context, url) =>
                                Utils().circularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            fit: BoxFit.cover,
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: MediaQuery.of(context).size.width * 0.4,
                          ),
                        ),
                      ),
                    ),
                    const Flexible(flex: 1, child: SizedBox(width: 40)),
                    Flexible(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          FittedBox(
                            child: Text(
                              "${widget.document["age"]} years old",
                              style: _textStyle.copyWith(
                                color: CustomColors.primaryContent,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          FittedBox(
                            child: Text(
                              "${widget.document["gender"]}",
                              style: _textStyle.copyWith(
                                fontSize: 17,
                                fontWeight: FontWeight.normal,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                          FittedBox(
                            child: Text(
                              "${widget.document["breed"]}",
                              style: _textStyle.copyWith(
                                fontSize: 17,
                                fontWeight: FontWeight.normal,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                          FittedBox(
                            child: Text(
                              "${widget.document["city"]}, ${widget.document["country"]}",
                              style: _textStyle.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(child: SizedBox(height: 10)),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Select duration",
                  style: _textStyle.copyWith(
                    fontSize: 20,
                    color: CustomColors.primaryContent,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 6;
                        });
                      },
                      child: durationButtons(6, _selectedIndex)),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 12;
                        });
                      },
                      child: durationButtons(12, _selectedIndex)),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 24;
                        });
                      },
                      child: durationButtons(24, _selectedIndex)),
                ],
              ),
              const SizedBox(height: 10),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 100;
                    });
                  },
                  child: durationButtons(100, _selectedIndex)),
              const Expanded(child: SizedBox(height: 10)),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColors.auxilliaryContent,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  final String duration =
                      BookFunctions().durationToString(_selectedIndex);

                  await Petting()
                      .pettingFunction(context, widget.document, duration,
                          widget.animalCollection)
                      .whenComplete(() {
                    final snackbar = SnackBar(
                      content: Text("Successfully Petified!",
                          style: _textStyle.copyWith(
                              fontFamily: "CarterOne",
                              fontSize: 14,
                              color: const Color(0xff00a86b))),
                      backgroundColor: Colors.white,
                      duration: const Duration(seconds: 1),
                    );
                    setState(() {
                      _isLoading = false;
                    });
                    //Navigator.pop(context);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(snackbar)
                        .closed
                        .then((value) => Navigator.pop(context));
                  });
                },
                child: Text("Start petting",
                    style: _textStyle.copyWith(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ),
              const Expanded(child: SizedBox(height: 10)),
            ],
          ),
        ),
      ),
    );
  }

  Widget durationButtons(int month, int selectedIndex) {
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(
        color: month == selectedIndex
            ? CustomColors.auxilliaryContent
            : CustomColors.auxilliaryContent.withOpacity(0.4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          month == 100 ? "Lifetime" : "$month Month",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: month == selectedIndex
                ? CustomColors.primaryContent
                : Colors.white70,
          ),
        ),
      ),
    );
  }
}

class BookFunctions {
  String durationToString(int selectedIndex) {
    String duration = "";
    switch (selectedIndex) {
      case 6:
        duration = "6 months";
        break;
      case 12:
        duration = "1 year";
        break;
      case 24:
        duration = "2 years";
        break;
      case 100:
        duration = "permanently";
        break;
      default:
        duration = "6 months";
        break;
    }
    return duration;
  }
}
