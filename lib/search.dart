import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'searchservices.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.length == 0 && value.length == 1) {
      SearchService().searchByName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          queryResultSet.add(docs.documents[i].data);
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['product_name'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return new Scaffold(
        body: ListView(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextFormField(
          onChanged: (val) {
            initiateSearch(val);
          },
          autofocus: true,
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
              hintStyle: TextStyle(color: Colors.green),
              contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 5.0, 10.0),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0))),
        ),
      ),
      SizedBox(height: 10.0),
      GridView.count(
          childAspectRatio: (itemWidth / itemHeight),
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          crossAxisCount: 2,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
          primary: false,
          shrinkWrap: true,
          children: tempSearchStore.map((element) {
            return buildResultCard(element);
          }).toList())
    ]));
  }

  Widget buildResultCard(data) {
    return Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        elevation: 2.0,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: <Widget>[
                  Center(child: CircularProgressIndicator()),
                  Image(
                    width: double.infinity,
                    height: 100,
                    image: NetworkImage(data['image']),
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                data['product_name'],
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
              ),
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Text(
                    'ج.م',
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.normal,
                        fontSize: 18),
                  ),
                ),
                Text(
                  data['price'],
                  style: TextStyle(
                      color: Colors.green,
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
                    color: Colors.green,
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
                      data['unit'],
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
                        Firestore.instance
                            .collection('products')
                            .document(data['id'])
                            .updateData({
                          "order_quantity": data['order_quantity'] + 1
                        }).then((result) {
                          print("new USer true");
                        }).catchError((onError) {
                          print("onError");
                        });
                        AddToCart(
                            data['id'].toString(),
                            data['order_quantity'],
                            data['image'].toString(),
                            '01156460761',
                            data['price'].toString(),
                            data['product_name'].toString());
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.green,
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
                            Icons.add,
                            color: Colors.green,
                            size: 30.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  positive(data['order_quantity'], data['id'].toString()),
                  SizedBox(
                    width: 40,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        Firestore.instance
                            .collection('products')
                            .document(data['id'].toString())
                            .updateData({
                          "order_quantity": data['order_quantity'] - 1
                        }).then((result) {
                          print("new USer true");
                        }).catchError((onError) {
                          print("onError");
                        });
                        DeleteFromCart(
                            data['id'].toString(),
                            data['order_quantity'],
                            data['image'].toString(),
                            '01156460761',
                            data['price'].toString(),
                            data['product_name'].toString());
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
        ));
  }

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
      setState(() {
        Firestore.instance.collection('cart').document(doc).delete();
        return Text('0',
            style: TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.bold));
      });
    } else {
      return Text(num.toString(),
          style: TextStyle(
              fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold));
    }
  }
}
