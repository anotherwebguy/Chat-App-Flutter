import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/screens/signin.dart';
import 'package:chatapp/utils/colors.dart';
import 'package:chatapp/utils/constants.dart';
import 'package:chatapp/utils/extensions.dart';
import 'package:chatapp/utils/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SocialWalkThrough extends StatefulWidget {
  static String tag = '/SocialWalkThrough';

  @override
  SocialWalkThroughState createState() => SocialWalkThroughState();
}

class SocialWalkThroughState extends State<SocialWalkThrough> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: social_app_background_color,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      text("Welcome to ",
                          fontFamily: fontBold, fontSize: textSizeLarge),
                      Image.asset("images/walk.png",height: 50,width: 150,)    
                    ],
                  ),
                  SizedBox(height: spacing_xxLarge),
                  CachedNetworkImage(
                      imageUrl:
                          "https://image.freepik.com/free-vector/conversation-concept-illustration-flat-style-communication-chat-conversation_198838-120.jpg",
                      height: width * 0.55),
                  SizedBox(height: spacing_xxLarge),
                  Container(
                    margin: EdgeInsets.only(
                        left: spacing_standard_new,
                        right: spacing_standard_new),
                    child: text(
                        "Read our Privacy Policy. Tap Agree and Continue to accept the Terms of Services.",
                        isLongText: true,
                        textColor: social_textColorSecondary,
                        isCentered: true),
                  ),
                  SizedBox(height: spacing_xxLarge),
                  Container(
                    margin: EdgeInsets.only(
                        left: spacing_standard_new,
                        right: spacing_standard_new),
                    child: SocialAppButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SocialSignIn()));
                      },
                      textContent: "Agree & Continue",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
