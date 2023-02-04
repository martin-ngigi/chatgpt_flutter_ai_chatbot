import 'package:chatgpt_flutter_ai_chatbot/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

//stful
class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];

  void sendMessage(){
    ChatMessage _message = ChatMessage(text: _controller.text, sender: "sender");

    setState(() {
      _messages.insert(0, _message);
    });

    _controller.clear();

  }

  Widget _buildTextComposer(){
    return Row(
      children: [
        Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted: (value) => sendMessage(),
              decoration: InputDecoration.collapsed(hintText: "Enter a message to send"),
            ),
        ),
        IconButton(
            onPressed: (){
              sendMessage();
            },
            icon: Icon(
              Icons.send,
            ),
        ),
      ],
    ).p16();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat GPT App".toUpperCase()),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.green[800],
        titleTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            //push to the bottom
            Flexible(
              child: ListView.builder(
                reverse: true,
                  padding: Vx.m8,
                  itemCount: _messages.length,
                  itemBuilder: (context, index){
                    return  _messages[index];
      })
            ),
            Container(
              decoration: BoxDecoration(
                color: context.cardColor
              ),
              child: _buildTextComposer(),
            )
          ],
        ),
      ),
    );
  }
}
