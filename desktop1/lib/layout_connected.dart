import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'app_data.dart';
import 'widget_selectable_list.dart';

class LayoutConnected extends StatefulWidget {
  const LayoutConnected({Key? key}) : super(key: key);

  @override
  State<LayoutConnected> createState() => _LayoutConnectedState();
}

class _LayoutConnectedState extends State<LayoutConnected> {
  final _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Display Crazy"),
      ),
      child: Column(
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
                    child: CupertinoTextField(
                      controller: _messageController,
                      focusNode: _messageFocusNode,
                      placeholder: "Escribe tu mensaje ...",
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      maxLines: 1,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(240, 240, 240, 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  color: const Color.fromRGBO(240, 240, 240, 1),
                  width: 142,
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: WidgetSelectableList(),
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
            child: CupertinoButton.filled(
              onPressed: () {
                final message = {
                  'id': appData.mySocketId,
                  'mensaje': _messageController.text
                };
                appData.saveFile('mensajes.json', message);
                appData.broadcastMessage(_messageController.text);
                _messageController.text = "";
                FocusScope.of(context).requestFocus(_messageFocusNode);
              },
              padding: EdgeInsets.zero,
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
            child: CupertinoButton(
              onPressed: () {
                appData.disconnectFromServer();
              },
              padding: EdgeInsets.zero,
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
