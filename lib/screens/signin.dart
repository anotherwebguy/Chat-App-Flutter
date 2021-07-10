import 'package:chatapp/auth/authentication.dart';
import 'package:chatapp/screens/dashboard.dart';
import 'package:chatapp/screens/loading.dart';
import 'package:chatapp/screens/userdetails.dart';
import 'package:chatapp/services/dbdata.dart';
import 'package:chatapp/utils/codePicker/country_code_picker.dart';
import 'package:chatapp/utils/colors.dart';
import 'package:chatapp/utils/constants.dart';
import 'package:chatapp/utils/extensions.dart';
import 'package:chatapp/utils/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SocialSignIn extends StatefulWidget {
  static String tag = '/SocialSignIn';

  @override
  SocialSignInState createState() => SocialSignInState();
}

class SocialSignInState extends State<SocialSignIn> {
  final _formKey = GlobalKey<FormState>();
  String error = "", userOtp = "", otpError = "", phoneNo = "";
  bool _loading = false;
  TextEditingController phone = new TextEditingController();
  AuthServices _auth = new AuthServices();

  Future<void> loadDialog(TextEditingController phone) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 10,
          title: Text('Sending OTP to\n+91 ${phone.text}'),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(3.0, 8.0, 10.0, 10.0),
                  child: SpinKitThreeBounce(
                    color: Colors.blue[500],
                    size: 30.0,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<bool> _verifyPhone(
      TextEditingController phone, BuildContext context) async {
    phoneNo = "+91${phone.text}";
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          setState(() => _loading = true);

          UserCredential result = await _auth.signInWithCredential(credential);
          User user = result.user;

          if (user != null) {
            print("1");
            await getUser().then((value) => existence == true
                ? Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => SocialDashboard()),
                    (route) => false)
                : Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserDetails(
                              phone: phone.text,
                            )),
                    (route) => false));
          } else {
            setState(() => {
                  _loading = false,
                  error = "Validation Error, Please try again in sometime"
                });
          }
        },
        verificationFailed: (FirebaseAuthException exception) {
          print(exception);
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          Navigator.of(context).pop();
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              child: Container(
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: const Offset(0.0, 10.0),
                    ),
                  ],
                ),
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // To make the card compact
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                            padding: EdgeInsets.all(16),
                            alignment: Alignment.centerRight,
                            child: Icon(Icons.close, color: Colors.black)),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: Text('An OTP has been sent to',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Bold",
                              fontSize: 18.0,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                        child: Text('+91 ' + phone.text,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Bold",
                              fontSize: 18.0,
                            )),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(16, 10, 4, 8),
                            hintText: "OTP",
                            labelText: "Enter OTP",
                            enabledBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xFFB4BBC2), width: 0.0),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xFFB4BBC2), width: 0.0),
                            ),
                          ),
                          onChanged: (value) {
                            userOtp = value;
                          },
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(otpError,
                          style: TextStyle(
                            color: Colors.red,
                            fontFamily: "Regular",
                            fontSize: 14.0,
                          )),
                      SizedBox(height: 26),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(colors: <Color>[
                              Color(0xFF3a5af9),
                              Color(0xFF7449fa)
                            ]),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16)),
                            shape: BoxShape.rectangle,
                          ),
                          alignment: Alignment.center,
                          child: FlatButton(
                            onPressed: () async {
                              // Navigator.pop(context);
                              setState(() => {
                                    otpError = "",
                                  });
                              print(userOtp);
                              AuthCredential credential =
                                  PhoneAuthProvider.credential(
                                      verificationId: verificationId,
                                      smsCode: userOtp);

                              UserCredential result = await _auth
                                  .signInWithCredential(credential)
                                  .then((result) async {
                                if (result != null) {
                                  setState(() => {
                                        _loading = true,
                                      });
                                  await getUser();
                                  if (name == null && email == null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UserDetails(
                                                phone: phone.text,
                                              )),
                                    );
                                  } else {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SocialDashboard()),
                                        (route) => false);
                                  }
                                } else {
                                  setState(() =>
                                    otpError = "Please enter a valid OTP");
                                }
                              });
                              //await fetchData();

                              // User user = result.user;

                              // if (user != null) {
                              //   setState(() => {
                              //         _loading = true,
                              //       });

                              //   Future.delayed(const Duration(seconds: 5),
                              //       () async {
                              //     Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) => UserDetails(
                              //                 phone: phone.text,
                              //               )),
                              //     );
                              //   });
                              // } else {
                              //   setState(() =>
                              //       otpError = "Please enter a valid OTP");
                              // }
                            },
                            textColor: Color(0xFFFFFFFF),
                            child: Text(
                              "Sign In",
                              style:
                                  TextStyle(fontSize: 16, fontFamily: "Bold"),
                              textAlign: TextAlign.center,
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(social_white);
    return Scaffold(
      backgroundColor: social_app_background_color,
      body: _loading
          ? Loading("Signing in")
          : SafeArea(
              child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    mTop(context, "Phone Verification"),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          margin: EdgeInsets.only(
                              left: spacing_standard_new,
                              right: spacing_standard_new),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: spacing_large),
                                Center(
                                    child: text("Welcome",
                                        fontFamily: fontBold,
                                        fontSize: textSizeLarge)),
                                SizedBox(height: spacing_middle),
                                text(
                                    "Enter your phone number to continue to inMood Messenger and enjoy messaging and calling to all your friend",
                                    isLongText: true,
                                    isCentered: true),
                                SizedBox(height: spacing_large),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      decoration: boxDecoration(
                                          showShadow: false,
                                          bgColor: social_app_background_color,
                                          radius: 8,
                                          color: social_view_color),
                                      padding: EdgeInsets.all(0),
                                      child: CountryCodePicker(
                                          onChanged: print,
                                          showFlag: true,
                                          padding: EdgeInsets.all(0)),
                                    ),
                                    SizedBox(width: spacing_standard_new),
                                    Expanded(
                                      child: Container(
                                        decoration: boxDecoration(
                                            showShadow: false,
                                            bgColor:
                                                social_app_background_color,
                                            radius: 8,
                                            color: social_view_color),
                                        padding: EdgeInsets.all(0),
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          maxLength: 10,
                                          style: TextStyle(
                                              fontSize: textSizeLargeMedium,
                                              fontFamily: fontRegular),
                                          decoration: InputDecoration(
                                            counterText: "",
                                            contentPadding: EdgeInsets.fromLTRB(
                                                16, 12, 16, 0),
                                            hintText: "Mobile Number",
                                            prefixIcon: Icon(Icons.call),
                                            hintStyle: TextStyle(
                                                color:
                                                    social_textColorSecondary,
                                                fontSize: textSizeMedium),
                                            border: InputBorder.none,
                                          ),
                                          controller: phone,
                                          validator: (val) =>
                                              val.length != 10 ? "" : null,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: spacing_large),
                                SocialAppButton(
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      setState(() => error = "");
                                      loadDialog(phone);
                                      _verifyPhone(phone, context);
                                    } else {
                                      setState(() => error =
                                          "Please enter a valid Phone Number");
                                    }
                                  },
                                  textContent: "Continue",
                                ),
                              ],
                            ),
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
