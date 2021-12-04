import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orev/constants.dart';
import 'package:orev/services/user_services.dart';
import 'package:orev/services/user_simple_preferences.dart';
import 'package:orev/size_config.dart';

import 'package:firebase_storage/firebase_storage.dart';

class ProfilePic extends StatefulWidget {
  final bool camera;
  ProfilePic({
    Key key,
    this.camera = false,
  }) : super(key: key);
  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  File sampleImage;
  Image image;
  String authkey;
  String imageLink;

  @override
  void initState() {
    authkey = UserSimplePreferences.getAuthKey() ?? "";
    imageLink = UserSimplePreferences.getImageLink() ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void savetoDatabase(url) {
      UserSimplePreferences.setImageLink(url);
      UserServices _services = new UserServices();
      var values = {
        "id": authkey,
        "image": url,
      };
      _services.updateUserData(values);
      setState(() {});
    }

    Future<void> uploadStatusImage() async {
      FirebaseStorage storage = FirebaseStorage.instance;
      final Reference postImageRef = storage.ref().child("Post Images");
      var timeKey = new DateTime.now();
      String xyz = timeKey.toString() + ".jpg";
      final UploadTask uploadTask =
          postImageRef.child(xyz).putFile(sampleImage);
      var imageUrl = await (await uploadTask).ref.getDownloadURL();
      final String url_akshat = imageUrl.toString();
      savetoDatabase(url_akshat);
    }

    Future getImage() async {
      var tempImage = await ImagePicker().getImage(source: ImageSource.gallery);
      File imageFile = File(tempImage.path);
      sampleImage = imageFile;
      image = Image.file(sampleImage);
      uploadStatusImage();
    }

    return SizedBox(
      height: getProportionateScreenHeight(160),
      width: getProportionateScreenHeight(160),
      child: Stack(
        fit: StackFit.expand,
        overflow: Overflow.visible,
        children: [
          CircleAvatar(
            backgroundColor: kPrimaryColor,
            backgroundImage: AssetImage("assets/images/orevLogo.png"),
            foregroundImage: imageLink == ""
                ? AssetImage("assets/images/orevLogo.png")
                : NetworkImage(imageLink),
          ),
          widget.camera == true
              ? Positioned(
                  right: -16,
                  bottom: 0,
                  child: SizedBox(
                    height: getProportionateScreenHeight(38),
                    width: getProportionateScreenHeight(38),
                    child: FlatButton(
                      padding: EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(color: Colors.white),
                      ),
                      color: Color(0xFFF5F6F9),
                      onPressed: () {
                        getImage();
                      },
                      child: SvgPicture.asset("assets/icons/Camera Icon.svg",height: getProportionateScreenHeight(18),),
                    ),
                  ),
                )
              : Center(),
        ],
      ),
    );
  }
}
