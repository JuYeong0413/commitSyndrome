import 'package:flutter/material.dart';
import 'package:gajuga_manage/util/palette.dart';
// firebase
import '../../../util/firebase_method.dart';

showDeleteModal(BuildContext cc, String rootKey, String dataReferenceKey,
      String itemKey) {
    return showDialog(
        context: cc,
        builder: (context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Container(
                width: MediaQuery.of(context).size.width / 3,
                height: MediaQuery.of(context).size.width / 6,
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "삭제하시겠습니까?",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RaisedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          color: superlight,
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "취소",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                        ),
                        RaisedButton(
                          onPressed: () {
                            FirebaseMethod().removeSpecificData(
                                rootKey, dataReferenceKey, itemKey);
                            Navigator.of(context).pop();
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          color: orange,
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "삭제",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ));
        });
  }