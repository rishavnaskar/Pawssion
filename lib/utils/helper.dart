import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:pawssion/navigation/navbar.dart';
import 'package:pawssion/navigation/screens/welcome/welcome.dart';
import 'package:pawssion/utils/utils.dart';

class AddPost {
  Future addPost(String title, String description, File? image) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (image == null) {
      await FirebaseFirestore.instance.collection("posts").add({
        "title": title,
        "description": description,
        "createdAt": FieldValue.serverTimestamp(),
        "email": currentUser?.email,
        "name": currentUser?.displayName
      });
    } else {
      String fileName = basename(image.path);
      String downloadLink;
      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref().child(fileName);
      await ref.putFile(image).whenComplete(() async {
        downloadLink = await ref.getDownloadURL();
        FirebaseFirestore.instance.collection("posts").add({
          "title": title,
          "description": description,
          "photoUrl": downloadLink,
          "createdAt": FieldValue.serverTimestamp(),
          "email": currentUser?.email,
          "name": currentUser?.displayName
        });
      });
    }
  }
}

class AuthService {
  handleAuth() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return const NavBar();
          } else {
            return const WelcomeScreen();
          }
        });
  }
}

class GoogleAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googlSignIn = GoogleSignIn();

  void googleLogInUser(BuildContext context) async {
    try {
      final googleSignInAccount = await _googlSignIn.signIn();
      final googleAuth = await googleSignInAccount?.authentication;
      final credential = GoogleAuthProvider.credential(
          idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken);
      await _firebaseAuth
          .signInWithCredential(credential)
          .whenComplete(() async {
        final users = await FirebaseFirestore.instance
            .collection("users")
            .where("email", isEqualTo: googleSignInAccount?.email)
            .get();

        if (users.size == 0) {
          FirebaseFirestore.instance.collection("users").add({
            'email': googleSignInAccount?.email,
            'name': googleSignInAccount?.displayName,
            'id': googleSignInAccount?.id,
            'photoUrl': googleSignInAccount?.photoUrl,
          });
        }
      });
    } catch (e) {
      log(e.toString());
    }
  }

  void googleLogOutUser(BuildContext context) {
    _googlSignIn.signOut();
    _firebaseAuth.signOut();
  }
}

class Petting {
  Future pettingFunction(BuildContext context, var document, String duration,
      String animalCollection) async {
    await uploadHistory(context, document, duration, animalCollection)
        .whenComplete(() async => await sendMail(context, document, duration));
  }

  Future uploadHistory(BuildContext context, var document, String duration,
      String animalCollection) async {
    try {
      final users = await FirebaseFirestore.instance
          .collection("users")
          .where("email", isEqualTo: "rishavnaskar.r@gmail.com")
          .get();
      for (var user in users.docs) {
        user.reference.collection("history").add({
          "time": FieldValue.serverTimestamp(),
          "uuid": document["uuid"],
          "duration": duration,
          "type": animalCollection,
          "name": document["name"],
          "breed": document["breed"],
          "ngo": document["ngo"],
          "photoUrl": document["photoUrl"]
        });
      }
    } catch (exception) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(Utils().errorSnackBar("Error uploading to database"));
      if (kDebugMode) {
        print(exception);
      }
    }
  }

  Future sendMail(BuildContext context, var document, String duration) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn =
        GoogleSignIn(scopes: ['https://mail.google.com/']);
    final email = dotenv.env['email'];
    final accessToken = await googleSignIn.currentUser?.authentication;
    final user = auth.currentUser;

    if (email == null ||
        accessToken == null ||
        accessToken.accessToken == null) {
      log('Cant fetch email or password');
      return;
    }

    final smtpServer = gmailSaslXoauth2(email, accessToken.accessToken!);

    final message = Message()
      ..from = Address(email, 'Pawssion')
      ..recipients.add(user?.email)
      ..subject = 'PetAngle Petting Receipt'
      ..html =
          "<h1>Thank you for petting ${document["name"]}</h1>\n<p>You have successfully adopted ${document["gender"] == "Male" ? "him" : "her"} for $duration</p>\n<p>Your concerned NGO is ${document["ngo"]} and you may contact them for further details</p>\n<p>NGO email - ${document["ngo_email"]}</p>\n<p>Please pay \$27.454 to the respective NGO strictly on monthly basis for $duration</p>\n<p>The NGO will provide you with live videos and status of your pet every week. For issues, you may post in our issues section.</p>";

    try {
      await send(message, smtpServer).whenComplete(() {
        if (kDebugMode) {
          print('Message sent');
        }
      });
    } on MailerException catch (e) {
      if (kDebugMode) {
        print('Message not sent.');
      }
      for (var p in e.problems) {
        if (kDebugMode) {
          print('Problem: ${p.code}: ${p.msg}');
        }
      }
      Navigator.pop(context);
    }
  }
}
