import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/screens/storypage.dart';
import 'package:chatapp/services/dbdata.dart';
import 'package:chatapp/utils/colors.dart';
import 'package:chatapp/utils/constants.dart';
import 'package:chatapp/utils/dashedcircle.dart';
import 'package:chatapp/utils/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

class SocialHomeStatus extends StatefulWidget {
  @override
  SocialHomeStatusState createState() => SocialHomeStatusState();
}

class SocialHomeStatusState extends State<SocialHomeStatus> {
  var mMyStatusLabel = text("MY Status", fontFamily: fontMedium);
  var mFriendsLabel = text("Friends", fontFamily: fontMedium);

  File img1;
  String path1 = "";

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
        'status/${FirebaseAuth.instance.currentUser.uid}/images/${Path.basename(img1.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(img1);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURLTwo) {
      setState(() {
        path1 = fileURLTwo;
        print(path1);
        addStatus();
      });
    });
  }

  Future<void> addStatus() async {
    await FirebaseFirestore.instance
        .collection('status')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .set({
          'name': name,
          'profileimg': profileimg,
          'passimage': path1,
          'time': DateTime.now()
        });
  }

  var val = DateTime.now().hour < 12 ? "AM" : "PM";

  Widget mStatus() {
    var width = MediaQuery.of(context).size.width;
    return Container(
      decoration: boxDecoration(radius: spacing_middle),
      padding: EdgeInsets.all(spacing_middle),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () async {
                  //launchScreen(context, SocialGallery.tag);
                  getProfileImage();
                },
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius:
                          BorderRadius.all(Radius.circular(spacing_middle)),
                      child: CachedNetworkImage(
                          imageUrl: profileimg,
                          height: width * 0.13,
                          width: width * 0.13,
                          fit: BoxFit.cover),
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(spacing_middle)),
                          color: social_colorPrimary),
                      child: Icon(Icons.add, color: social_white, size: 20),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: spacing_middle,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  text("My Status", fontFamily: fontMedium),
                  text(
                    "Tap to add status",
                    textColor: social_textColorSecondary,
                  )
                ],
              ),
            ],
          ),
          text(
              DateTime.now().hour.toString() +
                  ":" +
                  DateTime.now().minute.toString() +
                  " " +
                  val,
              fontFamily: fontMedium,
              fontSize: textSizeSMedium),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(spacing_standard_new),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              mMyStatusLabel,
              SizedBox(
                height: spacing_standard_new,
              ),
              mStatus(),
              SizedBox(
                height: spacing_standard_new,
              ),
              mFriendsLabel,
              SizedBox(
                height: spacing_standard_new,
              ),
              Column(
                children: [
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('status')
                          .where("name",
                              isNotEqualTo:
                                  name)
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
                              decoration: boxDecoration(showShadow: true),
                              padding: EdgeInsets.all(spacing_standard_new),
                              child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data.docs.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot statuslist =
                                        snapshot.data.docs[index];
                                    print(snapshot.data.docs[index].id);
                                    return Friends(
                                      name: statuslist.data()['name'],
                                      image: statuslist.data()['profileimg'],
                                      passimage: statuslist.data()['passimage'],
                                      time: statuslist.data()['time'],
                                    );
                                  }),
                            );
                        }
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Friends extends StatefulWidget {
  String name, image, passimage;
  Timestamp time;

  Friends({this.name, this.image, this.passimage, this.time});

  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  var val = "", msgtime = "";
  @override
  void initState() {
    var date =
        DateTime.fromMillisecondsSinceEpoch(widget.time.millisecondsSinceEpoch);
    val = date.hour < 12 ? "AM" : "PM";
    msgtime = date.hour.toString() + " : " + date.minute.toString() + " " + val;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => StoryPageView(
                      image: widget.passimage,
                    )));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: spacing_standard_new),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                DashedCircle(
                  dashes: 7,
                  child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: CircleAvatar(
                        radius: 15.0,
                        child: Container(
                          color: social_white,
                          child: CachedNetworkImage(
                            imageUrl: widget.image,

                            ///add image
                            height: width * 0.2,
                            width: width * 0.2,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )),
                  color: social_colorPrimary,
                ),
                SizedBox(
                  width: spacing_middle,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    text(widget.name, fontFamily: fontMedium),

                    ///addd mame
                  ],
                ),
              ],
            ),
            text(msgtime, //add time
                fontFamily: fontMedium,
                fontSize: textSizeSMedium),
          ],
        ),
      ),
    );
  }
}
