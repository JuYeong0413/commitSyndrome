import 'package:flutter/material.dart';
import '../header/header.dart';
import '../../model/order_history_model.dart';
import '../../util/box_shadow.dart';
import '../../util/to_text.dart';
import '../../util/palette.dart';
import '../../util/to_locale.dart';
import 'package:intl/intl.dart';

class OrderHistory extends StatefulWidget {
  //OrderHistory ({  });

  @override
  OrderHistoryState createState() => OrderHistoryState();
}

class OrderHistoryState extends State<OrderHistory> {
  final data = [
    {
      'customer': '01012341234',
      'order_time': '2020-11-02',
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
  Widget build(BuildContext context) {
    void _showReciept() {}

    return CustomHeader(
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          var orders = new Map<String, dynamic>.from(data[index]);
          int totalCost = 0;

          for(int i=0; i<orders['content'].length; ++i) {
            totalCost += orders['content'][i]['cost'];
          }

          return customBoxContainerWithMargin(
              MediaQuery.of(context).size.width * 0.8,
              MediaQuery.of(context).size.height * 0.22,
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
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
                  Container(
                    margin: EdgeInsets.only(top:15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage('images/A.png'),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            makeTextSize(orders['content'][0]['name'] + (orders['content'].length - 1 > 0 ? ' 외 ' + (orders['content'].length - 1).toString() + '개' : ''), darkblue,
                                20.0, 14),
                            makeTextSize(
                                toLocaleString(totalCost) +
                                    ' 원',
                                lightgrey,
                                20.0,
                                14)
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        height: MediaQuery.of(context).size.height * 0.04,
                        decoration: BoxDecoration(
                            boxShadow: [customeBoxShadow()],
                            color: orange,
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            new IconButton(
                                icon: Icon(Icons.receipt),
                                color: white,
                                iconSize: 15,
                                onPressed: _showReciept),
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
              15,
              20);
        },
      ),
    );
  }
}
