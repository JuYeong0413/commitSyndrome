import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../header/header.dart';
import './order_history_modal.dart';
import '../../util/box_shadow.dart';
import '../../util/to_text.dart';
import '../../util/palette.dart';
import '../../util/to_locale.dart';
//firebase database
import 'package:firebase_database/firebase_database.dart';
//loading
import 'package:loading_animations/loading_animations.dart';

class OrderHistory extends StatefulWidget {
  //OrderHistory ({  });

  @override
  OrderHistoryState createState() => OrderHistoryState();
}

class OrderHistoryState extends State<OrderHistory> {
  
  final databaseReference = FirebaseDatabase.instance.reference();

  var fetchedData;

  final data = [
    {
      'customer': '01012341234',
      'order_time': '2020-11-02',
      'order_number': 'A-88',
      'content': [
        {
          'name': 'cheese pizza',
          'cost': 12900,
          'option': {'size': 'regular', 'dough': 'standard'}
        },
        {
          'name': 'pepperoni',
          'cost': 16900,
          'option': {'size': 'large', 'dough': 'standard'}
        }
      ]
    },
    {
      'customer': '01012341234',
      'order_time': '2020-11-01',
      'order_number': 'A-84',
      'content': [
        {
          'name': 'gorgonzola pizza',
          'cost': 12900,
          'option': {'size': 'regular', 'dough': 'standard'}
        }
      ]
    },
    {
      'customer': '01012341234',
      'order_time': '2020-10-31',
      'order_number': 'A-79',
      'content': [
        {
          'name': 'gorgonzola pizza',
          'cost': 12900,
          'option': {'size': 'regular', 'dough': 'standard'}
        }
      ]
    },
    {
      'customer': '01012341234',
      'order_time': '2020-10-28',
      'order_number': 'A-64',
      'content': [
        {
          'name': 'gorgonzola pizza',
          'cost': 12900,
          'option': {'size': 'regular', 'dough': 'standard'}
        }
      ]
    }
  ];

  @override
  void initState() {
    super.initState();
    readData();
  }

  @override
  Widget build(BuildContext context) {
    if (this.fetchedData == null) {
      return Container(
        color: pale,
        child: LoadingBouncingGrid.circle(
          backgroundColor: white,
        ),
      );
    } else {
      return CustomHeader(
          body: SingleChildScrollView(
              child: Column(
        children: [
          makeTitle("주문", "내역"),
          ListView.builder(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: this.fetchedData.length,
            itemBuilder: (BuildContext context, int index) {
              // var orders = new Map<String, dynamic>.from(data[index]);
              var orders =
                  new Map<String, dynamic>.from(this.fetchedData[index]);

              int totalCost = 0;

              for (int i = 0; i < orders['content'].length; ++i) {
                totalCost += orders['content'][i]['cost'];
              }

              return customBoxContainerWithMargin(
                  MediaQuery.of(context).size.width * 0.9, // 가로 세로 1 : 2 비율
                  MediaQuery.of(context).size.width * 0.5,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            makeTitleSize('피자', ' PIZZA', 0.0, 16, true),
                            Text(
                              DateTime.now()
                                      .difference(
                                          DateTime.parse(orders['order_time']))
                                      .inDays
                                      .toString() +
                                  ' 일전',
                              style: TextStyle(
                                  color: darkblue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage('images/${orders['content'][0]['name']}.png'),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                makeTextSize(
                                    '주문번호 ' + orders['order_number'].toString(),
                                    darkgrey,
                                    20.0,
                                    14),
                                makeTextSize(
                                    orders['content'][0]['name']+ " 피자" +
                                        (orders['content'].length - 1 > 0
                                            ? ' 외 ' +
                                                (orders['content'].length - 1)
                                                    .toString() +
                                                '개'
                                            : ''),
                                    darkblue,
                                    20.0,
                                    14),
                                makeTextSize(toLocaleString(totalCost) + ' 원',
                                    lightgrey, 20.0, 14)
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: FlatButton(
                          color: orange,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          onPressed: () {
                            showOrderHistoryModal(context, orders);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.32,
                            height: MediaQuery.of(context).size.width * 0.08,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                new Icon(
                                  Icons.receipt,
                                  color: white,
                                  size: 15,
                                ),
                                new Text(
                                  "전자영수증보기",
                                  style: TextStyle(
                                      color: white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  true,
                  MediaQuery.of(context).size.height * 0.015, // 12.18 / 812
                  MediaQuery.of(context).size.width * 0.05); // 20 / 375
            },
          ),
        ],
      )));
    }
  }

  void readData() {
    databaseReference
        .child('user/history')
        .once()
        .then((DataSnapshot dataSnapshot) {
      setState(() {
        this.fetchedData = dataSnapshot.value;
      });
      // fetchedData = dataSnapshot.value;
    });
  }
}
