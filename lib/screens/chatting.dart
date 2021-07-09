import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/services/dbdata.dart';
import 'package:chatapp/utils/extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chatapp/utils/colors.dart';
import 'package:chatapp/utils/constants.dart';
import 'package:chatapp/utils/widgets.dart';
import 'package:random_string/random_string.dart';

class SocialChatting extends StatefulWidget {
  static String tag = '/SocialChatting';

  @override
  SocialChattingState createState() => SocialChattingState();
}

class SocialChattingState extends State<SocialChatting> {

  String chatRoomId, messageId = "";
  Stream messageStream;

  TextEditingController chatmessage = TextEditingController();

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  addTheMessage(bool sendClicked) {
    if (chatmessage.text != "") {
      String message = chatmessage.text;

      var lastMessageTs = DateTime.now();

      Map<String, dynamic> messageInfoMap = {
        "message": message,
        "sendBy": FirebaseAuth.instance.currentUser.uid,
        "ts": lastMessageTs,
        "imgUrl": profileimg,
        "type": "message"
      };

      //messageId
      if (messageId == "") {
        messageId = randomAlphaNumeric(12);
      }

      addMessage(chatRoomId, messageId, messageInfoMap)
          .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": message,
          "lastMessageSendTs": lastMessageTs,
          "lastMessageSendBy": FirebaseAuth.instance.currentUser.uid,
        };

        updateLastMessageSend(chatRoomId, lastMessageInfoMap);

        if (sendClicked) {
          // remove the text in the message input field
          chatmessage.text = "";
          // make message id blank to get regenerated on next message send
          messageId = "";
        }
      });
    }
  }

  getAndSetMessages() async {
    messageStream = await getChatRoomMessages(chatRoomId);
    setState(() {});
  }

  @override
  void initState() {
    getAndSetMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    Widget buildChatMessages(
        String msg, String type, String time, String fromid) {
      if (fromid == FirebaseAuth.instance.currentUser.uid && type=="message") {
        return Container(
          margin: EdgeInsets.only(
              right: spacing_standard_new, bottom: spacing_standard),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(spacing_standard),
                width: MediaQuery.of(context).size.width * 0.45,
                decoration: BoxDecoration(
                    color: social_colorPrimary,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10))),
                child: text(msg,
                    textColor: social_white,
                    fontSize: textSizeMedium,
                    fontFamily: fontMedium,
                    isLongText: true),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SvgPicture.asset(
                            "images/social_double_tick_indicator.svg",
                            color: social_textColorSecondary,
                            width: 16,
                            height: 16),
                      ),
                    ),
                    TextSpan(
                        text: time,
                        style: TextStyle(
                            fontSize: textSizeMedium,
                            color: social_textColorSecondary)),
                  ],
                ),
              ),
            ],
          ),
        );
      } else if (fromid != FirebaseAuth.instance.currentUser.uid && type=="message") {
        return Row(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(left: spacing_standard_new),
                padding: EdgeInsets.all(spacing_standard),
                decoration: BoxDecoration(
                  color: social_app_background_color,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                      topLeft: Radius.circular(10)),
                ),
                width: MediaQuery.of(context).size.width * 0.5,
                child: text(msg,
                    textColor: social_textColorPrimary,
                    fontSize: textSizeMedium,
                    maxLine: 3,
                    fontFamily: fontMedium,
                    isLongText: true))
          ],
        );
      } else if (type == "Media") {
        return Row(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(left: spacing_standard_new),
                padding: EdgeInsets.all(spacing_standard),
                decoration: BoxDecoration(
                    color: social_app_background_color,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                        topLeft: Radius.circular(10))),
                width: MediaQuery.of(context).size.width * 0.5,
                child: text(msg,
                    textColor: social_textColorPrimary,
                    fontSize: textSizeMedium,
                    maxLine: 3,
                    fontFamily: fontMedium,
                    isLongText: true))
          ],
        );
      } else {
        return SizedBox();
      }
    }

    var mToolbar = Container(
      width: MediaQuery.of(context).size.width,
      height: width * 0.15,
      color: social_white,
      margin: EdgeInsets.only(right: spacing_standard_new),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  back(context);
                },
                child: Container(
                  margin: EdgeInsets.only(left: spacing_standard_new),
                  width: width * 0.1,
                  height: width * 0.1,
                  decoration: boxDecoration(
                      showShadow: false, bgColor: social_view_color),
                  child: Icon(Icons.keyboard_arrow_left, color: social_white),
                ),
              ),
              SizedBox(width: spacing_middle),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(spacing_middle)),
                child: CachedNetworkImage(
                    imageUrl: profileimg,
                    height: width * 0.1,
                    width: width * 0.1,
                    fit: BoxFit.fill),
              ),
              SizedBox(width: spacing_standard),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  text(name, fontFamily: fontMedium),
                ],
              )
            ],
          ),
          Row(
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.call, color: social_textColorPrimary),
                  onPressed: null),
            ],
          )
        ],
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 60),
              child: Column(
                children: <Widget>[
                  mToolbar,
                  SizedBox(height: spacing_standard_new),
                  // ListView.builder(
                  //   itemBuilder: (context, i) =>
                  //       buildChatMessages(getUserChats()[i]),
                  //   itemCount: getUserChats().length,
                  //   physics: NeverScrollableScrollPhysics(),
                  //   shrinkWrap: true,
                  // ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: width,
                //alignment: Alignment.bottomCenter,
                height: MediaQuery.of(context).size.width * 0.15,
                color: social_app_background_color,
                padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.image, color: social_icon_color),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        style: TextStyle(
                            fontSize: textSizeLargeMedium, fontFamily: fontRegular),
                        decoration: InputDecoration(
                            hintText: "Type a message",
                            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(width: 8),
                    SvgPicture.asset(
                      "images/social_send.svg",
                      color: social_icon_color,
                      height: 50,
                      width: 50,
                    ),
                    SizedBox(width: 0),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
