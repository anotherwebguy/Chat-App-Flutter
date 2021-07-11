import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/services/dbdata.dart';
import 'package:chatapp/utils/extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chatapp/utils/colors.dart';
import 'package:chatapp/utils/constants.dart';
import 'package:chatapp/utils/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as Path;

class SocialChatting extends StatefulWidget {
  String name, uid, phone, image;
  SocialChatting({this.name, this.uid, this.phone, this.image});

  @override
  SocialChattingState createState() => SocialChattingState();
}

class SocialChattingState extends State<SocialChatting> {
  String chatRoomId, messageId = "";
  Stream messageStream;
  File img1;
  String path1 = "";

  TextEditingController chatmessage = TextEditingController();
  ScrollController controller = new ScrollController();

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  addImageMessage() {
    if (path1 != "") {
      var lastMessageTs = DateTime.now();
      String message = "Image";

      Map<String, dynamic> messageInfoMap = {
        "message": path1,
        "sendBy": FirebaseAuth.instance.currentUser.uid,
        "ts": lastMessageTs,
        "imgUrl": profileimg,
        "type": "media",
        "isRead": false,
      };

      //messageId
      if (messageId == "") {
        messageId = randomAlphaNumeric(12);
      }

      addMessage(chatRoomId, messageId, messageInfoMap).then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": message,
          "lastMessageSendTs": lastMessageTs,
          "lastMessageSendBy": FirebaseAuth.instance.currentUser.uid,
        };
        messageId = "";
        updateLastMessageSend(chatRoomId, lastMessageInfoMap);
      });
    }
  }

  addTheMessage() {
    if (chatmessage.text != "") {
      var lastMessageTs = DateTime.now();
      String message = chatmessage.text;

      Map<String, dynamic> messageInfoMap = {
        "message": chatmessage.text,
        "sendBy": FirebaseAuth.instance.currentUser.uid,
        "ts": lastMessageTs,
        "imgUrl": profileimg,
        "type": "message",
        "isRead": false,
      };

      //messageId
      if (messageId == "") {
        messageId = randomAlphaNumeric(12);
      }

      addMessage(chatRoomId, messageId, messageInfoMap).then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": message,
          "lastMessageSendTs": lastMessageTs,
          "lastMessageSendBy": FirebaseAuth.instance.currentUser.uid,
        };
        messageId = "";
        updateLastMessageSend(chatRoomId, lastMessageInfoMap);
      });
    }
  }

  getAndSetMessages() async {
    messageStream = await getChatRoomMessages(chatRoomId);
    setState(() {});
  }

  Future getProfileImage() async {
    final pickedFile = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      if (pickedFile != null) {
        path1 = pickedFile.path;
        img1 = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
    if (img1 != null) {
      await uploadProfileImg();
    }
  }

  Future uploadProfileImg() async {
    StorageReference storageReference = FirebaseStorage.instance.ref().child(
        'chats/${FirebaseAuth.instance.currentUser.uid}/images/${Path.basename(img1.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(img1);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURLTwo) {
      setState(() {
        path1 = fileURLTwo;
        print(path1);
        addImageMessage();
        controller.jumpTo(controller.position.maxScrollExtent);
      });
    });
  }

  @override
  void initState() {
    chatRoomId = getChatRoomIdByUsernames(
        widget.uid, FirebaseAuth.instance.currentUser.uid);
    getAndSetMessages();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    Widget buildChatMessages(String msg, String type, Timestamp time,
        String fromid, String image, bool isRead) {
      var date =
          DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch);
      String val = date.hour < 12 ? "AM" : "PM";
      String msgtime =
          date.hour.toString() + " : " + date.minute.toString() + " " + val;
      if (fromid == FirebaseAuth.instance.currentUser.uid) {
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
                child: type == 'message'
                    ? text(msg,
                        textColor: social_white,
                        fontSize: textSizeMedium,
                        fontFamily: fontMedium,
                        isLongText: true)
                    : imageMessage(context, msg),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SvgPicture.asset(
                            "images/social_double_tick_indicator.svg",
                            color: isRead
                                ? Colors.blue
                                : social_textColorSecondary,
                            width: 16,
                            height: 16),
                      ),
                    ),
                    TextSpan(
                        text: msgtime,
                        style: TextStyle(
                            fontSize: textSizeMedium,
                            color: social_textColorSecondary)),
                  ],
                ),
              ),
            ],
          ),
        );
      } else if (fromid != FirebaseAuth.instance.currentUser.uid ) {
        final size = MediaQuery.of(context).size;
        return Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24.0),
                          child: CachedNetworkImage(
                            imageUrl: widget.image,
                            placeholder: (context, url) => Container(
                              transform:
                                  Matrix4.translationValues(0.0, 0.0, 0.0),
                              child: Container(
                                  width: 60,
                                  height: 60,
                                  child: Center(
                                      child: new CircularProgressIndicator())),
                            ),
                            errorWidget: (context, url, error) =>
                                new Icon(Icons.error),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(name),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
                              child: Container(
                                constraints:
                                    BoxConstraints(maxWidth: size.width - 150),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(
                                      type == 'message' ? 10.0 : 0),
                                  child: Container(
                                      child: type == 'message'
                                          ? Text(
                                              msg,
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )
                                          : imageMessage(context, msg)),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 14.0, left: 4),
                              child: Text(
                                msgtime,
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
        // return Row(
        //   children: <Widget>[
        //     Container(
        //         margin: EdgeInsets.only(left: spacing_standard_new),
        //         padding: EdgeInsets.all(spacing_standard),
        //         decoration: BoxDecoration(
        //           color: social_app_background_color,
        //           borderRadius: BorderRadius.only(
        //               topRight: Radius.circular(10),
        //               bottomRight: Radius.circular(10),
        //               topLeft: Radius.circular(10)),
        //         ),
        //         width: MediaQuery.of(context).size.width * 0.5,
        //         child: text(msg,
        //             textColor: social_textColorPrimary,
        //             fontSize: textSizeMedium,
        //             maxLine: 3,
        //             fontFamily: fontMedium,
        //             isLongText: true))
        //   ],
        // );
      } else {
        return SizedBox();
      }
    }

    Widget chatMessages() {
      return StreamBuilder(
        stream: messageStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  padding: EdgeInsets.only(bottom: 70, top: 16),
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  controller: controller,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return buildChatMessages(
                        ds.data()["message"],
                        ds.data()["type"],
                        ds.data()["ts"],
                        ds.data()["sendBy"],
                        ds.data()["imageUrl"],
                        ds.data()["isRead"]);
                  })
              : Center(child: CircularProgressIndicator());
        },
      );
    }

    var mToolbar = Container(
      width: MediaQuery.of(context).size.width,
      height: width * 0.24,
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
                    imageUrl: widget.image,
                    height: width * 0.1,
                    width: width * 0.1,
                    fit: BoxFit.fill),
              ),
              SizedBox(width: spacing_standard),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  text(widget.name, fontFamily: fontMedium),
                ],
              )
            ],
          ),
          Row(
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.call, color: social_textColorPrimary),
                  onPressed: () async {
                    await launch("tel:${widget.phone}");
                  }),
            ],
          )
        ],
      ),
    );

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200),
        child: mToolbar,
      ),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 60),
              child: Column(
                children: <Widget>[
                  //mToolbar,
                  //SizedBox(height: spacing_standard_new),
                  chatMessages(),
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
                    GestureDetector(
                        onTap: () {
                          getProfileImage();
                          controller.animateTo(
                              controller.position.maxScrollExtent,
                              duration: Duration(milliseconds: 200),
                              curve: Curves.easeInOut);
                        },
                        child: Icon(Icons.image, color: social_icon_color)),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        style: TextStyle(
                            fontSize: textSizeLargeMedium,
                            fontFamily: fontRegular),
                        controller: chatmessage,
                        decoration: InputDecoration(
                            hintText: "Type a message",
                            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        addTheMessage();
                        chatmessage.text = "";
                        controller.animateTo(
                            controller.position.maxScrollExtent,
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeInOut);
                      },
                      child: SvgPicture.asset(
                        "images/social_send.svg",
                        color: social_icon_color,
                        height: 50,
                        width: 50,
                      ),
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
