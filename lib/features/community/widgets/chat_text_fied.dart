
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatTextFieldBar extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onMic;
  final bool isListening;
  const ChatTextFieldBar({
    Key? key,
    required this.controller,
    required this.onSend,
    required this.onMic,
    required this.isListening,
  }) : super(key: key);

  @override
  State<ChatTextFieldBar> createState() => _ChatTextFieldBarState();
}

class _ChatTextFieldBarState extends State<ChatTextFieldBar> {
  @override
  Widget build(BuildContext context) {
    bool showSendButton = widget.controller.text.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(left: 15),
          ),
          IconButton(
            onPressed: widget.onMic,
            icon: Icon(widget.isListening ? Icons.stop : Icons.mic),
          ),
          Expanded(
            child: TextFormField(
              controller: widget.controller,
              onChanged: (val) {
                setState(() {
                  showSendButton = val.trim().isNotEmpty;
                });
              },
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintText: 'Enter Message',
                border: InputBorder.none,
              ),
            ),
          ),
          if (showSendButton)
            IconButton(
              onPressed: () {
                widget.onSend();
              },
              icon: const Icon(
                Icons.send,
              ),
            ),
        ],
      ),
    );
  }
}
