import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawssion/navigation/screens/donate/Book/book.dart';
import 'package:pawssion/utils/colors.dart';
import 'package:pawssion/utils/helper.dart';

class Utils {
  Widget circularProgressIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          Color(0xff00a86b),
        ),
      ),
    );
  }

  Widget donateCards(String text, TextStyle textStyle) {
    return FittedBox(
      child: Text(
        text,
        textAlign: TextAlign.end,
        style: textStyle,
      ),
    );
  }

  SnackBar errorSnackBar(String text) {
    return SnackBar(
      content: Text(text),
    );
  }

  TextStyle textStyle() {
    return const TextStyle(
        color: Colors.white,
        fontFamily: "Montserrat",
        fontSize: 16,
        letterSpacing: 2,
        fontWeight: FontWeight.bold);
  }
}

class AlertDialogBox extends StatefulWidget {
  const AlertDialogBox({super.key});

  @override
  State<AlertDialogBox> createState() => _AlertDialogBoxState();
}

class _AlertDialogBoxState extends State<AlertDialogBox> {
  late String title, content;
  File? _image;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: CustomColors.primaryBackground,
      title: const Text(
        "Add a new post",
        style: TextStyle(
          fontFamily: "CarterOne",
          color: CustomColors.primaryContent,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              style: const TextStyle(color: Colors.white70),
              decoration: const InputDecoration(
                hintText: "Caption is half of the post",
                hintStyle: TextStyle(color: Colors.white24),
                labelText: "Title",
                labelStyle: TextStyle(
                  fontFamily: "Montserrat",
                  color: Colors.white70,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: CustomColors.secondaryContent),
                ),
              ),
              cursorColor: CustomColors.secondaryContent,
              onChanged: (value) {
                setState(() {
                  title = value;
                });
              },
            ),
            const SizedBox(height: 30),
            TextField(
              style: const TextStyle(color: Colors.white70),
              decoration: const InputDecoration(
                hintText: "Keep a brief content",
                hintStyle: TextStyle(color: Colors.white24),
                labelText: "Content",
                labelStyle: TextStyle(
                  fontFamily: "Montserrat",
                  color: Colors.white70,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: CustomColors.secondaryContent),
                ),
              ),
              cursorColor: CustomColors.secondaryContent,
              onChanged: (value) {
                setState(() {
                  content = value;
                });
              },
            ),
            const SizedBox(height: 30),
            IconButton(
                icon: const Icon(
                  Icons.add_a_photo,
                  color: Colors.white70,
                ),
                onPressed: () => _imgFromGallery()),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white70,
                ),
              ),
              child: _image == null
                  ? Center(
                      child: IconButton(
                      icon: const Icon(
                        Icons.image_not_supported,
                        color: Colors.white70,
                      ),
                      onPressed: () => _imgFromGallery(),
                    ))
                  : ClipRRect(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.file(
                          _image!,
                          width: MediaQuery.of(context).size.width * 0.8,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: CustomColors.secondaryContent,
          ),
          child: Text(
            "Cancel",
            style: Utils().textStyle().copyWith(
                  fontSize: 14,
                  color: CustomColors.primaryContent,
                ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                      content: Utils().circularProgressIndicator());
                });
            if (title.isEmpty || content.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Please fill all the fields",
                    style: TextStyle(
                      fontFamily: "CarterOne",
                      fontSize: 14,
                      color: Color(0xff00a86b),
                    ),
                  ),
                ),
              );
              Navigator.pop(context);
            } else {
              AddPost().addPost(title, content, _image!).whenComplete(() {
                Navigator.pop(context);
                Navigator.pop(context);
              });
            }
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: CustomColors.secondaryContent),
          child: Text(
            "Add",
            style: Utils().textStyle().copyWith(
                  fontSize: 14,
                  color: CustomColors.primaryContent,
                ),
          ),
        ),
      ],
    );
  }

  _imgFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        if (kDebugMode) {
          print('No image selected.');
        }
      }
    });
  }
}

class CardContent extends StatefulWidget {
  const CardContent(
      {Key? key,
      required this.documents,
      required this.animalCollection,
      required TextStyle textStyle,
      required this.context})
      : _textStyle = textStyle,
        super(key: key);

  final List documents;
  final TextStyle _textStyle;
  final BuildContext context;
  final String animalCollection;

  @override
  State<CardContent> createState() => _CardContentState();
}

class _CardContentState extends State<CardContent> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        separatorBuilder: (context, index) =>
            const Divider(height: 40, thickness: 0, color: Colors.transparent),
        itemCount: widget.documents.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => BookingScreen(
                        document: widget.documents[index],
                        animalCollection: widget.animalCollection))),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: CustomColors.auxilliaryContent,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    spreadRadius: 0.00001,
                    blurRadius: 5,
                    offset: const Offset(5, 5),
                  )
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: [
                    Flexible(
                      flex: 3,
                      child: Hero(
                        tag: "${widget.documents[index]["name"]}",
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                            imageUrl: widget.documents[index]["photoUrl"],
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
                    const Spacer(),
                    Flexible(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Utils().donateCards(widget.documents[index]["name"],
                                widget._textStyle.copyWith(fontSize: 25)),
                            const Flexible(child: SizedBox(height: 40)),
                            Utils().donateCards(
                                "${widget.documents[index]["age"]} years old",
                                widget._textStyle),
                            Utils().donateCards(
                                widget.documents[index]["breed"],
                                widget._textStyle),
                            Utils().donateCards(
                                "${widget.documents[index]["city"]}, ${widget.documents[index]["country"]}",
                                widget._textStyle),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CardContainer extends StatelessWidget {
  const CardContainer(
      {Key? key,
      required this.documents,
      required this.context,
      required this.animalCollection})
      : super(key: key);

  final List documents;
  final BuildContext context;
  final String animalCollection;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Tap on a card to see petting options",
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 20),
          CardContent(
            documents: documents,
            animalCollection: animalCollection,
            textStyle: Utils().textStyle(),
            context: context,
          ),
        ],
      ),
    );
  }
}

class FirstRow extends StatelessWidget {
  const FirstRow({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: FittedBox(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: "Montserrat",
                fontSize: 18,
                color: Colors.white54,
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        const Icon(Icons.arrow_downward)
      ],
    );
  }
}
