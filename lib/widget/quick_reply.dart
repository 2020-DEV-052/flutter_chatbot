import 'package:flutter/material.dart';

class QuickReply extends StatelessWidget {
  QuickReply({this.quickReplies, this.insertQuickReply, this.title});

  final List<String> quickReplies;
  final String title;
  final Function insertQuickReply;

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: <Widget>[
           new Text(this.title),
           new Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: quickReplies.map((quickReply) {
                return new Container(
                  margin: const EdgeInsets.all(5.0),
                  child: OutlineButton(
                    child: Text(quickReply),
                    borderSide: BorderSide(color: Colors.blue),
                    textColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    onPressed: () => insertQuickReply(quickReply),
                  ),
                );
              }).toList()),
        ],
      ),
    );
  }
}
