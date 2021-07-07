import 'package:chatapp/utils/codePicker/country_code_picker.dart';
import 'package:chatapp/utils/colors.dart';
import 'package:chatapp/utils/constants.dart';
import 'package:chatapp/utils/extensions.dart';
import 'package:chatapp/utils/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SocialSignIn extends StatefulWidget {
  static String tag = '/SocialSignIn';

  @override
  SocialSignInState createState() => SocialSignInState();
}

class SocialSignInState extends State<SocialSignIn> {
  @override
  Widget build(BuildContext context) {
    changeStatusColor(social_white);
    return Scaffold(
      backgroundColor: social_app_background_color,
      body: SafeArea(
          child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              mTop(context, ""),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(left: spacing_standard_new, right: spacing_standard_new),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: spacing_large),
                        Center(child: text("Welcome", fontFamily: fontBold, fontSize: textSizeLarge)),
                        SizedBox(height: spacing_middle),
                        text("Enter your phone number to continue to inMood Messenger and enjoy messaging and calling to all your friend", isLongText: true, isCentered: true),
                        SizedBox(height: spacing_large),
                        Row(
                          children: <Widget>[
                            Container(
                              decoration: boxDecoration(showShadow: false, bgColor: social_app_background_color, radius: 8, color: social_view_color),
                              padding: EdgeInsets.all(0),
                              child: CountryCodePicker(onChanged: print, showFlag: true, padding: EdgeInsets.all(0)),
                            ),
                            SizedBox(width: spacing_standard_new),
                            Expanded(
                              child: Container(
                                decoration: boxDecoration(showShadow: false, bgColor: social_app_background_color, radius: 8, color: social_view_color),
                                padding: EdgeInsets.all(0),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  maxLength: 10,
                                  style: TextStyle(fontSize: textSizeLargeMedium, fontFamily: fontRegular),
                                  decoration: InputDecoration(
                                    counterText: "",
                                    contentPadding: EdgeInsets.fromLTRB(16, 12, 16, 0),
                                    hintText: "Mobile Number",
                                    prefixIcon: Icon(Icons.call),
                                    hintStyle: TextStyle(color: social_textColorSecondary, fontSize: textSizeMedium),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: spacing_large),
                        SocialAppButton(
                          onPressed: () {
                            //launchScreen(context, SocialDashboard.tag);
                          },
                          textContent: "Continue",
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(bottom: spacing_standard_new),
            alignment: Alignment.bottomCenter,
            child: text("Your form submission is subjected \n to our Privacy and Policy", textColor: social_textColorSecondary, isCentered: true, isLongText: true),
          )
        ],
      )),
    );
  }
}
