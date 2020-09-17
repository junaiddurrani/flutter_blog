import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/authentication_page.dart';
import 'package:flutter_blog/blogs.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'add_blog_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  List<Blogs> blogsData = [];

  Future _getBlogData() async {
    DatabaseReference reference = await FirebaseDatabase.instance.reference();
    reference.child("Blogs").once().then((DataSnapshot snapshot){
      var keys = snapshot.value.keys;
      var data = snapshot.value;

      blogsData.clear();

      for (var singleKey in keys) {
        Blogs blogModel = Blogs(
          image: data[singleKey]["image"],
          title: data[singleKey]["title"],
          desc: data[singleKey]["desc"],
        );
        setState(() {
          blogsData.add(blogModel);
          blogsData.reversed;
        });
        reference.keepSynced(true);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getBlogData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Container(
        padding: EdgeInsets.only(top: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 25.0, top: 10.0, bottom: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tech Spartans', style: GoogleFonts.bubblegumSans(color: Colors.yellow, fontSize: 32.0, fontWeight: FontWeight.bold)),
                  PopupMenuButton(
                    color: Colors.yellow,
                    icon: Icon(Icons.more_vert, color: Colors.yellow),
                    itemBuilder: (context) => [
                      PopupMenuItem<String>(child: Text('Log Out'), value: 'Log Out'),
                    ],
                    onSelected: (_) {
                      _firebaseAuth.signOut();
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => AuthenticationPage()), (route) => false);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: blogsData == null ? Center(child: CircularProgressIndicator()) : ListView.builder(
                itemCount: blogsData.length,
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(vertical: 15.0),
                itemBuilder: (context, index) {
                  return SingleItem(image: blogsData[index].image, title: blogsData[index].title, description: blogsData[index].desc);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddBlogPage()));
        },
        child: Icon(Icons.add, color: Colors.black87),
      ),
    );
  }
}

class SingleItem extends StatelessWidget {
  final String image, title, description;

  SingleItem({Key key, this.image, this.title, this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Color(0xff101010),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 250.0,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0), topRight: Radius.circular(5.0)),
                  child: Image(
                    image: NetworkImage(image),
                    filterQuality: FilterQuality.high,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                    color: Colors.black45,
                    colorBlendMode: BlendMode.darken,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60.0,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Color(0xff101010)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter
                      )
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.roboto(color: Colors.yellow, fontSize: 20.0, fontWeight: FontWeight.bold)),
                SizedBox(height: 10.0),
                Text(description, style: GoogleFonts.openSans(color: Colors.yellow[100], fontSize: 13.0)),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.favorite_border, color: Colors.yellow[200], size: 25.0),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(FontAwesomeIcons.comment, color: Colors.yellow[200], size: 25.0),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(FontAwesomeIcons.paperPlane, color: Colors.yellow[200], size: 25.0),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5.0)
              ],
            ),
          )
        ],
      ),
    );
  }
}
