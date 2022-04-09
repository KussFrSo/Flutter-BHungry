import 'package:bhungry/models/users.dart';
import 'package:bhungry/resources/firebase_chats.dart';
import 'package:bhungry/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EnviarMesnaje extends StatefulWidget {
  final User user;

  const EnviarMesnaje({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  _EnviarMesnaje createState() => _EnviarMesnaje();
}

class _EnviarMesnaje extends State<EnviarMesnaje> {
  final _controller = TextEditingController();
  String message = '';

  void sendMessage() async {
    FocusScope.of(context).unfocus();

    await FirebaseChats.updateRestChats(widget.user);
    await FirebaseChats.uploadMessage(widget.user, message);

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(gradient: gradient),
        padding: EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _controller,
                textCapitalization: TextCapitalization.sentences,
                autocorrect: true,
                enableSuggestions: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  labelText: 'Mensaje...',
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(width: 0, color: Colors.white),
                    gapPadding: 10,
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onChanged: (value) => setState(() {
                  message = value;
                }),
              ),
            ),
            SizedBox(width: 20),
            GestureDetector(
              onTap: message.trim().isEmpty ? null : sendMessage,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                child: Icon(Icons.send, color: Colors.white),
              ),
            ),
          ],
        ),
      );
}
