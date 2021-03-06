import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gajuga_user/component/body/sub_menu.dart';
import 'package:gajuga_user/util/box_shadow.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../util/to_locale.dart';
import '../../util/to_text.dart';
import '../../util/box_shadow.dart';
import '../../util/palette.dart';
import '../body/category_menu.dart';
import '../../model/menu_model.dart';
import '../../util/to_locale.dart';
import 'package:gajuga_user/main.dart';
import 'package:loading_animations/loading_animations.dart';
import '../../util/firebase_method.dart';

class TotalMenu extends StatefulWidget {
  @override
  TotalMenuState createState() => TotalMenuState();
}

class TotalMenuState extends State<TotalMenu> {
  final DBRef = FirebaseDatabase.instance.reference();
  final List<String> data = ['gorgonzola', 'pepperoni', 'bulgogi', 'potato'];

  var currentState = 'pizza';
  var currentMenuList;

  var tmp = 0;
  int shoppingCartCount = 0;

  List<String> mainList = ['gorgonzola', 'pepperoni', 'bulgogi', 'potato'];
  int randomIndex = new Random().nextInt(3);

  void readData() {
    DBRef.child('manager/menu/category/' + currentState)
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        setState(() {
          currentMenuList = dataSnapshot.value;
        });
        // print('사이즈' + currentMenuList.length.toString());
      } else {
        // print('데이터 없음');
      }
      // fetchedData = dataSnapshot.value;
    });
  }

  void getShoppingCartCount() {
    DBRef.child('user/userInfo/' + MainScreen.userid + '/shoppingCart')
        .orderByChild('cost')
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        //print(dataSnapshot.value.length);
        // ppState.setState(() {
        //   ppState.shoppingCartCount = dataSnapshot.value.length;
        // });
        //print('이거 안나옴 ? ' + dataSnapshot.value.length.toString());
        Map<dynamic, dynamic> values = dataSnapshot.value;
        // setState(() {
        //   shoppingCartCount = values.length;
        // });
      }
      // else {
      //   setState(() {
      //     shoppingCartCount = 0;
      //   });
      // }
    });
  }

  void goSubMenu(dynamic menuItem) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SubmenuScreen(
                item: menuItem['name'],
                cost: menuItem['cost'],
                desc: menuItem['desc'],
                engname: menuItem['eng_name'])));
  }

  void addShoppingCart(dynamic menuItem) {
    // print('이름' + menuItem['name']);
    String push =
        DBRef.child('user/userInfo/' + MainScreen.userid + '/shoppingCart')
            .push()
            .key;

    if (currentState == 'pizza') {
      DBRef.child('user/userInfo/' + MainScreen.userid + '/shoppingCart')
          .child(push)
          .set({
        'cost': menuItem['cost'],
        'name': menuItem['name'],
        'count': 1,
        'option': {
          'dough': '기본',
          'size': '레귤러',
        },
        'eng_name': menuItem['eng_name'],
      });
    } else if (currentState == 'beverage') {
      DBRef.child('user/userInfo/' + MainScreen.userid + '/shoppingCart')
          .child(push)
          .set({
        'cost': menuItem['cost'],
        'name': menuItem['name'],
        'eng_name': menuItem['eng_name'],
      });
    }
    getShoppingCartCount();
    // ppState.setState(() {
    //   ppState.shoppingCartCount = getShoppingCartCount();
    // });
  }

  void addMenuItem(Menu menu) {
    int i = 0;
    // print(menu.ingredients);
    DBRef.child('user')
        .child('userInfo')
        .child(MainScreen.userid)
        .child('shoppingCart')
        .set({
      "name": menu.name,
      "cost": menu.cost,
      'ingrdients': [
        for (Ingredient ingre in menu.ingredients)
          {
            ingre.name: ingre.quantity,
          }
      ]
    });
  }

  void toCategoryMenu(BuildContext context) async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => CategoryMenu()));
    //DBRef.child('menu').set(menudata);
    if (result) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    readData();

    //getCurrentList();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    //print('메인 실행 ! ');
    if (this.currentMenuList == null) {
      return Container(
        alignment: Alignment.center,
        color: pale,
        child: LoadingBouncingGrid.circle(
          backgroundColor: white,
        ),
      );
    } else {
      return Container(
          //height: 530,
          height: MediaQuery.of(context).size.height * 0.65,
          child: Column(
            children: <Widget>[
              // makeTitle('전체', ' 메뉴'),
              GestureDetector(
                onTap: () {
                  toCategoryMenu(context);
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => CategoryMenu()));
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 20),
                  child: Row(
                    children: [
                      Text(
                        '전체 ',
                        style: TextStyle(
                            color: Color.fromRGBO(218, 155, 104, 1.0),
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        '메뉴',
                        style: TextStyle(
                            color: Color.fromRGBO(33, 33, 31, 1.0),
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                        textAlign: TextAlign.left,
                      )
                    ],
                  ),
                ),
              ),
              Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    margin: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                'images/${mainList[randomIndex]}.png'),
                            fit: BoxFit.cover)),
                    // child: Image(
                    //   image: AssetImage('images/고르곤졸라피자.png'),
                    //   fit: BoxFit.cover,
                    //   // height: 427,
                    // ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.2),
                    height: MediaQuery.of(context).size.height * 0.6,
                    width: double.infinity,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(left: 40),
                      itemCount: this.currentMenuList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _listItem(
                            this.currentMenuList[index]['name'],
                            AssetImage(
                                'images/${this.currentMenuList[index]['eng_name']}.png'),
                            this.currentMenuList[index]['desc'],
                            this.currentMenuList[index]['cost'],
                            context,
                            this.currentMenuList[index]);
                      },
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ],
              ),
            ],
          ));
    }
  }

  Widget _listItem(String title, AssetImage image, String desc, int cost,
      BuildContext context, dynamic menuItem) {
    double itemWidth = MediaQuery.of(context).size.width * 0.45;
    double itemHeight = MediaQuery.of(context).size.height * 0.35;

    return Container(
      width: itemWidth,
      height: itemHeight,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.16),
              offset: Offset(0, 3),
              blurRadius: 6,
            )
          ]),
      margin: EdgeInsets.only(left: 40, bottom: 20),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          CircleAvatar(
            backgroundImage: image,
            radius: 35,
          ),
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16),
              textAlign: TextAlign.center),
          Text(desc,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                  fontSize: 12),
              textAlign: TextAlign.center),
          Text(toLocaleString(cost) + " 원",
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                  fontSize: 14),
              textAlign: TextAlign.center),
          FlatButton(
            color: orange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onPressed: () {
              //addShoppingCart(menuItem);
              goSubMenu(menuItem);

              // Scaffold.of(context).showSnackBar(SnackBar(
              //   padding: EdgeInsets.only(left: 20.0),
              //   content: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       Container(
              //         alignment: Alignment.centerLeft,
              //         height: itemHeight * 0.1,
              //         child: Text(
              //           '메뉴 ' + title + ' 가 장바구니에 담겼습니다 :)',
              //           style: TextStyle(
              //               fontWeight: FontWeight.bold, fontSize: 12.0),
              //         ),
              //       ),
              //       FlatButton(
              //         onPressed: () {
              //           Scaffold.of(context).hideCurrentSnackBar();
              //         },
              //         // child: Text(
              //         //   'X',
              //         //   style: TextStyle(
              //         //       fontWeight: FontWeight.bold, fontSize: 12.0),
              //         //   textAlign: TextAlign.right,
              //         // ),
              //         child: Icon(
              //           Icons.close,
              //           size: 24,
              //           color: white,
              //         ),
              //       )
              //     ],
              //   ),
              //   behavior: SnackBarBehavior.floating,
              //   backgroundColor: orange,
              //   shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(30)),
              //   elevation: 10.0,
              // ));
            },
            child: Container(
              alignment: Alignment.center,
              height: itemHeight * 0.09,
              width: itemWidth * 0.6,
              child: Text(
                "메뉴 선택",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class FavoriteMenuWidget extends StatefulWidget {
  @override
  FavoriteMenuWidgetState createState() => FavoriteMenuWidgetState();
}

class FavoriteMenuWidgetState extends State<FavoriteMenuWidget> {
  // List<Map<String, dynamic>> mainList = new List<Map<String, dynamic>>();
  var mainList;
  var salesDatabaseFetched;
  int randomIndex = new Random().nextInt(3);

  void readData() {
    FirebaseDatabase.instance
        .reference()
        .child('manager/menu/category/pizza')
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        // print(dataSnapshot.value);
        setState(() {
          mainList = dataSnapshot.value;
        });
      } else {
        print('데이터 없음');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    readData();
    salesDatabaseFetched = FirebaseMethod().getTotalSalesData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        makeTitle("인기", " 메뉴"),
        Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.16,
            margin: EdgeInsets.only(left: 25, top: 15, right: 25),
            padding: EdgeInsets.only(top: 10, bottom: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [customeBoxShadow()]),
            child: FutureBuilder(
              future: salesDatabaseFetched,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  // data length
                  int ggz = 0;
                  int ptt = 0;
                  int ppr = 0;
                  int bgg = 0;

                  Map<String, double> todayData = {
                    "고르곤졸라피자": 0,
                    "포테이토피자": 0,
                    "페퍼로니피자": 0,
                    "불고기피자": 0
                  };

                  //data
                  Map<String, dynamic> menuData =
                      new Map<String, dynamic>.from(snapshot.data);
                  DateTime now = new DateTime.now();
                  DateTime selectedDate =
                      new DateTime(now.year, now.month - 1, now.day);

                  // check info is in the data
                  if (DateTime.parse(menuData.keys.last)
                          .isAfter(selectedDate) ==
                      true) {
                    var calculatedResult =
                        calculateSales(menuData, selectedDate);
                    double totalCount = 0;

                    calculatedResult.forEach((key, value) {
                      totalCount += value.toDouble();
                    });

                    todayData['고르곤졸라피자'] =
                        calculatedResult['고르곤졸라피자'].toDouble() *
                            100 /
                            totalCount;
                    todayData['포테이토피자'] =
                        calculatedResult['포테이토피자'].toDouble() *
                            100 /
                            totalCount;
                    todayData['페퍼로니피자'] =
                        calculatedResult['페퍼로니피자'].toDouble() *
                            100 /
                            totalCount;
                    todayData['불고기피자'] =
                        calculatedResult['불고기피자'].toDouble() * 100 / totalCount;

                    var newMap = Map.fromEntries(todayData.entries.toList()
                      ..sort((e1, e2) => (e1.value).compareTo(e2.value)));
                    var favoriteList;
                    // newMap.forEach((key, value) {
                    //   newMap.entries.elementAt(3).key;
                    // });
                    int returnMenuIndex(String name) {
                      int index = 0;
                      for (var i = 0; i < 4; i++) {
                        if (mainList[i]['name'] == name) index = i;
                      }

                      return index;
                    }

                    String changeImage(String name) {
                      switch (name) {
                        case '고르곤졸라피자':
                          return 'gorgonzola';
                        case '포테이토피자':
                          return 'potato';
                        case '페퍼로니피자':
                          return 'pepperoni';
                        case '불고기피자':
                          return 'bulgogi';
                        default:
                          return "A";
                      }
                    }

                    return Container(
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: 3,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SubmenuScreen(
                                                item: mainList[returnMenuIndex(newMap.entries.elementAt(index + 1).key)]
                                                    ['name'],
                                                cost: mainList[returnMenuIndex(
                                                    newMap.entries
                                                        .elementAt(index + 1)
                                                        .key)]['cost'],
                                                desc: mainList[
                                                        returnMenuIndex(newMap.entries.elementAt(index + 1).key)]
                                                    ['desc'],
                                                engname:
                                                    mainList[returnMenuIndex(newMap.entries.elementAt(index + 1).key)]
                                                        ['eng_name'])));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: 30, top: 10, right: 30),
                                    alignment: Alignment.center,
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: AssetImage(
                                              'images/' +
                                                  changeImage(newMap.entries
                                                      .elementAt(index + 1)
                                                      .key) +
                                                  '.png'),
                                        ),
                                        Text(
                                          // "메뉴 " + mainList[index]['name'].substring(0,3),
                                          (index + 1).toString() + " 등",
                                          style: TextStyle(
                                              color: darkblue,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ));
                            }));
                  } else {
                    return Center(
                      child: Text(' 충분한 데이터가 존재하지 않습니다.'),
                    );
                  }
                } else {
                  return Center(
                    child: Text(' 충분한 데이터가 존재하지 않습니다.'),
                  );
                }
              },
            ))
      ],
    ));
  }

  Map<String, int> calculateSales(
      Map<String, dynamic> menuData, DateTime selectedDate) {
    // data length
    int ggz = 0;
    int ptt = 0;
    int ppr = 0;
    int bgg = 0;

    menuData.forEach((key, value) {
      // key compareTo selectedDate
      if (DateTime.parse(key).compareTo(selectedDate) <= 0) {
        // before and same

        // autoKey: Order
        if (value.runtimeType != int) {
          // 11-22 : 1
          var fetchedOrderInfo = Map<dynamic, dynamic>.from(value);
          fetchedOrderInfo.forEach((key, value) {
            // contents
            var contentList =
                List<Map<dynamic, dynamic>>.from(value['contents']);
            // list
            contentList.forEach((element) {
              switch (element['name']) {
                case "고르곤졸라피자":
                  ggz += element['count'];
                  break;
                case "포테이토피자":
                  ptt += element['count'];
                  break;
                case "페퍼로니피자":
                  ppr += element['count'];
                  break;
                case "불고기피자":
                  bgg += element['count'];
                  break;
                default:
              }
            });
          });
        }
      }
    });

    Map<String, int> result = {
      "고르곤졸라피자": ggz,
      "포테이토피자": ptt,
      "페퍼로니피자": ppr,
      "불고기피자": bgg
    };

    return result;
  }
}
