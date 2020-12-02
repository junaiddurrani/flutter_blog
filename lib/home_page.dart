import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'add_blog_page.dart';
import 'blogs.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<List<Blogs>> getData() async {
    List<Blogs> blogsData = [];
    DatabaseReference reference = FirebaseDatabase.instance.reference();
    await reference.child('Blogs').once().then((value) {
      if(value.value != null) {
        var keys = value.value.keys;
        var data = value.value;
        for(var singleValue in keys) {
          blogsData.add(Blogs(
            desc: data[singleValue]['desc'],
            image: data[singleValue]['image'],
            title: data[singleValue]['title']
          ));
          blogsData.reversed.toList();
        }
      } else {
        Fluttertoast.showToast(msg: 'No Posts Available');
      }
    });
    return blogsData;
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.black87,
        elevation: 0.3,
        centerTitle: true,
        title: Text('Tech Spartans', style: GoogleFonts.bubblegumSans(color: Colors.yellow, fontSize: 30.0, fontWeight: FontWeight.bold)),
      ),
      body: Container(
        child: FutureBuilder<List<Blogs>>(
          future: getData(),
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(vertical: 15.0),
                reverse: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return SingleItem(data: snapshot.data[index]);
                },
              );
            }
            if(snapshot.hasError) {
              return Center(
                child: Text('No Post Available', style: GoogleFonts.roboto(fontSize: 20.0, color: Colors.yellow)),
              );
            }
            return Center(
              child: Container(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddBlogPage()));
        },
        child: Icon(Icons.add, color: Colors.black87),
        backgroundColor: Colors.yellow,
      ),
    );
  }
}

class SingleItem extends StatelessWidget {

  final Blogs data;
  SingleItem({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Color(0xff101010),
        borderRadius: BorderRadius.circular(5.0)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: Image(
                  image: NetworkImage(data.image),
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
                      colors: [Colors.transparent, Color(0xff101010)]
                    )
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 10.0),
          Text(data.title, style: GoogleFonts.openSans(fontSize: 20.0, color: Colors.yellow, fontWeight: FontWeight.bold)),
          SizedBox(height: 5.0),
          Text(data.desc, style: GoogleFonts.roboto(fontSize: 14.0, color: Colors.yellow[100])),
          SizedBox(height: 10.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.favorite_border, size: 25.0,  color: Colors.yellow[200]),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(FontAwesomeIcons.comment, size: 25.0,  color: Colors.yellow[200]),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(FontAwesomeIcons.paperPlane, size: 25.0,  color: Colors.yellow[200]),
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: 5.0),
        ],
      ),
    );
  }
}

