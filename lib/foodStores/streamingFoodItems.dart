import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StreamNewItem extends StatefulWidget {
  final String storeId;
  const StreamNewItem({super.key,required this.storeId});

  @override
  State<StreamNewItem> createState() => _StreamNewItemState();
}

class _StreamNewItemState extends State<StreamNewItem> {
  final Stream<QuerySnapshot> itemStream =
      FirebaseFirestore.instance.collection('foodItems').where('store_id',isEqualTo:storeId).snapshots();

  static get storeId => storeId;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: itemStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong!');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Loading');
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                return itemCard(context,0,data['item_name'],data['item_image'],data['item_price'].toString(),);
              }).toList()
            ,
          );
        });
  }

  Padding itemCard(BuildContext context,id,itemName,itemImage,itemPrice) {
    Map<dynamic, dynamic> count={};
    if (count.containsKey(id)==false){
      count[id]=0;
    }
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width * .95,
          height: 120,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                        borderRadius:
                        BorderRadius.all(Radius.circular(20)),
                        child: Container(
                          height: 100,
                          width: 100,
                          child: Image.network(
                            itemImage,
                            fit: BoxFit.cover,
                          ),
                        ))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [Text(itemName,style: TextStyle(
                            fontSize: 20))],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [Text('₹'+itemPrice,style: TextStyle(
                            fontSize: 20))],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 35,
                            width: 95,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10))),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (count[id]<0) {
                                        count[id]= 0;
                                      }
                                      else{
                                        count[id]=count[id]!-1;
                                      }
                                    });
                                  },
                                  child: Container(
                                    child: const Text(
                                      '-',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    count[id].toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      count[id]++;
                                      print(count[id]);
                                    });
                                  },
                                  child: Container(
                                    child: Text(
                                      '+',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 35,
                            width: 95,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10))),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_shopping_cart_rounded,
                                  color: Colors.white,
                                ),
                                Container(
                                  child: Text(
                                    'Add to cart',
                                    style: TextStyle(
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
