import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/utils/colors.dart';
import 'package:chatapp/utils/constants.dart';
import 'package:chatapp/utils/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SocialHomeChats extends StatefulWidget {
  @override
  SocialHomeChatsState createState() => SocialHomeChatsState();
}

class SocialHomeChatsState extends State<SocialHomeChats> {
  @override
  void initState() {
    super.initState();
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
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .where("uid", isNotEqualTo: FirebaseAuth.instance.currentUser.uid)
                          .snapshots(),
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
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot chatlist =
                                        snapshot.data.docs[index];
                                    print(snapshot.data.docs[index].id);
                                    return Chats(name: chatlist.data()['username'],status: chatlist.data()['status'],time: chatlist.data()['time'],img: chatlist.data()['profileimg'] ,);
                                  }),
                            );
                        }
                      }),
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

class Chats extends StatelessWidget {
  String name,status,time,img;

  Chats({this.name,this.status,this.time,this.img});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        //launchScreen(context, SocialChatting.tag);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: spacing_standard_new),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  ClipRRect(
                      borderRadius:
                          BorderRadius.all(Radius.circular(spacing_middle)),
                      child: Container(
                        color: social_dark_gray,
                        child: CachedNetworkImage(
                          imageUrl: img, ////addimage
                          height: width * 0.13,
                          width: width * 0.13,
                          fit: BoxFit.fill,
                        ),
                      )),
                  SizedBox(
                    width: spacing_middle,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        text(name, fontFamily: fontMedium),///add name
                        text(
                          status,              ///addd last msg
                          textColor: social_textColorSecondary,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(width: spacing_standard),
            text(time,
                fontFamily: fontMedium, fontSize: textSizeSMedium),/// last msg time
          ],
        ),
      ),
    );
  }
}
