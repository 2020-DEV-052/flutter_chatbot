import 'package:flutter/material.dart';
import 'package:flutter_app/widget/message.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';

void main() => runApp(ChatBot());

class ChatBot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatBot flow flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatBotFlow(title: 'ChatBotFlow Home Page'),
    );
  }
}

class ChatBotFlow extends StatefulWidget {
  ChatBotFlow({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() => _ChatBotFlowState();
}

class _ChatBotFlowState extends State<ChatBotFlow> {
  final List<Message> _messages = <Message>[];

  final TextEditingController _textController = new TextEditingController();

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration:
                    new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                  icon: new Icon(Icons.send),
                  onPressed: () => _handleSubmitted(_textController.text)),
            ),
          ],
        ),
      ),
    );
  }

  void _insertQuickReply(String reply) {
    _handleSubmitted(reply);
  }

  void Response(query) async {
    _textController.clear();
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/new_chatbot.json").build();
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: Language.english);
    AIResponse response = await dialogflow.detectIntent(query);
    if (response != null && response.getListMessage() != null) {
      if (response.getListMessage().length > 1) {
        var payload = response.getListMessage()[1]['payload'];

        if (payload != null) {
          QuickReplies replies = new QuickReplies(payload);
          _showMessage(MessageType.QUICK_REPLY, replies.quickReplies, replies.title,
              null, null, _insertQuickReply);
        } else {
          _showMessage(
              MessageType.CHAT_MESSAGE,
              null,
              response.getMessage() ??
                  new CardDialogflow(response.getListMessage()[0]).title,
              false,
              "Bot",
              null);
        }
      } else {
        _showMessage(
            MessageType.CHAT_MESSAGE,
            null,
            response.getMessage() ??
                new CardDialogflow(response.getListMessage()[0]).title,
            false,
            "Bot",
            null);
      }
    }
  }

  void _showMessage(MessageType type, List<String> replies, String messageText,
      bool messageType, String messageName, Function insertQuickReply) {
    Message message = new Message(
      messageType: type,
      quickReplies: replies,
      text: messageText,
      name: messageName,
      type: messageType,
      updateQuickReply: insertQuickReply,
    );
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    _showMessage(MessageType.CHAT_MESSAGE, null, text, true, "Promise", null);
    Response(text);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("Flutter and Dialogflow"),
      ),
      body: new Column(children: <Widget>[
        new Flexible(
            child: new ListView.builder(
          padding: new EdgeInsets.all(8.0),
          reverse: true,
          itemBuilder: (_, int index) => _messages[index],
          itemCount: _messages.length,
        )),
        new Divider(height: 1.0),
        new Container(
          decoration: new BoxDecoration(color: Theme.of(context).cardColor),
          child: _buildTextComposer(),
        ),
      ]),
    );
  }
}
