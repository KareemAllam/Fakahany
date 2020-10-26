import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fakahany/Category.dart';
import 'package:fakahany/Khodar.dart';
import 'package:fakahany/Khodar_Moghaz.dart';
import 'package:fakahany/Offers.dart';
import 'package:fakahany/search.dart';
import 'package:flutter/material.dart';
import 'package:fakahany/global/Colors.dart' as myColors;

import 'Fwakeh.dart';

class Categories extends StatefulWidget {
  String Owner;
  Categories({this.Owner});

  @override
  _CategoriesState createState() => _CategoriesState(Owner);
}

class _CategoriesState extends State<Categories>
    with SingleTickerProviderStateMixin {
  String Owner;
  _CategoriesState(this.Owner);

  TabController _tabController;

  @override
  void initState() {
    // initialise your tab controller here
    _tabController = TabController(length: 10, vsync: this);
    super.initState();
  }

  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onTap: () async {
                  setState(() {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => SearchPage()));
                  });
                },
                controller: myController,
                textCapitalization: TextCapitalization.words,
                autofocus: false,
                decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Icon(
                        Icons.search,
                        color: Colors.green,
                      ), // icon is 48px widget.
                    ),
                    hintText: 'بحث',
                    alignLabelWithHint: true,
                    hintStyle: TextStyle(color: myColors.red),
                    contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 5.0, 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.green,
                isScrollable: true,
                indicatorColor: Colors.transparent,
                unselectedLabelColor: Colors.grey,
                unselectedLabelStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w700,
                ),
                labelStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                tabs: <Widget>[
                  Text('خضروات'),
                  Text('فواكه'),
                  Text('خضراوات وفاكهة مجهزه'),
                  Text('عروض اليوم'),
                  Text('لحوم'),
                  Text('مشروبات بارده'),
                  Text('مشروبات ساخنه'),
                  Text('مقالات'),
                  Text('بهارات وصوص'),
                  Text('أطعمه جافه ومعلبه'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  Body('خضروات'),
                  Body('فواكه'),
                  Body('خضروات وفاكهة مجهزه'),
                  offer(),
                  Body('لحوم'),
                  Body('مشروبات بارده'),
                  Body('مشروبات ساخنه'),
                  Body('مقالات'),
                  Body('بهارات وصوص'),
                  Body('اطعمه جافه ومعلبه')
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget Body(cat) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('products')
          .where('category', isEqualTo: cat)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 1.1),
          ),
          itemBuilder: (BuildContext context, int index) {
            return Card(
              elevation: 10,
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
                //                  mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (snapshot.data.documents[index]['order_quantity'] +
                                1 <=
                            snapshot.data.documents[index]['limit']) {
                          Firestore.instance
                              .collection('products')
                              .document(snapshot
                                  .data.documents[index].documentID
                                  .toString())
                              .updateData({
                            "order_quantity": snapshot.data.documents[index]
                                    ['order_quantity'] +
                                1
                          }).then((result) {
                            print("new USer true");
                          }).catchError((onError) {
                            print("onError");
                          });
                        } else if (snapshot.data.documents[index]
                                    ['order_quantity'] +
                                1 ==
                            snapshot.data.documents[index]['limit']) {
                          print('sdasdasdd');
                        }
                        AddToCart(
                            snapshot.data.documents[index].documentID
                                .toString(),
                            snapshot.data.documents[index]['order_quantity'],
                            snapshot.data.documents[index]['image'].toString(),
                            Owner,
                            snapshot.data.documents[index]['price'].toString(),
                            snapshot.data.documents[index]['product_name']
                                .toString(),
                            snapshot.data.documents[index]['limit']);
                      });
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        children: <Widget>[
                          Center(child: CircularProgressIndicator()),
                          Image(
                            width: double.infinity,
                            height: 130,
                            image: NetworkImage(snapshot
                                .data.documents[index]['image']
                                .toString()),
                            fit: BoxFit.fill,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      snapshot.data.documents[index]['product_name'].toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 18),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 115,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Text(
                          'ج.م',
                          style: TextStyle(
                              color: myColors.Primary,
                              fontWeight: FontWeight.normal,
                              fontSize: 18),
                        ),
                      ),
                      Text(
                        snapshot.data.documents[index]['price'].toString(),
                        style: TextStyle(
                            color: myColors.Primary,
                            fontWeight: FontWeight.normal,
                            fontSize: 18),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: myColors.Primary,
                          style: BorderStyle.solid,
                          width: 0.3,
                        ),
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            snapshot.data.documents[index]['unit'].toString(),
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 15,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (snapshot.data.documents[index]
                                          ['order_quantity'] +
                                      1 <=
                                  snapshot.data.documents[index]['limit']) {
                                print('sd');
                                Firestore.instance
                                    .collection('products')
                                    .document(snapshot
                                        .data.documents[index].documentID
                                        .toString())
                                    .updateData({
                                  "order_quantity": snapshot.data
                                          .documents[index]['order_quantity'] +
                                      1
                                }).then((result) {
                                  print("new USer true");
                                }).catchError((onError) {
                                  print("onError");
                                });
                              } else {
                                return null;
                              }
                              AddToCart(
                                  snapshot.data.documents[index].documentID
                                      .toString(),
                                  snapshot.data.documents[index]
                                      ['order_quantity'],
                                  snapshot.data.documents[index]['image']
                                      .toString(),
                                  Owner,
                                  snapshot.data.documents[index]['price']
                                      .toString(),
                                  snapshot.data.documents[index]['product_name']
                                      .toString(),
                                  snapshot.data.documents[index]['limit']);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: myColors.Primary,
                                style: BorderStyle.solid,
                                width: 0.3,
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.green,
                              size: 30.0,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        positive(
                            snapshot.data.documents[index]['order_quantity'],
                            snapshot.data.documents[index].documentID
                                .toString()),
                        SizedBox(
                          width: 40,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              Firestore.instance
                                  .collection('products')
                                  .document(snapshot
                                      .data.documents[index].documentID
                                      .toString())
                                  .updateData({
                                "order_quantity": snapshot.data.documents[index]
                                        ['order_quantity'] -
                                    1
                              }).then((result) {
                                print("new USer true");
                              }).catchError((onError) {
                                print("onError");
                              });
                              DeleteFromCart(
                                  snapshot.data.documents[index].documentID
                                      .toString(),
                                  snapshot.data.documents[index]
                                      ['order_quantity'],
                                  snapshot.data.documents[index]['image']
                                      .toString(),
                                  Owner,
                                  snapshot.data.documents[index]['price']
                                      .toString(),
                                  snapshot.data.documents[index]['product_name']
                                      .toString());
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                style: BorderStyle.solid,
                                width: 0.3,
                              ),
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.remove,
                                  color: Colors.black,
                                  size: 30.0,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          },
          itemCount: snapshot.data.documents.length,
        );
      },
    );
  }

  Widget offer() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('offer')
          .where('active', isEqualTo: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 1.1),
          ),
          itemBuilder: (BuildContext context, int index) {
            return Card(
              elevation: 10,
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
                //                  mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: <Widget>[
                        Center(child: CircularProgressIndicator()),
                        Image(
                          width: double.infinity,
                          height: 130,
                          image: NetworkImage(snapshot
                              .data.documents[index]['image']
                              .toString()),
                          fit: BoxFit.fill,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      snapshot.data.documents[index]['product_name'].toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 18),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 115,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Text(
                          'ج.م',
                          style: TextStyle(
                              color: myColors.Primary,
                              fontWeight: FontWeight.normal,
                              fontSize: 18),
                        ),
                      ),
                      Text(
                        snapshot.data.documents[index]['price'].toString(),
                        style: TextStyle(
                            color: myColors.Primary,
                            fontWeight: FontWeight.normal,
                            fontSize: 18),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: myColors.Primary,
                          style: BorderStyle.solid,
                          width: 0.3,
                        ),
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            snapshot.data.documents[index]['unit'].toString(),
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 15,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (snapshot.data.documents[index]
                                      ['order_quantity'] <=
                                  snapshot.data.documents[index]['limit']) {
                                print('sd');
                                Firestore.instance
                                    .collection('offer')
                                    .document(snapshot
                                        .data.documents[index].documentID
                                        .toString())
                                    .updateData({
                                  "order_quantity": snapshot.data
                                          .documents[index]['order_quantity'] +
                                      1
                                }).then((result) {
                                  print("new USer true");
                                }).catchError((onError) {
                                  print("onError");
                                });
                              } else {
                                return null;
                              }
                              AddToCart(
                                  snapshot.data.documents[index].documentID
                                      .toString(),
                                  snapshot.data.documents[index]
                                      ['order_quantity'],
                                  snapshot.data.documents[index]['image']
                                      .toString(),
                                  Owner,
                                  snapshot.data.documents[index]['price']
                                      .toString(),
                                  snapshot.data.documents[index]['product_name']
                                      .toString(),
                                  snapshot.data.documents[index]['limit']);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: myColors.Primary,
                                style: BorderStyle.solid,
                                width: 0.3,
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.green,
                              size: 30.0,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        positive(
                            snapshot.data.documents[index]['order_quantity'],
                            snapshot.data.documents[index].documentID
                                .toString()),
                        SizedBox(
                          width: 40,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              Firestore.instance
                                  .collection('offer')
                                  .document(snapshot
                                      .data.documents[index].documentID
                                      .toString())
                                  .updateData({
                                "order_quantity": snapshot.data.documents[index]
                                        ['order_quantity'] -
                                    1
                              }).then((result) {
                                print("new USer true");
                              }).catchError((onError) {
                                print("onError");
                              });
                              DeleteFromCart(
                                  snapshot.data.documents[index].documentID
                                      .toString(),
                                  snapshot.data.documents[index]
                                      ['order_quantity'],
                                  snapshot.data.documents[index]['image']
                                      .toString(),
                                  Owner,
                                  snapshot.data.documents[index]['price']
                                      .toString(),
                                  snapshot.data.documents[index]['product_name']
                                      .toString());
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                style: BorderStyle.solid,
                                width: 0.3,
                              ),
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.remove,
                                  color: Colors.black,
                                  size: 30.0,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          },
          itemCount: snapshot.data.documents.length,
        );
      },
    );
  }

  DeleteFromCart(String doc, quantity, image, owner_Id, price, prod_name) {
    double total = (quantity - 1) * double.parse(price);
    Firestore.instance.collection('cart').document(doc).setData({
      'image': image,
      'owner_id': Owner,
      'price': price,
      'product_name': prod_name,
      "quantity_order": quantity - 1,
      'total_price': total.toString()
    }).then((result) {
      print("OK");
    }).catchError((onError) {
      print("onError");
    });
  }

  AddToCart(String doc, quantity, image, owner_Id, price, prod_name, limit) {
    double total = (quantity + 1) * double.parse(price);
    if (quantity + 1 >= limit) {
      print('This is limit');
    } else {
      Firestore.instance.collection('cart').document(doc).setData({
        'image': image,
        'owner_id': Owner,
        'price': price,
        'product_name': prod_name,
        "quantity_order": quantity + 1,
        'total_price': total
      }).then((result) {
        print("OK");
      }).catchError((onError) {
        print("onError");
      });
    }
  }

  Widget positive(int num, doc) {
    if (num <= 0) {
      Firestore.instance.collection('cart').document(doc).delete();
      return Text('0',
          style: TextStyle(
              fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold));
    } else {
      return Text(num.toString(),
          style: TextStyle(
              fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold));
    }
  }
}
