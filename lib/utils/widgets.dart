import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/auth/authentication.dart';
import 'package:chatapp/screens/photo.dart';
import 'package:chatapp/screens/settings.dart';
import 'package:chatapp/utils/colors.dart';
import 'package:chatapp/utils/constants.dart';
import 'package:chatapp/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget text(String text,
    {var fontSize = textSizeMedium,
    textColor = social_textColorPrimary,
    var fontFamily = fontRegular,
    var isCentered = false,
    var maxLine = 1,
    var latterSpacing = 0.25,
    var textAllCaps = false,
    var isLongText = false}) {
  return Text(
    textAllCaps ? text.toUpperCase() : text,
    textAlign: isCentered ? TextAlign.center : TextAlign.start,
    maxLines: isLongText ? null : maxLine,
    style: TextStyle(fontFamily: fontFamily, fontSize: fontSize, color: textColor, height: 1.5, letterSpacing: latterSpacing),
  );
}

BoxDecoration boxDecoration({double radius = spacing_middle, Color color = Colors.transparent, Color bgColor = social_white, var showShadow = false}) {
  return BoxDecoration(
    color: bgColor,
    boxShadow: showShadow ? [BoxShadow(color: social_ShadowColor, blurRadius: 10, spreadRadius: 2)] : [BoxShadow(color: Colors.transparent)],
    border: Border.all(color: color),
    borderRadius: BorderRadius.all(Radius.circular(radius)),
  );
}

Widget imageMessage(context,imageUrlFromFB) {
  return Container(
    width: 160,
    height: 160,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => FullPhoto(url: imageUrlFromFB)));
      },
      child: CachedNetworkImage(
        imageUrl: imageUrlFromFB,
        placeholder: (context, url) => Container(
          transform: Matrix4.translationValues(0, 0, 0),
          child: Container( width: 60, height: 80,
              child: Center(child: new CircularProgressIndicator())),
        ),
        errorWidget: (context, url, error) => new Icon(Icons.error),
        width: 60,
        height: 80,
        fit: BoxFit.cover,
      ),
    ),
  );
}

class SocialAppButton extends StatefulWidget {
  var textContent;
  VoidCallback onPressed;

  SocialAppButton({@required this.textContent, @required this.onPressed});

  @override
  State<StatefulWidget> createState() {
    return SocialAppButtonState();
  }
}

class SocialAppButtonState extends State<SocialAppButton> {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: widget.onPressed,
      textColor: social_white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      padding: const EdgeInsets.all(0.0),
      child: Container(
        decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8.0)), color: social_colorPrimary),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: widget.textContent, style: TextStyle(fontSize: textSizeMedium)),
                  WidgetSpan(
                    child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0), child: Icon(Icons.arrow_forward, color: social_white, size: 16)),
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

Widget SocialOption(BuildContext context, var color, var icon, var value, var subValue, {var tags}) {
  var width = MediaQuery.of(context).size.width;
  return GestureDetector(
    onTap: () {
    },
    child: Row(
      children: <Widget>[
        Container(
          decoration: boxDecoration(showShadow: false, radius: spacing_middle, bgColor: color),
          width: width * 0.13,
          height: width * 0.13,
          padding: EdgeInsets.all(spacing_middle),
          child: SvgPicture.asset(icon, color: social_white),
        ),
        SizedBox(width: spacing_middle),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[text(value, fontFamily: fontMedium), text(subValue, textColor: social_textColorSecondary, isLongText: false)],
          ),
        )
      ],
    ),
  );
}

Widget mToolbar(BuildContext context, var title, var icon, {var tags}) {
  var width = MediaQuery.of(context).size.width;
  return Container(
    width: MediaQuery.of(context).size.width,
    height: width * 0.15,
    color: social_white,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        title=="INMOOD"? Container():GestureDetector(
          onTap: () {
            back(context);
          },
          child: Container(
            margin: EdgeInsets.only(left: spacing_standard_new),
            width: width * 0.1,
            height: width * 0.1,
            decoration: boxDecoration(showShadow: false, bgColor: social_colorPrimary),
            child: Icon(Icons.keyboard_arrow_left, color: social_white),
          ),
        ),
        Center(
          child: title=="INMOOD"? Row(
            children: [
              SizedBox(width:22),
              Image.asset("images/walk.png",height: 40,width: 150,),
            ],
          ):text(title, fontFamily: fontBold, fontSize: textSizeLargeMedium, textAllCaps: true),
        ),
        GestureDetector(
          onTap: () {
            if(tags=="SocialSetting"){
              Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SocialSetting()));
            } else if(tags=="logout"){
              AuthServices _auth = new AuthServices();
              _auth.signOut(context);
            }
          },
          child: Container(
              margin: EdgeInsets.only(right: spacing_standard_new),
              width: width * 0.1,
              height: width * 0.1,
              padding: EdgeInsets.all(6),
              decoration: boxDecoration(showShadow: false, bgColor: social_view_color),
              child: SvgPicture.asset(icon, color: social_textColorPrimary)),
        ),
      ],
    ),
  );
}

Widget mTop(BuildContext context, var title, {var tags}) {
  var width = MediaQuery.of(context).size.width;
  return Container(
    width: MediaQuery.of(context).size.width,
    height: width * 0.15,
    color: social_white,
    child: Stack(
      children: <Widget>[
        GestureDetector(
            onTap: () {
              back(context);
            },
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(left: spacing_standard_new),
                width: width * 0.1,
                height: width * 0.1,
                decoration: boxDecoration(showShadow: false, bgColor: social_colorPrimary),
                child: Icon(Icons.keyboard_arrow_left, color: social_white),
              ),
            )),
        Center(
          child: text(title, fontFamily: fontBold, fontSize: textSizeLargeMedium, textAllCaps: true),
        ),
      ],
    ),
  );
}

class SocialBtn extends StatefulWidget {
  var textContent;
  VoidCallback onPressed;

  SocialBtn({@required this.textContent, @required this.onPressed});

  @override
  State<StatefulWidget> createState() {
    return SocialBtnState();
  }
}

class SocialBtnState extends State<SocialBtn> {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: widget.onPressed,
      textColor: social_white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      padding: const EdgeInsets.all(0.0),
      child: Container(
        decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8.0)), color: social_colorPrimary),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: text(widget.textContent, textColor: social_white),
          ),
        ),
      ),
    );
  }
}

TextStyle primaryTextStyle1(
    {int size = 16, Color textColor = const Color(0xFF000000)}) {
  return TextStyle(
    fontSize: size.toDouble(),
    color: textColor,
  );
}

TextStyle secondaryTextStyle(
    {int size = 14, Color textColor = const Color(0xFF757575)}) {
  return TextStyle(
    fontSize: size.toDouble(),
    color: textColor,
  );
}


BoxDecoration boxDecorations(
    {double radius = 8,
      Color color = Colors.transparent,
      Color bgColor = Colors.white,
      var showShadow = false}) {
  return BoxDecoration(
      color: bgColor,
      //gradient: LinearGradient(colors: [bgColor, whiteColor]),
      boxShadow: showShadow
          ? [BoxShadow(color:  Color(0x95E9EBF0), blurRadius: 10, spreadRadius: 2)]
          : [BoxShadow(color: Colors.transparent)],
      border: Border.all(color: color),
      borderRadius: BorderRadius.all(Radius.circular(radius)));
}

class CustomImage extends StatelessWidget {
  String img;
  CustomImage({this.img});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.topRight,
          children: <Widget>[
            ClipRRect(
                child: CachedNetworkImage(
                    imageUrl: img, fit: BoxFit.cover, height: 250),
                borderRadius: BorderRadius.circular(8)),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                  padding: EdgeInsets.all(16),
                  child: Icon(Icons.close, color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}