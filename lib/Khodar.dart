import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fakahany/global/Colors.dart' as myColors;

class Khodar extends StatefulWidget {
  @override
  _KhodarState createState() => _KhodarState();
}

class _KhodarState extends State<Khodar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('products')
            .where('category', isEqualTo: 'خضروات')
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
            ),   itemBuilder: (BuildContext context, int index) {
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
                          image: NetworkImage(snapshot
                              .data.documents[index]['image']
                              .toString()),
                          fit: BoxFit.cover,
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
                          fontWeight: FontWeight.normal,
                          fontSize: 18),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                    SizedBox(width: 115,),
                      Padding(
                        padding: const EdgeInsets.only(right:4.0),
                        child: Text(
                          'ج.م' ,
                          style: TextStyle(
                              color: myColors.Primary,
                              fontWeight: FontWeight.normal,
                              fontSize: 18),
                        ),
                      ),
                      Text(
                        snapshot.data.documents[index]['price']
                            .toString() ,
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
                        borderRadius:
                        BorderRadius.circular(5.0),
                      ),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            snapshot.data.documents[index]['unit']
                                .toString() ,
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
                                  .collection('products')
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
                              AddToCart(snapshot.data
                                  .documents[index].documentID
                                  .toString(),snapshot.data.documents[index]
                              ['order_quantity'],snapshot.data.documents[index]
                              ['image'].toString(),'01156460761',snapshot.data.documents[index]
                              ['price'].toString(),snapshot.data.documents[index]
                              ['product_name'].toString());
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
                        positive(snapshot.data.documents[index]
                        ['order_quantity'],snapshot.data
                            .documents[index].documentID
                            .toString()),
                        SizedBox(
                          width: 40,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              Firestore.instance
                                  .collection('products')
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
                              DeleteFromCart(snapshot.data
                                  .documents[index].documentID
                                  .toString(),snapshot.data.documents[index]
                              ['order_quantity'],snapshot.data.documents[index]
                              ['image'].toString(),'01156460761',snapshot.data.documents[index]
                              ['price_offer'].toString(),snapshot.data.documents[index]
                              ['product_name'].toString());

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
      ),
    );
  }
  DeleteFromCart(String doc,quantity,image,owner_Id,price,prod_name){
    double total=(quantity-1)*double.parse(price);
    Firestore.instance
        .collection('cart')
        .document(doc)
        .setData({
      'image':image,
      'owner_id':owner_Id,
      'price':price,
      'product_name':prod_name,
      "quantity_order":quantity-1,
      'total_price':total.toString()
    }).then((result) {
      print("OK");
    }).catchError((onError) {
      print("onError");
    });
  }

  AddToCart(String doc,quantity,image,owner_Id,price,prod_name){
    double total=(quantity+1)*double.parse(price);
    Firestore.instance
        .collection('cart')
        .document(doc)
        .setData({
      'image':image,
      'owner_id':owner_Id,
      'price':price,
      'product_name':prod_name,
      "quantity_order":quantity+1,
      'total_price':total
    }).then((result) {
      print("OK");
    }).catchError((onError) {
      print("onError");
    });
  }

  Widget positive(int num ,doc) {
    if (num <= 0) {
      Firestore.instance.collection('cart').document(doc).delete();
      return Text('0',
          style: TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.bold
          ));
    } else  {
      return Text(num.toString(),
          style: TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.bold
          ));
    }
  }
}
