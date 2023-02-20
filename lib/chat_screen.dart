import 'dart:async';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import 'chat_message.dart';
import 'threedots.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // 创建了一个名为_controller的TextEditingController对象，用于控制用户输入框的文本内容
  final TextEditingController _controller = TextEditingController();
  // 创建了一个名为_messages的空列表，用于保存聊天机器人和用户之间的对话记录。
  final List<ChatMessage> _messages = [];
  // 创建了一个名为chatGPT的可选的ChatGPT对象，用于与聊天机器人进行交互。
  ChatGPT? chatGPT;

  // 创建了一个可选的StreamSubscription对象，用于管理聊天机器人的消息流。
  StreamSubscription? _subscription;
  // 创建了一个布尔变量_isTyping，用于指示用户是否正在输入。
  bool _isTyping = false;

  @override
  // 定义了一个初始化方法，当这个State对象第一次被创建时会自动调用。在这个方法中，我们调用了ChatGPT.instance方法来获取一个ChatGPT对象并将其赋值给chatGPT变量。
  void initState() {
    super.initState();
    chatGPT = ChatGPT.instance;
  }

  @override
  // 定义了一个销毁方法，当这个State对象不再被使用时会自动调用。在这个方法中，我们使用_subscription?.cancel()取消了订阅聊天机器人的消息流。
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  // Link for api - https://beta.openai.com/account/api-keys

  void _sendMessage() {
    // 检查用户输入的消息是否为空，如果为空则直接返回，不进行任何操作。
    if (_controller.text.isEmpty) return;
    // 创建一个 ChatMessage 对象，其中包含了用户输入的消息文本和发送者信息。
    ChatMessage message = ChatMessage(
      text: _controller.text,
      sender: "user",
    );

    // 使用 setState() 函数更新状态，将用户输入的消息添加到 _messages 列表的最前面，并将 _isTyping 设置为 true。
    setState(() {
      _messages.insert(0, message);
      _isTyping = true;
    });
    // 清空文本输入框 _controller 中的文本内容。
    _controller.clear();

    // 创建一个 CompleteReq 对象，其中包含了要翻译的文本、翻译模型和最大标记数。
    final request = CompleteReq(
        prompt: message.text, model: kTranslateModelV3, max_tokens: 200);

    // 使用 chatGPT 对象的 builder 方法创建一个 ChatGPT 对象，并使用 onCompleteStream 方法和 listen 函数订阅响应流。
    _subscription = chatGPT!
        .builder("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")
        .onCompleteStream(request: request)
        .listen((response) {
      //log message
      Vx.log(response!.choices[0].text);

      // 在收到响应后，将响应中的文本作为参数创建一个 ChatMessage 对象，其中包含了机器人回复的文本和发送者信息。
      ChatMessage botMessage =
          ChatMessage(text: response.choices[0].text, sender: "Sweet ChatBot");

      // 使用 setState() 函数更新状态，将机器人的回复添加到 _messages 列表的最前面。
      setState(() {
        _messages.insert(0, botMessage);
      });
    });
  }

  // 它返回一个 Widget，用于显示一个文本输入框和一个发送按钮。
  Widget _buildTextComposer() {
    return Row(
      children: [
        // 第一个子widget是一个 Expanded widget，包含一个 TextField，用于输入文本消息
        Expanded(
          child: TextField(
            // 在 TextField 中，controller 属性用于控制文本框中的值
            controller: _controller,
            // onSubmitted 属性用于在用户按下回车键时调用, _sendMessage 函数发送消息
            onSubmitted: (value) => _sendMessage(),
            // decoration 属性设置文本框的外观,包括提示文本 "Enter message here"。
            decoration:
                const InputDecoration.collapsed(hintText: "Enter message here"),
          ),
        ),
        // 是一个 ButtonBar，包含一个 IconButton，用于发送消息
        ButtonBar(
          children: [
            // IconButton 显示一个发送图标，当用户点击时，它调用 _sendMessage 函数发送消息。
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                _sendMessage();
              },
            ),
          ],
        ),
      ],
      //代码调用 px16() 方法对 Row 进行修饰，添加了一个 16 的像素边距。 px16() 方法可能是一个自定义的方法或者是从某个库中导入的扩展方法，用于在代码中方便地设置 widget 的样式。
    ).px16();
  }

  @override
  Widget build(BuildContext context) {
    // 使用了Scaffold Widget来创建一个基本的UI骨架，其中包含一个AppBar（用于显示应用程序的标题和一些操作按钮）和一个body（用于显示聊天界面的主要内容）。
    return Scaffold(
        appBar: AppBar(
          // title：显示应用程序的标题，其中的文本为"ChatGPT APP"。
          title: Text(
            "ChatGPT APP",
          ),
          // centerTitle：指定标题是否应该水平居中对齐。
          centerTitle: true,
          // backgroundColor：指定AppBar的背景颜色为绿色。
          backgroundColor: Colors.green,
          // titleTextStyle：指定标题文本的样式，其中文本颜色为白色、字体大小为20、字体加粗。
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        // body部分是一个SafeArea Widget，其中包含一个Column Widget，它又包含了以下几个子Widget：
        body: SafeArea(
          child: Column(
            children: [
              // Flexible：用于包裹ListView.builder，可以确保在列的底部留有足够的空间，使得聊天消息可以滚动显示。
              Flexible(
                  child: ListView.builder(
                reverse: true,
                padding: Vx.m8,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _messages[index];
                },
              )),
              // ThreeDots：如果正在输入，则显示三个点，表示用户正在输入。
              if (_isTyping) const ThreeDots(),
              // Divider：用于将消息列表和文本输入框分隔开来。
              const Divider(
                height: 1.0,
              ),
              // Container：包裹了_buildTextComposer()方法所返回的Widget，用于创建并显示文本输入框。在Container中，指定了它的装饰属性（背景颜色等），这些属性将从上下文中获取（context.cardColor）。
              Container(
                decoration: BoxDecoration(
                  color: context.cardColor,
                ),
                child: _buildTextComposer(),
              )
            ],
          ),
        ));
  }
}
