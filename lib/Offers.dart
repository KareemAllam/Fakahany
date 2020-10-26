import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fakahany/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fakahany/global/Colors.dart' as myColors;
import 'package:flutter_counter/flutter_counter.dart';

class Offers extends StatefulWidget {
  @override
  _OffersState createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  Future getDocs() async {
    QuerySnapshot querySnapshot =
        await Firestore.instance.collection("products").getDocuments();
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      var a = querySnapshot.documents[i];
      print(a.data['product_name']);
    }
  }

  final search = TextEditingController();
  int _defaultValue = 0;
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
                controller: search,
                textCapitalization: TextCapitalization.words,
                autofocus: false,
                decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Icon(
                        Icons.search,
                        color: myColors.red,
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

/*

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                textCapitalization: TextCapitalization.words,
                autofocus: false,
                decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Icon(
                        Icons.search,
                        color: myColors.red,
                      ), // icon is 48px widget.
                    ),
                    hintText: 'بحث',
                    alignLabelWithHint: true,
                    hintStyle: TextStyle(
                        color: myColors.red
                    ),
                    contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 5.0, 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0))
                ),
              ),
            ),
*/
            Expanded(
              child: StreamBuilder(
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
                      var num = index;
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
                                  GestureDetector(
                                    onTap: () {
                                      getDocs();
                                      setState(() {
//                                      snapshot.data.documents[index]
                                        Firestore.instance
                                            .collection('offer')
                                            .document(snapshot.data
                                                .documents[index].documentID
                                                .toString())
                                            .updateData({
                                          "order_quantity":
                                              snapshot.data.documents[index]
                                                      ['order_quantity'] +
                                                  1
                                        }).then((result) {
                                          print("new USer true");
                                        }).catchError((onError) {
                                          print("onError");
                                        });
                                        AddToCart(
                                            snapshot.data.documents[index]
                                                .documentID
                                                .toString(),
                                            snapshot.data.documents[index]
                                                ['order_quantity'],
                                            snapshot
                                                .data.documents[index]['image']
                                                .toString(),
                                            '01156460761',
                                            snapshot.data
                                                .documents[index]['price_offer']
                                                .toString(),
                                            snapshot
                                                .data
                                                .documents[index]
                                                    ['product_name']
                                                .toString());
                                      });
                                    },
                                    child: Image(
                                      width: double.infinity,
                                      height: 130,
                                      image: NetworkImage(snapshot
                                          .data.documents[index]['image']
                                          .toString()),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                snapshot.data.documents[index]['product_name']
                                    .toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        'ج.م',
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 18),
                                      ),
                                      Text(
                                        snapshot.data.documents[index]['price']
                                            .toString(),
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 4.0),
                                      child: Text(
                                        'ج.م',
                                        style: TextStyle(
                                            color: myColors.Primary,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 18),
                                      ),
                                    ),
                                    Text(
                                      snapshot
                                          .data.documents[index]['price_offer']
                                          .toString(),
                                      style: TextStyle(
                                          color: myColors.Primary,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 18),
                                    ),
                                  ],
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
                                      snapshot.data.documents[index]['unit']
                                          .toString(),
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
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
//                                      snapshot.data.documents[index]
                                        Firestore.instance
                                            .collection('offer')
                                            .document(snapshot.data
                                                .documents[index].documentID
                                                .toString())
                                            .updateData({
                                          "order_quantity":
                                              snapshot.data.documents[index]
                                                      ['order_quantity'] +
                                                  1
                                        }).then((result) {
                                          print("new USer true");
                                        }).catchError((onError) {
                                          print("onError");
                                        });
                                        AddToCart(
                                            snapshot.data.documents[index]
                                                .documentID
                                                .toString(),
                                            snapshot.data.documents[index]
                                                ['order_quantity'],
                                            snapshot
                                                .data.documents[index]['image']
                                                .toString(),
                                            '01156460761',
                                            snapshot.data
                                                .documents[index]['price_offer']
                                                .toString(),
                                            snapshot
                                                .data
                                                .documents[index]
                                                    ['product_name']
                                                .toString());
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: myColors.Primary,
                                          style: BorderStyle.solid,
                                          width: 0.3,
                                        ),
                                        color: Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.add,
                                            color: myColors.Primary,
                                            size: 30.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 40,
                                  ),
                                  positive(
                                      snapshot.data.documents[index]
                                          ['order_quantity'],
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
                                            .document(snapshot.data
                                                .documents[index].documentID
                                                .toString())
                                            .updateData({
                                          "order_quantity":
                                              snapshot.data.documents[index]
                                                      ['order_quantity'] -
                                                  1
                                        }).then((result) {
                                          print("new USer true");
                                        }).catchError((onError) {
                                          print("onError");
                                        });
                                        DeleteFromCart(
                                            snapshot.data.documents[index]
                                                .documentID
                                                .toString(),
                                            snapshot.data.documents[index]
                                                ['order_quantity'],
                                            snapshot
                                                .data.documents[index]['image']
                                                .toString(),
                                            '01156460761',
                                            snapshot.data
                                                .documents[index]['price_offer']
                                                .toString(),
                                            snapshot
                                                .data
                                                .documents[index]
                                                    ['product_name']
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
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.remove,
                                            color: Colors.black,
                                            size: 30.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*
  Widget drawScreen(BuildContext context) {
    return new StreamBuilder(
      stream: Firestore.instance
          .collection('category')
          */ /*        .where("owner_id", isEqualTo: _user.uid)
  */ /*
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          child: new Column(
//            primary: false,
            //          shrinkWrap: true,
            //        physics: NeverScrollableScrollPhysics(),
            children: snapshot.data.documents.map((document) {
              return GestureDetector(
                onTap: () {
                  */ /* serviceID = document['service_id'].toString();
          serviceName = document['name'].toString();
          phones = List.from(document['phone']);
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context)=>ServiceProfile(serviceID:serviceID,serviceName:serviceName),
          ));*/ /*
                },
                child: GridView.count(
                  // Create a grid with 2 columns. If you change the scrollDirection to
                  // horizo ntal, this produces 2 rows.
                  crossAxisCount: 2,
                  // Generate 100 widgets that display their index in the List.
                  children: List.generate(100, (index) {
                    return Center(
                      child: Text(
                        document['product_name'].toString(),
                      ),
                    );
                  }),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }*/

  DeleteFromCart(String doc, quantity, image, owner_Id, price, prod_name) {
    double total = (quantity - 1) * double.parse(price);
    Firestore.instance.collection('cart').document(doc).setData({
      'image': image,
      'owner_id': owner_Id,
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

  AddToCart(String doc, quantity, image, owner_Id, price, prod_name) {
    double total = (quantity + 1) * double.parse(price);
    Firestore.instance.collection('cart').document(doc).setData({
      'image': image,
      'owner_id': owner_Id,
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
