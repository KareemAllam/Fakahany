import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fakahany/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:image_auto_slider/image_auto_slider.dart';
import 'package:flutter_images_slider/flutter_images_slider.dart';
import 'package:fakahany/global/Colors.dart' as myColors;

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }

  return result;
}

final List<String> imgList = [
  'https://img.youtube.com/vi/3KZ7Xc_afdY/0.jpg',
  'https://www.almuheet.net/wp-content/uploads/%D8%A7%D8%B9%D9%84%D8%A7%D9%86-%D8%AA%D8%AC%D8%A7%D8%B1%D9%8A-%D8%B9%D9%86-%D8%A7%D9%84%D8%AD%D9%84%D9%8A%D8%A8.jpg',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQk2FLNtR7WZxr9DR2h_gKbn0NmxrBArv37aQ&usqp=CAU',
];

class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  int _current = 0;

  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    Ads();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Stack(children: [
            Padding(
                padding: EdgeInsets.symmetric(vertical: 0.0),
                child: ImagesSlider(
                  indicatorColor: myColors.red,
                  indicatorBackColor: myColors.Primary,
                  items: map<Widget>(imgList, (index, i) {
                    return Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(i), fit: BoxFit.cover)),
                    );
                  }),
                  autoPlay: true,
                  viewportFraction: 1.0,
                  aspectRatio: 2.0,
                  distortion: false,
                  align: IndicatorAlign.bottom,
                  indicatorWidth: 5,
                  updateCallback: (index) {
                    setState(() {
                      _current = index;
                    });
                  },
                )),
          ]),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onTap: () async {
                setState(() {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => SearchPage()));
                });
              },
              textCapitalization: TextCapitalization.words,
              autofocus: false,
              controller: _emailController,
              decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 5.0),
                    child: Icon(
                      Icons.search,
                      color: myColors.red,
                    ), // icon is 48px widget.
                  ),
                  hintText: 'ابحث',
                  contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 5.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0))),
            ),
          ),
          Container(child: drawScreen(context)),
        ],
      ),
    ));
  }

  Widget drawScreen(BuildContext context) {
    return new StreamBuilder(
      stream: Firestore.instance
          .collection('category')
          /*        .where("owner_id", isEqualTo: _user.uid)
  */
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return new ListView(
          primary: false,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: snapshot.data.documents.map((document) {
            return GestureDetector(
              onTap: () {
                /* serviceID = document['service_id'].toString();
        serviceName = document['name'].toString();
        phones = List.from(document['phone']);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context)=>ServiceProfile(serviceID:serviceID,serviceName:serviceName),
        ));*/
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                margin: EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          children: <Widget>[
                            Center(child: CircularProgressIndicator()),
                            Image(
                              width: double.infinity,
                              image: NetworkImage(document['image'].toString()),
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          document['category_name'],
                          style: TextStyle(
                              color: Colors.grey.shade900,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Ads() {
    List<String> AdsList;
    Firestore.instance
        .collection('Ads')
        .getDocuments()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.documents.forEach((doc) {
                print(doc["ads_images"]);
                AdsList.add(doc["ads_images"]);
              })
            });
    return AdsList;
  }
}
