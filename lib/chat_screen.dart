import 'dart:async';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
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
  ChatGPT? chatGPT;

  StreamSubscription? _subscription;


  //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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatGPT = ChatGPT.instance;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  // Link for api - https://beta.openai.com/account/api-keys

  void sendMessage(){
    ChatMessage message = ChatMessage(text: _controller.text, sender: "user");

    setState(() {
      _messages.insert(0, message);
    });

    _controller.clear();

    final request = CompleteReq(prompt: message.text, model: kTranslateModelV3, max_tokens: 200);

    _subscription = chatGPT!
        .builder("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")
        .onCompleteStream(request: request)
        .listen((response) {
          //log message
          Vx.log(response!.choices[0].text);

          ChatMessage botMessage = ChatMessage(text: response.choices[0].text, sender: "Sweet ChatBot");

          setState(() {
            _messages.insert(0, botMessage);
          });
        });



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
