import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/screens/profile.dart';
import 'package:chatapp/services/dbdata.dart';
import 'package:chatapp/utils/colors.dart';
import 'package:chatapp/utils/constants.dart';
import 'package:chatapp/utils/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SocialSetting extends StatefulWidget {
  static String tag = '/SocialSetting';

  @override
  SocialSettingState createState() => SocialSettingState();
}

class SocialSettingState extends State<SocialSetting> {
  Widget mStatus() {
    var width = MediaQuery.of(context).size.width;
    return Container(
      decoration: boxDecoration(radius: spacing_middle),
      padding: EdgeInsets.all(spacing_middle),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SocialProfile()));
            },
            child: Stack(
              alignment: Alignment.bottomRight,
              children: <Widget>[
                ClipRRect(
                  borderRadius:
                      BorderRadius.all(Radius.circular(spacing_middle)),
                  child: CachedNetworkImage(
                    imageUrl: profileimg,
                    height: width * 0.14,
                    width: width * 0.14,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(spacing_middle)),
                      color: social_colorPrimary),
                  child: Icon(
                    Icons.add,
                    color: social_white,
                    size: 20,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: spacing_middle,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                text(name, fontFamily: fontMedium),
                text(status, textColor: social_textColorSecondary),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: social_app_background_color,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            mToolbar(context, "SETTINGS", "images/social_ic_logout.svg",
                tags: "logout"),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(spacing_standard_new),
                  child: Column(
                    children: <Widget>[
                      mStatus(),
                      Container(
                        padding: EdgeInsets.all(spacing_middle),
                        margin: EdgeInsets.only(
                            top: spacing_standard_new,
                            bottom: spacing_standard_new),
                        decoration: boxDecoration(showShadow: true),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SocialOption(
                              context,
                              social_blue,
                              "images/social_key.svg",
                              "Account",
                              "Privacy, security, change...",
                            ),
                            SizedBox(
                              height: spacing_standard_new,
                            ),
                            SocialOption(
                                context,
                                social_blue,
                                "images/social_ic_help.svg",
                                "Help",
                                "FAQ, contact us, privacy..."),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(spacing_middle),
                        decoration: boxDecoration(showShadow: true),
                        child: SocialOption(
                            context,
                            social_dark_yellow,
                            "images/social_group_line.svg",
                            "Invite Friends",
                            "Invite new friends and talk.."),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
