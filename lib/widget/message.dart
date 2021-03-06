import 'package:flutter/material.dart';
import 'package:flutter_app/widget/chat_message.dart';
import 'package:flutter_app/widget/quick_reply.dart';

class Message extends StatelessWidget {
  final String text;
  final List<String> quickReplies;
  final MessageType messageType;
  final String name;
  final bool type;
  final Function updateQuickReply;

  Message(
      {this.messageType,
      this.text,
      this.name,
      this.type,
      this.quickReplies,
      this.updateQuickReply});

  @override
  Widget build(BuildContext context) {
    if (messageType == MessageType.QUICK_REPLY) {
      return QuickReply(
        title: this.text,
        quickReplies: this.quickReplies,
        insertQuickReply: updateQuickReply,
      );
    }
    return ChatMessage(
      text: this.text,
      name: this.name,
      type: this.type,
    );
  }
}

enum MessageType { CHAT_MESSAGE, QUICK_REPLY }
