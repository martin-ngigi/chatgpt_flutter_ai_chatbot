import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage(
      {super.key,
      required this.text,
      required this.sender,
      this.isImage = false});

  final String text;
  final String sender;
  final bool isImage;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 带有文本的容器,它的子元素是一个 Text 组件，其中 sender 是一个变量，代表发送者的身份。
        // Text 组件通过链式调用一系列方法来设置样式和外观，包括 subtitle1()、make()、box、color()、p16、rounded 和 alignCenter。
        Text(sender)
            .text
            .subtitle1(context)
            .make()
            .box
            // 根据 sender 的值，容器的背景颜色会是 Vx.red200 或 Vx.green200。表示是用户消息或者ChatGPT消息。
            .color(sender == "user" ? Vx.red200 : Vx.green200)
            .p16
            .rounded
            .alignCenter
            .makeCentered(),
        Expanded(
          // 第二个子元素是一个图片或文本。这个子元素的具体内容取决于isImage的变量。
          child: isImage
              // 如果 isImage 为真，则这个子元素是一个带有图片的容器，其宽高比是 16:9。图片的 URL 存储在 text 变量中，使用 Image.network 构建。
              ? AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    text,
                    loadingBuilder: (context, child, loadingProgress) =>
                        loadingProgress == null
                            ? child
                            : const CircularProgressIndicator.adaptive(),
                  ),
                )
              // 如果 isImage 为假，则这个子元素是一个文本容器，其中的文本存储在 text 变量中。这个文本会被修剪(trim)，并通过链式调用一系列方法来设置样式和外观
              : text.trim().text.bodyText1(context).make().px8(),
        ),
      ],
    ).py8();
  }
}
