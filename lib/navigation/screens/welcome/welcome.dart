import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pawssion/utils/colors.dart';
import 'package:pawssion/utils/helper.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: _isLoading,
        color: const Color(0xff1b4d3e),
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
                gradient:
                    LinearGradient(colors: [Colors.black, Color(0xff0e0f26)])),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flexible(
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1)),
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            "Pawssion",
                            style: TextStyle(
                              fontSize: 40,
                              letterSpacing: 2,
                              fontFamily: "CarterOne",
                              color: CustomColors.primaryContent,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Lottie.asset(
                            "assets/19979-dog-steps.json",
                            height: 30,
                            width: 30,
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      const Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: Text(
                          "A pet away from home",
                          style: TextStyle(
                            fontFamily: "CarterOne",
                            letterSpacing: 2,
                            color: CustomColors.tertiaryContent,
                            fontSize: 16,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Flexible(
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2)),
                Lottie.asset("assets/dog-man.json",
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width),
                Flexible(
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 70),
                  child: SignInButton(Buttons.Google,
                      padding: const EdgeInsets.only(left: 30.0),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ), onPressed: () {
                    setState(() {
                      _isLoading = true;
                      GoogleAuth().googleLogInUser(context);
                    });
                  }),
                  // child: SignInButtonBuilder(
                  //   backgroundColor: CustomColors.secondaryContent,
                  //   shape: const RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.all(
                  //       Radius.circular(10),
                  //     ),
                  //   ),
                  //   onPressed: () {
                  //     setState(() {
                  //       _isLoading = true;
                  //       GoogleAuth().googleLogInUser(context);
                  //     });
                  //   },
                  //   text: 'Sign In with Google',
                  //   elevation: 10,
                  //   innerPadding: const EdgeInsets.only(
                  //     right: 30,
                  //     top: 10,
                  //     bottom: 10,
                  //   ),
                  //   textColor: Colors.grey.shade100,
                  // ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
