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

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String Searchstring;
  TextEditingController textEditingController = TextEditingController();

  getChatRoomIdByUid(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFFf8f8f8),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          new TextEditingController().clear();
        },
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.all(16.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: boxDecorations(
                          radius: 6,
                          bgColor: Color(0xFFDADADA).withOpacity(0.8),
                        ),
                        child: TextField(
                          onChanged: (val) {
                            setState(() {
                              Searchstring = val;
                            });
                          },
                          controller: textEditingController,
                          style: TextStyle(fontSize: 20),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search',
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          "Cancel",
                          style:
                              primaryTextStyle1(textColor: Color(0xFF3281FF)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 16),
                  child: Text(
                    "Search for your Favourites",
                    style: secondaryTextStyle(),
                  )),
              SizedBox(
                height: 10,
              ),
              Column(children: [
                StreamBuilder<QuerySnapshot>(
                  stream: (Searchstring == null || Searchstring.trim() == '')
                      ? FirebaseFirestore.instance
                          .collection("users")
                          .where("uid",
                              isNotEqualTo:
                                  FirebaseAuth.instance.currentUser.uid)
                          .snapshots()
                      : FirebaseFirestore.instance
                          .collection("users")
                          .where('searchString',
                              arrayContains: Searchstring.toLowerCase())
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
                                return Padding(
                                  padding: const EdgeInsets.only(left:10),
                                  child: Chats(
                                    name: chatlist.data()['username'],
                                    status: chatlist.data()['status'],
                                    img: chatlist.data()['profileimg'],
                                    uid: chatlist.data()['uid'],
                                    phn: chatlist.data()['phone'],
                                  ),
                                );
                              }),
                        );
                    }
                  },
                ),
              ])
            ],
          ),
        ),
      ),
    );
  }
}

class Chats extends StatefulWidget {
  String name, status, img, uid, phn;

  Chats({this.name, this.status, this.img, this.uid, this.phn});

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () async {
        //launchScreen(context, SocialChatting.tag);
        var chatRoomId = getChatRoomIdByUsernames(
            FirebaseAuth.instance.currentUser.uid, widget.uid);
        Map<String, dynamic> chatRoomInfoMap = {
          "users": [FirebaseAuth.instance.currentUser.uid, widget.uid]
        };
        await createChatRoom(chatRoomId, chatRoomInfoMap);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SocialChatting(
                    name: name, uid: widget.uid, phone: widget.phn,image: widget.img,)));
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
                        builder: (BuildContext context) => CustomImage(
                          img: widget.img,
                        ),
                      );
                    },
                    child: ClipRRect(
                        borderRadius:
                            BorderRadius.all(Radius.circular(spacing_middle)),
                        child: Container(
                          color: social_dark_gray,
                          child: CachedNetworkImage(
                            imageUrl: widget.img, ////addimage
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
                        text(widget.name, fontFamily: fontMedium),

                        ///add name
                        text(
                          widget.status,

                          ///addd last msg
                          textColor: social_textColorSecondary,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(width: spacing_standard), // last msg time
          ],
        ),
      ),
    );
  }
}
