import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/screens/dashboard.dart';
import 'package:chatapp/services/dbdata.dart';
import 'package:chatapp/utils/colors.dart';
import 'package:chatapp/utils/constants.dart';
import 'package:chatapp/utils/extensions.dart';
import 'package:chatapp/utils/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

class UserDetails extends StatefulWidget {
  final String phone;
  UserDetails({this.phone});
  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  File img1;
  String path1 = "";
  TextEditingController username = new TextEditingController();
  TextEditingController email = new TextEditingController();

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
  }

  Future uploadProfileImg() async {
    StorageReference storageReference = FirebaseStorage.instance.ref().child(
        'admins/${FirebaseAuth.instance.currentUser.uid}/images/${Path.basename(img1.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(img1);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURLTwo) {
      setState(() {
        path1 = fileURLTwo;
        print(path1);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(social_white);
    return Scaffold(
      backgroundColor: social_app_background_color,
      body: SafeArea(
          child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              mTop(context, ""),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(
                        left: spacing_standard_new,
                        right: spacing_standard_new),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: spacing_large),
                        Center(
                            child: text("Welcome",
                                fontFamily: fontBold, fontSize: textSizeLarge)),
                        SizedBox(height: spacing_middle),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Profile picture',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Ink(
                              height: 130,
                              width: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(65.0),
                                ),
                              ),
                              child: img1 == null && profileimg == ""
                                  ? RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(65.0),
                                        ),
                                      ),
                                      onPressed: getProfileImage,
                                      color: Colors.grey[200],
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            'https://cdn.onlinewebfonts.com/svg/img_133373.png',
                                        fit: BoxFit.fill,
                                      ),
                                    )
                                  : profileimg != ""
                                      ? GestureDetector(
                                          // onTap: getProfileImage,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(65.0),
                                            ),
                                            child: Image.network(
                                              profileimg,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: getProfileImage,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(65.0),
                                            ),
                                            child: Image.file(
                                              img1,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        profileimg == ""
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [Text("Tap to choose profile image")],
                              )
                            : Text(""),
                        SizedBox(height: spacing_middle),
                        text(
                            "Enter your Details",
                            isLongText: true,
                            isCentered: true),
                        SizedBox(height: spacing_large),
                        Column(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                decoration: boxDecoration(
                                    showShadow: false,
                                    bgColor: social_app_background_color,
                                    radius: 8,
                                    color: social_view_color),
                                padding: EdgeInsets.all(0),
                                child: TextFormField(
                                  keyboardType: TextInputType.name,
                                  maxLength: 12,
                                  style: TextStyle(
                                      fontSize: textSizeLargeMedium,
                                      fontFamily: fontRegular),
                                  decoration: InputDecoration(
                                    counterText: "",
                                    contentPadding:
                                        EdgeInsets.fromLTRB(16, 12, 16, 0),
                                    hintText: "Username",
                                    prefixIcon: Icon(Icons.person),
                                    hintStyle: TextStyle(
                                        color: social_textColorSecondary,
                                        fontSize: textSizeMedium),
                                    border: InputBorder.none,
                                  ),
                                  controller: username,
                                ),
                              ),
                            ),
                            SizedBox(height: spacing_large),
                            Expanded(
                              child: Container(
                                decoration: boxDecoration(
                                    showShadow: false,
                                    bgColor: social_app_background_color,
                                    radius: 8,
                                    color: social_view_color),
                                padding: EdgeInsets.all(0),
                                child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(
                                      fontSize: textSizeLargeMedium,
                                      fontFamily: fontRegular),
                                  decoration: InputDecoration(
                                    counterText: "",
                                    contentPadding:
                                        EdgeInsets.fromLTRB(16, 12, 16, 0),
                                    hintText: "Email address",
                                    prefixIcon: Icon(Icons.email),
                                    hintStyle: TextStyle(
                                        color: social_textColorSecondary,
                                        fontSize: textSizeMedium),
                                    border: InputBorder.none,
                                  ),
                                  controller: email,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: spacing_large),
                        SocialAppButton(
                          onPressed: () async {
                            if (username.text != "" &&
                                email.text != "" &&
                                path1 != "") {
                              await addUsers(username.text, email.text,
                                  widget.phone, path1);
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SocialDashboard()),
                                  (route) => false);
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text('Incomplete Information'),
                                        content: Text(
                                            'Please Fill all the information'),
                                        actions: [
                                          FlatButton(
                                            child: Text('Ok'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      ));
                            }
                          },
                          textContent: "Continue",
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(bottom: spacing_standard_new),
            alignment: Alignment.bottomCenter,
            child: text(
                "Your form submission is subjected \n to our Privacy and Policy",
                textColor: social_textColorSecondary,
                isCentered: true,
                isLongText: true),
          )
        ],
      )),
    );
  }
}
