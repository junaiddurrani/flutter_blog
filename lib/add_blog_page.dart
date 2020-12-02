import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'home_page.dart';

class AddBlogPage extends StatefulWidget {
  @override
  _AddBlogPageState createState() => _AddBlogPageState();
}

class _AddBlogPageState extends State<AddBlogPage> {
  File _image;
  final picker = ImagePicker();

  bool _isLoading = false;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _uploadBlog() async {
    if (_image == null) {
      Fluttertoast.showToast(msg: 'Select Image');
    } else if (_titleController.text == null || _titleController.text == '') {
      Fluttertoast.showToast(msg: 'Enter Title');
    } else if (_descController.text == null || _descController.text == '') {
      Fluttertoast.showToast(msg: 'Enter Description');
    } else {
      setState(() {
        _isLoading = true;
      });
      DatabaseReference reference = FirebaseDatabase.instance.reference();
      StorageReference ref = FirebaseStorage.instance
          .ref()
          .child('BlogImages')
          .child(_image.path.toString() + '.jpg');
      StorageUploadTask uploadTask = ref.putFile(_image);
      String imageUrl =
          await (await uploadTask.onComplete).ref.getDownloadURL();
      String blogId = reference.child('Blogs').push().key;
      Map data = {
        'image': imageUrl,
        'desc': _descController.text.toString(),
        'title': _titleController.text.toString(),
      };
      reference.child('Blogs').child(blogId).set(data).whenComplete(() {
        setState(() {
          _isLoading = false;
        });
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tech Spartans',
                    style: GoogleFonts.bubblegumSans(
                        color: Colors.yellow,
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold)),
                FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  color: Colors.yellow,
                  child: Text('Select Image',
                      style: GoogleFonts.roboto(color: Colors.black87)),
                  onPressed: getImage,
                )
              ],
            ),
            _image == null
                ? Container(width: 0.0, height: 0.0)
                : Container(
              margin: EdgeInsets.only(top: 20.0),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Image(
                            image: FileImage(_image),
                            width: MediaQuery.of(context).size.width,
                            height: 250.0,
                            filterQuality: FilterQuality.high,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 40.0,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                  Colors.transparent,
                                  Color(0xff101010)
                                ])),
                          ),
                        )
                      ],
                    ),
                ),
            SizedBox(height: 30.0),
            Container(
              height: 45.0,
              child: TextFormField(
                controller: _titleController,
                style: GoogleFonts.nunito(color: Colors.yellow),
                cursorColor: Colors.yellow,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(color: Colors.yellow)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(color: Colors.yellow)),
                  labelText: 'Type Title',
                  labelStyle: GoogleFonts.nunito(color: Colors.yellow[200]),
                ),
              ),
            ),
            SizedBox(height: 15.0),
            Container(
              height: 45.0,
              child: TextFormField(
                controller: _descController,
                style: GoogleFonts.nunito(color: Colors.yellow),
                cursorColor: Colors.yellow,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(color: Colors.yellow)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(color: Colors.yellow)),
                  labelText: 'Type Description',
                  labelStyle: GoogleFonts.nunito(color: Colors.yellow[200]),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              height: 50.0,
              child: FlatButton(
                onPressed: _uploadBlog,
                child: Text('Upload Blog',
                    style: GoogleFonts.nunito(color: Colors.black87)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                color: Colors.yellow,
              ),
            ),
            SizedBox(height: 20.0),
            _isLoading
                ? Container(
                    margin: EdgeInsets.symmetric(horizontal: 55.0),
                    child: LinearProgressIndicator(
                      minHeight: 5.0,
                    ),
                  )
                : Container(width: 0.0, height: 0.0)
          ],
        ),
      ),
    );
  }
}
