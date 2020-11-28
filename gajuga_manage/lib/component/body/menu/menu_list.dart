import 'package:flutter/material.dart';
import 'package:gajuga_manage/model/menu_model.dart';
import 'package:gajuga_manage/util/borders.dart';
import 'package:gajuga_manage/util/firebase_method.dart';
import 'package:gajuga_manage/util/loading.dart';
import 'package:gajuga_manage/util/palette.dart';
import 'package:gajuga_manage/util/to_locale.dart';
import 'package:gajuga_manage/util/to_text.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class MenuList extends StatefulWidget {
  MenuList({this.type, this.searchResult});

  final String type;
  final List<Information> searchResult;

  @override
  _MenuListState createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  // need MenuList
  var menuDatabaseFetched;

  final _formKey = GlobalKey<FormState>();
  File _menuImage;
  final picker = ImagePicker();

  void _menuUpdated() {
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: new Text("메뉴 수정이 완료되었습니다.")));
  }

  @override
  void initState() {
    super.initState();
    menuDatabaseFetched = FirebaseMethod().getMenuData();
  }

  @override
  Widget build(BuildContext context) {
    return this.widget.type == 'default' ? FutureBuilder(
      future: menuDatabaseFetched,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Information> pizza = Menu.fromJson(snapshot.data).pizza;
          List<Information> beverage = Menu.fromJson(snapshot.data).beverage;

          return Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  makeSubTitle('피자', ' PIZZA'),
                  Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.03,
                    ),
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: double.infinity,
                    child: ListView.builder(
                      itemCount: pizza.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _listItem(pizza, index, context);
                      },
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                  makeSubTitle('음료', ' BEVERAGE'),
                  Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.03,
                    ),
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: double.infinity,
                    child: ListView.builder(
                      itemCount: beverage.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _listItem(beverage, index, context);
                      },
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ],
              )
            ),
          );
        } else {
          return Expanded(
            child: Container(
              alignment: Alignment.center,
              child: customLoadingBouncingGrid(orange)
            ),
          );
        }
      },
    )
    : Expanded(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.03,
          ),
          height: MediaQuery.of(context).size.height * 0.35,
          width: double.infinity,
          child: this.widget.searchResult.length != 0
            ? ListView.builder(
                itemCount: this.widget.searchResult.length,
                itemBuilder: (BuildContext context, int index) {
                  return _listItem(this.widget.searchResult, index, context);
                },
                scrollDirection: Axis.horizontal,
              )
            : Center(
                child: Text(
                  '검색 결과가 없습니다.',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
        ),
      ),
    );
  }

  Widget _listItem(List<Information> menu, int index, BuildContext context) {
    String title = menu[index].name;
    String imageTitle = menu[index].engName;
    String desc = menu[index].desc;
    int cost = menu[index].cost;
    double itemWidth = MediaQuery.of(context).size.width * 0.18;
    double itemHeight = MediaQuery.of(context).size.width * 0.35;

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
          ),
        ],
      ),
      margin: EdgeInsets.only(left: 40, bottom: 20),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          CircleAvatar(
            backgroundImage: AssetImage('images/$imageTitle.png'),
            radius: 35,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                title,
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              Text(
                desc,
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: lightgrey,
                    fontSize: 11.0),
                textAlign: TextAlign.center,
              ),
              Text(
                '${toLocaleString(cost)} 원',
                style:
                    TextStyle(fontWeight: FontWeight.normal, color: darkblue),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          FlatButton(
            color: orange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onPressed: () {
              setState(() {
                Provider.of<Information>(context, listen: false).name = title;
                Provider.of<Information>(context, listen: false).cost = cost;
                Provider.of<Information>(context, listen: false).desc = desc;
                Provider.of<Information>(context, listen: false).engName =
                    menu[index].engName;
                Provider.of<Information>(context, listen: false).ingredients =
                    menu[index].ingredients;
              });
              showMenuEditDialog(context);
            },
            child: Container(
              alignment: Alignment.center,
              child: Text(
                "수정하기",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future showMenuEditDialog(BuildContext context) {
    String name = Provider.of<Information>(context, listen: false).name;
    String imageTitle =
        Provider.of<Information>(context, listen: false).engName;
    int cost = Provider.of<Information>(context, listen: false).cost;
    String desc = Provider.of<Information>(context, listen: false).desc;

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: CircleAvatar(
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                            children: [
                              TextSpan(
                                text: '메뉴',
                                style: TextStyle(color: darkgrey),
                              ),
                              TextSpan(
                                text: ' 수정',
                                style: TextStyle(color: orange),
                              ),
                            ],
                          ),
                        ),
                        menuImageView(imageTitle),
                        SizedBox(height: 20),
                        nameField(name),
                        priceField(cost),
                        descField(desc),
                        SizedBox(height: 10),
                        FlatButton(
                          color: orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          onPressed: () {
                            // TODO: 데이터 저장
                            Map data = {
                              'name': Provider.of<Information>(context,
                                      listen: false)
                                  .name,
                              'cost': Provider.of<Information>(context,
                                      listen: false)
                                  .cost,
                              'desc': Provider.of<Information>(context,
                                      listen: false)
                                  .desc,
                            };
                            print(data);

                            Navigator.of(context).pop();
                            _menuUpdated();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              "저장하고 닫기",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget menuImageView(String _imageTitle) {
    return Container(
      margin: EdgeInsets.only(top: 30),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            child: CircleAvatar(
              radius: 65.0,
              backgroundImage: _menuImage == null
                  ? AssetImage('images/$_imageTitle.png')
                  : FileImage(_menuImage),
            ),
          ),
          // Positioned(
          //   bottom: 0,
          //   right: 0,
          //   child: Container(
          //     width: 40,
          //     height: 40,
          //     decoration: BoxDecoration(
          //         color: Colors.white,
          //         border: Border.all(color: Color(0xFFe0e0e0)),
          //         borderRadius: BorderRadius.circular(50.0)),
          //     padding: EdgeInsets.all(0),
          //     alignment: Alignment.center,
          //     child: IconButton(
          //       onPressed: () {
          //         // getMenuImage();
          //       },
          //       icon: Icon(
          //         Icons.camera_alt,
          //         size: 20,
          //         color: Color(0xFFbbbbbb),
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  // Future getMenuImage() async {
  //   final pickedFile = await picker.getImage(source: ImageSource.gallery);

  //   setState(() {
  //     if (pickedFile != null) {
  //       _menuImage = File(pickedFile.path);
  //     } else {
  //       print('No image selected.');
  //     }
  //   });
  // }

  Widget nameField(String _name) {
    return Row(
      children: [
        Text(
          '이       름',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(8),
            child: TextFormField(
              onChanged: (text) {
                Provider.of<Information>(context, listen: false).name = text;
              },
              keyboardType: TextInputType.text,
              initialValue: _name,
              decoration: new InputDecoration(
                enabledBorder: roundInputBorder,
                focusedBorder: roundInputBorder,
                hintText: '이름 입력',
                isDense: true,
                contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget priceField(int _cost) {
    return Row(
      children: [
        Text(
          '가       격',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(8),
            child: TextFormField(
              onChanged: (text) {
                Provider.of<Information>(context, listen: false).cost =
                    int.parse(text);
              },
              keyboardType: TextInputType.number,
              initialValue: _cost.toString(),
              decoration: new InputDecoration(
                enabledBorder: roundInputBorder,
                focusedBorder: roundInputBorder,
                hintText: '가격 입력',
                isDense: true,
                contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget descField(String _desc) {
    return Row(
      children: [
        Text(
          '메뉴설명',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Flexible(
          child: Container(
            width: MediaQuery.of(context).size.width / 5,
            padding: EdgeInsets.all(8),
            child: TextFormField(
              onChanged: (text) {
                Provider.of<Information>(context, listen: false).desc = text;
              },
              keyboardType: TextInputType.text,
              initialValue: _desc,
              minLines: 6,
              maxLines: 10,
              decoration: new InputDecoration(
                enabledBorder: bigRoundInputBorder,
                focusedBorder: bigRoundInputBorder,
                hintText: '추가사항 입력',
                isDense: true,
                contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
