import 'package:flutter/material.dart';


//stless
class ChatMessage extends StatelessWidget {
   ChatMessage({Key? key,
    required this.text, required this.sender,
  }) : super(key: key);

   String text= "";
   String sender="";

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(right: 15),
          child: CircleAvatar(
            child: Text(sender[0]),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(sender, style: Theme.of(context).textTheme.subtitle1,),
              Container(
                margin: EdgeInsets.only(top: 5),
                child: Text(text),
              )
            ],
          ),
        ),
      ],
    );
  }
}
