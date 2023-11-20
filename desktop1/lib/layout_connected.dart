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

  bool showMessages = false;
  List<Map<String, dynamic>> messages = [];

  bool _isSending = false;

  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Display Crazy'),
        backgroundColor: Colors.blue,
        centerTitle: true,
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
                      onEditingComplete: _onEnviarPressed,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 140,
                height: 32,
                child: ElevatedButton(
                  onPressed: _isSending ? null : _onEnviarPressed,
                  child: _isSending
                      ? CircularProgressIndicator()
                      : const Text(
                          "Enviar",
                          style: TextStyle(fontSize: 14),
                        ),
                ),
              ),
              const SizedBox(width: 8),
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
              const SizedBox(width: 8),
              SizedBox(
                width: 140,
                height: 32,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showMessages = !showMessages;
                      if (showMessages) {
                        loadMessages();
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text(
                    "Mostrar Mensajes",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 140,
                height: 32,
                child: ElevatedButton(
                  onPressed: () {
                    _showConfirmationDialog(() {
                      setState(() {
                        loadMessages();
                      });
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text(
                    "Refresh",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Botón Imágenes con Menú Emergente
              SizedBox(
                width: 140,
                height: 32,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  child: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'seleccionar_galeria') {
                        appData.pickImage();
                      } else if (value == 'tomar_foto') {
                        appData.galeria_img();
                        appData.createGalleryFolder();
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem<String>(
                        value: 'seleccionar_galeria',
                        child: ListTile(
                          leading: Icon(Icons.photo),
                          title: Text('Seleccionar de la galería'),
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'tomar_foto',
                        child: ListTile(
                          leading: Icon(Icons.camera),
                          title: Text('Galeria'),
                        ),
                      ),
                    ],
                    child: const Text(
                      "Imágenes",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ),
              // ... (Otros botones)
            ],
          ),
          if (showMessages)
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _showConfirmationDialog(() {
                        appData.broadcastMessage(messages[index]['mensaje']);
                        _messageController.text = "";
                        FocusScope.of(context).requestFocus(_messageFocusNode);
                      });
                    },
                    child: ListTile(
                      title: Text(messages[index]['mensaje']),
                      subtitle: Text(messages[index]['fecha']),
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  void _onEnviarPressed() async {
    AppData appData = Provider.of<AppData>(context, listen: false);
    if (_isSending) return;

    setState(() {
      _isSending = true;
    });

    final message2 = {
      'fecha': DateFormat('HH:mm dd-MM-yyyy').format(dateTime),
      'mensaje': _messageController.text
    };

    Map<String, dynamic>? data = await appData.readFile("mensajes.json");
    data ??= {};

    bool messageExists = data.values.any((value) =>
        value is Map<String, dynamic> &&
        value.containsKey('mensaje') &&
        value['mensaje'] == _messageController.text);

    if (!messageExists) {
      int nextIndex = 1;
      while (data.containsKey('nuevoMensaje$nextIndex')) {
        nextIndex++;
      }
      data['nuevoMensaje$nextIndex'] = message2;
      await appData.saveFile("mensajes.json", data);
    }

    appData.broadcastMessage(_messageController.text);
    _messageController.text = "";
    FocusScope.of(context).requestFocus(_messageFocusNode);

    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isSending = false;
    });
  }

  void loadMessages() async {
    AppData appData = Provider.of<AppData>(context, listen: false);

    Map<String, dynamic>? data = await appData.readFile("mensajes.json");
    data ??= {};

    List<Map<String, dynamic>> loadedMessages = [];
    data.forEach((key, value) {
      if (value is Map<String, dynamic> &&
          value.containsKey('mensaje') &&
          value.containsKey('fecha')) {
        loadedMessages.add(value);
      }
    });

    loadedMessages.sort((a, b) {
      DateTime dateA = DateFormat('HH:mm dd-MM-yyyy').parse(a['fecha']);
      DateTime dateB = DateFormat('HH:mm dd-MM-yyyy').parse(b['fecha']);
      return dateA.compareTo(dateB);
    });

    setState(() {
      messages = loadedMessages;
    });
  }

  Future<void> _showConfirmationDialog(Function onConfirm) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmación'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('¿Estás seguro de que quieres realizar esta acción?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}
