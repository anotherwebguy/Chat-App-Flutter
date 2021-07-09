import 'package:chatapp/screens/homechats.dart';
import 'package:chatapp/screens/homestatus.dart';
import 'package:chatapp/screens/searchusers.dart';
import 'package:chatapp/utils/colors.dart';
import 'package:chatapp/utils/constants.dart';
import 'package:chatapp/utils/extensions.dart';
import 'package:chatapp/utils/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SocialDashboard extends StatefulWidget {
  static String tag = '/SocialDashboard';

  @override
  SocialDashboardState createState() => SocialDashboardState();
}

class SocialDashboardState extends State<SocialDashboard> {
  int selectedPos = 1;

  @override
  void initState() {
    super.initState();
    selectedPos = 1;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    changeStatusColor(social_white);

    return Scaffold(
        floatingActionButton: selectedPos == 2
            ? Container(
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    GestureDetector(
                        onTap: () {},
                        child: Image.asset("images/social_fab_edit.png",
                            width: width * 0.2, height: width * 0.2)),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Search()));
                        },
                        child: Image.asset("images/social_fab_msg.png",
                            width: width * 0.2, height: width * 0.2)),
                  ],
                ),
              )
            : Container(
                width: width * 0.2,
                height: width * 0.2,
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Search()));
                    },
                    child: Image.asset("images/social_fab_msg.png")),
              ),
        backgroundColor: social_app_background_color,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              mToolbar(context, "INMOOD", "images/social_ic_setting.svg",
                  tags: "SocialSetting"),
              SizedBox(height: spacing_standard_new),
              Container(
                width: width,
                decoration: boxDecoration(showShadow: true),
                margin: EdgeInsets.only(
                    right: spacing_standard_new, left: spacing_standard_new),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: GestureDetector(
                        onTap: () {
                          selectedPos = 1;
                          setState(() {});
                        },
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          width: width,
                          child: text(
                            "Chats",
                            fontFamily: fontMedium,
                            isCentered: true,
                            textColor: selectedPos == 1
                                ? social_textColorPrimary
                                : social_textColorSecondary,
                          ),
                        ),
                      ),
                      flex: 1,
                    ),
                    Container(
                        width: 1,
                        height: width * 0.1,
                        color: social_view_color),
                    Flexible(
                      child: GestureDetector(
                        onTap: () {
                          selectedPos = 2;
                          setState(() {});
                        },
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          width: width,
                          child: text("Status",
                              isCentered: true,
                              fontFamily: fontMedium,
                              textColor: selectedPos == 2
                                  ? social_textColorPrimary
                                  : social_textColorSecondary),
                        ),
                      ),
                      flex: 1,
                    ),
                  ],
                ),
              ),
              SizedBox(height: spacing_standard),
              if (selectedPos == 1) SocialHomeChats(),
              if (selectedPos == 2) SocialHomeStatus(),
            ],
          ),
        ));
  }
}
