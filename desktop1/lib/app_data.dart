import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:web_socket_channel/io.dart';

enum ConnectionStatus { disconnected, registro, connected, imagenes }

class AppData with ChangeNotifier {
  String ip = "localhost";
  String port = "8888";

  IOWebSocketChannel? _socketClient;
  ConnectionStatus connectionStatus = ConnectionStatus.disconnected;

  String? mySocketId;
  List<String> clients = [];
  bool regitrado = false;

  bool file_saving = false;
  bool file_loading = false;

  AppData() {
    _getLocalIpAddress();
  }

  void _getLocalIpAddress() async {
    try {
      final List<NetworkInterface> interfaces = await NetworkInterface.list(
          type: InternetAddressType.IPv4, includeLoopback: false);
      if (interfaces.isNotEmpty) {
        final NetworkInterface interface = interfaces.first;
        final InternetAddress address = interface.addresses.first;
        ip = address.address;
        notifyListeners();
      }
    } catch (e) {
      print("Can't get local IP address : $e");
    }
  }

  void connectToServer() async {
    notifyListeners();

    // Simulate connection delay
    await Future.delayed(const Duration(seconds: 1));

    _socketClient = IOWebSocketChannel.connect("ws://$ip:$port");

    _socketClient!.stream.listen(
      (message) {
        final data = jsonDecode(message);

        switch (data['type']) {
          case 'ok':
            connectionStatus = ConnectionStatus.connected;
          case 'img':
            connectionStatus = ConnectionStatus.imagenes;
          case 'list':
            clients = (data['list'] as List).map((e) => e.toString()).toList();
            clients.remove(mySocketId);
            break;
          case 'id':
            mySocketId = data['value'];
            break;
          case 'connected':
            clients.add(data['id']);
            break;
          case 'disconnected':
            clients.remove(data['id']);
            break;
        }

        notifyListeners();
      },
      onError: (error) {
        connectionStatus = ConnectionStatus.disconnected;
        mySocketId = "";
        clients = [];
        notifyListeners();
      },
      onDone: () {
        connectionStatus = ConnectionStatus.disconnected;
        mySocketId = "";
        clients = [];
        notifyListeners();
      },
    );
  }

  disconnectFromServer() async {
    notifyListeners();

    // Simulate connection delay
    await Future.delayed(const Duration(seconds: 1));

    _socketClient!.sink.close();
  }

  refreshClientsList() {
    final message = {
      'type': 'list',
    };
    _socketClient!.sink.add(jsonEncode(message));
  }

  broadcastMessage(String msg) {
    final message = {
      'type': 'broadcast',
      'from': 'Flutter',
      'value': msg,
    };
    _socketClient!.sink.add(jsonEncode(message));
  }

  registro(String usu, String contra) {
    final message = {
      'type': 'registro',
      'user': usu,
      'password': contra,
    };
    _socketClient!.sink.add(jsonEncode(message));
  }

  galeria_img() {
    final message = {
      'type': 'galeria',
    };
    _socketClient!.sink.add(jsonEncode(message));
  }

  volver_connected() {
    final message = {
      'type': 'connected',
    };
    _socketClient!.sink.add(jsonEncode(message));
  }

  Future<void> saveFile(String fileName, Map<String, dynamic> data) async {
    file_saving = true;
    notifyListeners();

    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');
      final jsonData = jsonEncode(data);
      await file.writeAsString(jsonData);
    } catch (e) {
      print("Error saving file: $e");
    } finally {
      file_saving = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>?> readFile(String fileName) async {
    file_loading = true;
    notifyListeners();

    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');
      if (await file.exists()) {
        final jsonData = await file.readAsString();
        final data = jsonDecode(jsonData) as Map<String, dynamic>;
        return data;
      } else {
        print("File does not exist!");
        return null;
      }
    } catch (e) {
      print("Error reading file: $e");
      return null;
    } finally {
      file_loading = false;
      notifyListeners();
    }
  }

  createGalleryFolder() async {
    final directory = Directory('./galeria_img');

    if (!(await directory.exists())) {
      await directory.create(recursive: true);
    }
  }

  pickImage() async {
    await createGalleryFolder();
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      throw Exception('No se seleccionó ninguna imagen.');
    }

    List<int> bytes = await pickedFile.readAsBytes();

    String base64String = base64Encode(bytes);
    final String destinationImagePath =
        './galeria_img/' + pickedFile.path.split('/').last;

    final File destinationFile = File(destinationImagePath);
    await destinationFile.writeAsBytes(bytes);

    final message1 = {
      'type': 'image',
      'value': base64String,
      'name': pickedFile.path.split('/').last,
    };
    _socketClient!.sink.add(jsonEncode(message1));
  }

  reenviar_img(String base64string) {
    final message1 = {
      'type': 'image',
      'value': base64string,
      'name': "",
    };
    _socketClient!.sink.add(jsonEncode(message1));
  }
}
