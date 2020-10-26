import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fakahany/global/Colors.dart' as myColors;

class Cart extends StatefulWidget {
  String Owner;
  Cart({this.Owner});

  @override
  _CartState createState() => _CartState(Owner);
}

class _CartState extends State<Cart> {
  String Owner;
  _CartState(this.Owner);

  List items = [];
  Map<String, Object> itemMap = {};

  @override
  void initState() {
    // TODO: implement initState

    getData();
    super.initState();
  }

  List itemss = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'الشنطه',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(child: drawScreen(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget drawScreen(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Column(
            children: [
              new StreamBuilder(
                stream: Firestore.instance
                    .collection('cart')
                    .where("owner_id", isEqualTo: Owner)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return new ListView(
                    primary: false,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: snapshot.data.documents.map((document) {
                      return Column(
                        children: <Widget>[
                          GestureDetector(
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
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Stack(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0),
                                            child: Image(
                                              width: double.infinity,
                                              image: NetworkImage(
                                                  document['image'].toString()),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          document['product_name'].toString(),
                                        ),
                                        Text(
                                          document['price'].toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(17.0),
                                    child: Column(
                                      children: <Widget>[
                                        Text('الأجمالى'),
                                        Text(
                                          document['total_price'].toString() +
                                              'EGP',
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 17),
                                    child: Column(
                                      children: <Widget>[
                                        Text('الكميه'),
                                        Text(
                                          document['quantity_order'].toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        Firestore.instance
                                            .collection('cart')
                                            .document(document.documentID)
                                            .delete();
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(30.0),
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: double.infinity,
                  height: 0.5,
                  color: Colors.grey,
                ),
              ),
              StreamBuilder(
                stream: Firestore.instance
                    .collection('cart')
                    .where("owner_id", isEqualTo: Owner)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
//                    snapshot.data.documents.map((e) => data);

                    //                  itemMap = {'product_name': data['product_name']};
                    return new Column(
                      children: snapshot.data.documents.map((document) {
                        return Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  document['total_price'].toString(),
                                  style: TextStyle(fontSize: 30),
                                ),
                                Text(
                                  'الاجمالى',
                                  style: TextStyle(
                                      color: myColors.Primary, fontSize: 30),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.all(80.0),
                child: Center(
                  child: InkWell(
                    onTap: () {
                      // Firestore.instance
                      //     .collection("order")
                      //     .document()
                      //     .setData({
                      //   'items': FieldValue.arrayUnion(items = [itemMap]),
                      // });
                    },
                    child: Container(
                      child: Text(
                        'Done',
                        style: TextStyle(fontSize: 50),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
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

  Widget Total(length, price, quantity) {
    double total = 0;
    for (int i = 0; i++ != null; i < length) {
      total += (price * quantity);
    }
    return Text(total.toString());
  }

  dynamic data;

  Future<dynamic> getData() async {
    final DocumentReference document =
        Firestore.instance.collection("cart").document();

    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        data = snapshot.data;
      });
    });
  }
}
