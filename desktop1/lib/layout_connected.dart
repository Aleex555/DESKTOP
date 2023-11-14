import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_data.dart';
import 'package:intl/intl.dart';

class LayoutConnected extends StatefulWidget {
  const LayoutConnected({Key? key}) : super(key: key);

  @override
  State<LayoutConnected> createState() => _LayoutConnectedState();
}

class _LayoutConnectedState extends State<LayoutConnected> {
  final _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();
  DateTime dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Display Crazy"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 52),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    child: TextField(
                      controller: _messageController,
                      focusNode: _messageFocusNode,
                      decoration: InputDecoration(
                        hintText: "Escribe tu mensaje ...",
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        filled: true,
                        fillColor: const Color.fromRGBO(240, 240, 240, 1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 140,
            height: 32,
            child: ElevatedButton(
              onPressed: () async {
                final message2 = {
                  'fecha': DateFormat('HH:mm dd-MM-yyyy').format(dateTime),
                  'mensaje': _messageController.text
                };

                appData.broadcastMessage(_messageController.text);
                _messageController.text = "";
                FocusScope.of(context).requestFocus(_messageFocusNode);
              },
              child: const Text(
                "Enviar",
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 140,
            height: 32,
            child: ElevatedButton(
              onPressed: () {
                appData.disconnectFromServer();
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              child: const Text(
                "Disconnect",
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
