import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'home_page.dart';

class AddBlogPage extends StatefulWidget {
  @override
  _AddBlogPageState createState() => _AddBlogPageState();
}

class _AddBlogPageState extends State<AddBlogPage> {

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();

  bool _isLoading = false;
  String _blogId = '';

  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile.path);
    });
  }

  Future _uploadPost(File image, String title, String description) async {
    setState(() {
      _isLoading = true;
    });
    DatabaseReference reference = await FirebaseDatabase.instance.reference();
    StorageReference ref = await FirebaseStorage.instance.ref().child("Blog_images").child(image.uri.toString() + ".jpg");
    StorageUploadTask uploadTask = ref.putFile(image);
    String downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    _blogId = reference.child("Blogs").push().key;
    Map data = {
      'image': downloadUrl,
      'title': title,
      'desc': description
    };
    reference.child("Blogs").child(_blogId).set(data).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 40.0, left: 25.0, right: 25.0),
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tech Spartans', style: GoogleFonts.bubblegumSans(color: Colors.yellow, fontSize: 32.0, fontWeight: FontWeight.bold)),
                  FlatButton(
                    onPressed: getImage,
                    color: Colors.yellow,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    child: Text('Add Image', style: GoogleFonts.roboto(color: Colors.black87)),
                  )
                ],
              ),
            ),
            SizedBox(height: 30.0),
            _image == null ? Container(width: 0.0, height: 0.0) : ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Image(
                width: MediaQuery.of(context).size.width,
                height: 300.0,
                image: FileImage(_image),
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              child: TextFormField(
                style: TextStyle(color: Colors.yellow),
                controller: _titleController,
                cursorColor: Colors.yellow,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.yellow[100],
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.yellow[100],
                    ),
                  ),
                  labelText: 'Type Title',
                  labelStyle: TextStyle(color: Colors.yellow[100], fontSize: 16.0),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              child: TextFormField(
                style: TextStyle(color: Colors.yellow),
                controller: _descController,
                cursorColor: Colors.yellow,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.yellow[100],
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.yellow[100],
                    ),
                  ),
                  labelText: 'Type Description',
                  labelStyle: TextStyle(color: Colors.yellow[100], fontSize: 16.0),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              height: 50.0,
              width: double.infinity,
              child: FlatButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  if(_titleController.text.isEmpty && _descController.text.isEmpty && _image == null) {
                    debugPrint('Provide Title and Description');
                  } else {
                    _uploadPost(_image, _titleController.text, _descController.text);
                  }
                },
                color: Colors.yellow,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                child: Text('Upload', style: GoogleFonts.roboto(color: Colors.black87, fontSize: 20.0)),
              ),
            ),
            SizedBox(height: 20.0),
            _isLoading ? Container(
              margin: EdgeInsets.symmetric(horizontal: 50.0),
              child: Center(
                child: LinearProgressIndicator(minHeight: 5.0),
              ),
            ) : Container(width: 0.0, height: 0.0)
          ],
        ),
      ),
    );
  }
}
