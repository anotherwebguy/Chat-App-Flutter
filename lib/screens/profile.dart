import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/services/dbdata.dart';
import 'package:chatapp/utils/colors.dart';
import 'package:chatapp/utils/constants.dart';
import 'package:chatapp/utils/extensions.dart';
import 'package:chatapp/utils/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SocialProfile extends StatefulWidget {
  static String tag = '/SocialProfile';

  @override
  SocialProfileState createState() => SocialProfileState();
}

class SocialProfileState extends State<SocialProfile> {
  Widget mOption(var value, var icon, {var tag}) {
    return GestureDetector(
      onTap: () {
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding:
            EdgeInsets.fromLTRB(spacing_standard, 16, spacing_standard, 16),
        decoration: boxDecoration(showShadow: false, color: social_view_color),
        child: RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(
                    icon,
                    color: social_textColorPrimary,
                    size: 18,
                  ),
                ),
              ),
              TextSpan(
                  text: value,
                  style: TextStyle(
                    color: social_textColorPrimary,
                    fontSize: textSizeMedium,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget mProfile() {
    var width = MediaQuery.of(context).size.width;
    return Stack(
      alignment: Alignment.bottomRight,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(spacing_middle)),
          child: CachedNetworkImage(
            imageUrl: profileimg,
            height: width * 0.25,
            width: width * 0.25,
            fit: BoxFit.fill,
          ),
        ),
        Container(
          width: width * 0.075,
          padding: EdgeInsets.all(
            width * 0.01,
          ),
          alignment: Alignment.bottomRight,
          decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.only(topLeft: Radius.circular(spacing_middle)),
              color: social_colorPrimary),
          child: Icon(
            Icons.camera,
            color: social_white,
            size: 16,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    changeStatusColor(social_white);
    return Scaffold(
      backgroundColor: social_app_background_color,
      floatingActionButton: Container(
        width: width * 0.2,
        height: width * 0.2,
        alignment: Alignment.bottomRight,
        child: Image.asset(
          "images/social_fab_edit.png",
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            mTop(context, "ACCOUNT"),
            Expanded(
              child: SingleChildScrollView(
                  child: Container(
                margin: EdgeInsets.all(spacing_standard_new),
                child: Column(
                  children: <Widget>[
                    mProfile(),
                    SizedBox(
                      height: spacing_standard_new,
                    ),
                    mOption(name, Icons.person_outline,),
                    text(
                        "social info this is not your username or pin this name be visible to your whatsapp contacts",
                        textColor: social_textColorSecondary,
                        isLongText: true),
                    SizedBox(
                      height: spacing_standard_new,
                    ),
                    mOption(status, Icons.help_outline),
                    SizedBox(
                      height: spacing_standard_new,
                    ),
                    mOption(phone, Icons.call),
                    SizedBox(
                      height: spacing_standard_new,
                    ),
                    mOption(email, Icons.alternate_email),
                  ],
                ),
              )),
            )
          ],
        ),
      ),
    );
  }
}
