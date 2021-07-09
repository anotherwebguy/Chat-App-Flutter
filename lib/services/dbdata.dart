import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

String name, email, phone,profileimg,status;
bool existence;

Future<void> addUsers(String username, String useremail, String userphone, String profileimg, String status, List searchString) async {
  return await FirebaseFirestore.instance.collection("users")
      .doc(FirebaseAuth.instance.currentUser.uid)
      .set({
    'username': username,
    'email': useremail,
    'phone': userphone,
    'profileimg': profileimg,
    'uid': FirebaseAuth.instance.currentUser.uid,
    'status': status,
    'searchString': searchString
  });
}

Future<void> getUser() async {
  try {
    
    await FirebaseFirestore.instance.collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) {
      name = value.get('username');
      email = value.get('email');
      phone = value.get('phone');
      profileimg = value.get('profileimg');
      status = value.get('status');
      existence=value.exists;
      print("yes");
    });
  } catch (e) {
    print(e.toString());
    print("bhak");
  }
}
