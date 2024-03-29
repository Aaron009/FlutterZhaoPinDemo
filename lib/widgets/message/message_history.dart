import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_boss/common/config/config.dart';
import 'package:flutter_boss/model/message.dart';
import 'package:flutter_boss/widgets/message/message_receive_item.dart';
import 'package:flutter_boss/widgets/message/message_send_item.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MessageHistoryPage extends StatefulWidget {
  final Message message;

  MessageHistoryPage({Key key, @required this.message}) : super(key: key);

  @override
  _MessageHistoryPageState createState() => _MessageHistoryPageState();
}

class _MessageHistoryPageState extends State<MessageHistoryPage> {
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  WebSocketChannel channel =
      IOWebSocketChannel.connect('ws://echo.websocket.org');

  List<Message> _msgList = List();
  Timer _timer;

  void _addMessage(Message msg) {
    _msgList.add(msg);
    _scrollEnd();
  }

  void _scrollEnd() {
//    Future.delayed(Duration(milliseconds: 2000), () {
//      print("当前消息数量 " +  _msgList.length.toString());
//      _scrollController.animateTo(
//          (_msgList.length + 1 / _msgList.length) *
//              _scrollController.position.maxScrollExtent,
//          duration: const Duration(milliseconds: 300),
//          curve: Curves.easeOut);
//    });
    if(_timer != null) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: 17), () {
      print("当前消息数量 " +  _msgList.length.toString());
      _scrollController.animateTo(
          (_msgList.length + 1 / _msgList.length) *
              _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut);
    });
  }


  @override
  void initState() {
    super.initState();
    channel.stream.listen((msgString) {
      Message msg = Message.fromJson(jsonDecode(msgString));
      msg.type = 'receive';
      setState(() => _addMessage(msg));
    });

    Message msg = widget.message;
    msg.type = 'receive';
    _addMessage(msg);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          widget.message.name,
          style: new TextStyle(fontSize: 20.0, color: Colors.white),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          // 收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          // color: Colors.grey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                fit: FlexFit.tight,
                child: new ListView.builder(
                    controller: _scrollController,
                    itemCount: _msgList.length, // 数据长度
                    itemBuilder: (context, index) => _makeMessageElement(index)),
              ),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          autofocus: true,
                          decoration: new InputDecoration(
                            hintText: '发送一条消息',
                          ),
                          onTap: _scrollEnd,
                        ),
                      ),
                      RaisedButton(
                        color: Config.GLOBAL_COLOR,
                        child: Text(
                          '发送',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: _sendMessage,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ), //          child: Row(
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      final Message msg = Message()
        ..name = widget.message.name
        ..head = widget.message.head
        ..message = _controller.text
        ..type = 'send';

//      setState(() => _msgList.add(msg));
      _msgList.add(msg);
      channel.sink.add(jsonEncode(msg.toJson()));
      _controller.text = "";
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  Widget _makeMessageElement(index) {
    if (index >= _msgList.length) {
      return null;
    }
    Message msg = _msgList[index];
    if (msg.type == 'send') {
      return MessageSendItem(message: msg);
    } else if (msg.type == 'receive') {
      return MessageReceiveItem(message: msg);
    }
  }
}
