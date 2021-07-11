import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/screens/chatting.dart';
import 'package:chatapp/services/dbdata.dart';
import 'package:chatapp/utils/colors.dart';
import 'package:chatapp/utils/constants.dart';
import 'package:chatapp/utils/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialHomeChats extends StatefulWidget {
  @override
  SocialHomeChatsState createState() => SocialHomeChatsState();
}

class SocialHomeChatsState extends State<SocialHomeChats> {
  Stream usersStream, chatRoomsStream;

  getChatRoomIdByUid(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  getChatRooms() async {
    chatRoomsStream = await getTheChatRooms();
    setState(() {});
  }

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('We got an Error ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: Container(
                child: Theme(
                  data: ThemeData.light(),
                  child: CupertinoActivityIndicator(
                    animating: true,
                    radius: 20,
                  ),
                ),
              ),
            );

          case ConnectionState.none:
            return Text('oops no data');

          case ConnectionState.done:
            return Text('We are Done');
          default:
            return Container(
              decoration: boxDecoration(radius: spacing_middle),
              padding: EdgeInsets.all(spacing_middle),
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemBuilder: (context, index) {
                    DocumentSnapshot chatlist = snapshot.data.docs[index];
                    print(snapshot.data.docs[index].id);
                    return Chats(
                      lastMessage: chatlist.data()["lastMessage"],
                      chatRoomId: chatlist.id,
                      myUsername: FirebaseAuth.instance.currentUser.uid,
                      time: chatlist.data()["lastMessageSendTs"],
                    );
                  }),
            );
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getChatRooms();
  }

  var mFriendsLabel = text("Recents", fontFamily: fontMedium);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(spacing_standard_new),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              mFriendsLabel,
              SizedBox(
                height: spacing_standard_new,
              ),
              Column(
                children: [
                  chatRoomsList(),
                ],
              ),
              SizedBox(
                height: spacing_standard_new,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Chats extends StatefulWidget {
  final String lastMessage, chatRoomId, myUsername;
  Timestamp time;
  Chats({this.lastMessage, this.chatRoomId, this.myUsername, this.time});

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  String profilePicUrl = "", name = "", username = "", phone = "";
  String val="",msgtime="";

  getThisUserInfo() async {
    username =
        widget.chatRoomId.replaceAll(widget.myUsername, "").replaceAll("_", "");
    QuerySnapshot querySnapshot = await getUserInfo(username);
    print(
        "something bla bla ${querySnapshot.docs[0].id} ${querySnapshot.docs[0]["username"]}  ${querySnapshot.docs[0]["profileimg"]}");
    name = "${querySnapshot.docs[0]["username"]}";
    profilePicUrl = "${querySnapshot.docs[0]["profileimg"]}";
    phone = "${querySnapshot.docs[0]["phone"]}";
    setState(() {});
  }

  @override
  void initState() {
    var date = DateTime.fromMillisecondsSinceEpoch(widget.time.millisecondsSinceEpoch);    
    val=date.hour<12?"AM":"PM";
    msgtime=date.hour.toString()+" : "+date.minute.toString()+" "+val;
    print(widget.time.toString()+"  "+msgtime);
    getThisUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        //launchScreen(context, SocialChatting.tag);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SocialChatting(
                      name: name,
                      uid: username,
                      phone: phone,
                      image: profilePicUrl,
                    )));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: spacing_standard_new),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => Center(
                          child: CustomImage(
                            img: profilePicUrl,
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                        borderRadius:
                            BorderRadius.all(Radius.circular(spacing_middle)),
                        child: Container(
                          color: social_dark_gray,
                          child: CachedNetworkImage(
                            imageUrl: profilePicUrl, ////addimage
                            height: width * 0.13,
                            width: width * 0.13,
                            fit: BoxFit.fill,
                          ),
                        )),
                  ),
                  SizedBox(
                    width: spacing_middle,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        text(name, fontFamily: fontMedium),

                        ///add name
                        RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: SvgPicture.asset(
                                      "images/social_double_tick_indicator.svg",
                                      color:social_textColorSecondary,
                                      width: 16,
                                      height: 16),
                                ),
                              ),
                              TextSpan(
                                  text: widget.lastMessage.length>15?widget.lastMessage.substring(0,15)+"...":widget.lastMessage,
                                  style: TextStyle(
                                      fontSize: textSizeMedium,
                                      color: social_textColorSecondary)),
                            ],
                          ),
                        ),
                        // text(
                        //   widget.lastMessage,
                        //   textColor: social_textColorSecondary,
                        // )
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(width: spacing_standard),
            text(msgtime.toString(),
                fontFamily: fontMedium, fontSize: textSizeSMedium),

            /// last msg time
          ],
        ),
      ),
    );
  }
}
