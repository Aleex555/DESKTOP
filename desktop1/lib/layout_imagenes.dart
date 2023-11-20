import 'dart:convert';
import 'dart:io';

import 'package:desktop/app_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImageLayout extends StatefulWidget {
  const ImageLayout({Key? key}) : super(key: key);

  @override
  _ImageLayoutState createState() => _ImageLayoutState();
}

class _ImageLayoutState extends State<ImageLayout> {
  late AppData appData;
  late List<bool> isMouseOverList; // Lista de estados para cada imagen

  @override
  void initState() {
    super.initState();
    isMouseOverList = List.generate(
        10, (index) => false); // Ajusta el tamaño según tu cantidad de imágenes
  }

  @override
  Widget build(BuildContext context) {
    appData = Provider.of<AppData>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enviar Imágenes"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 200.0,
            child: _buildImageListView(),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50.0,
          child: ElevatedButton(
            onPressed: () {
              appData.volver_connected();
            },
            child: Text('Volver'),
          ),
        ),
      ),
    );
  }

  Widget _buildImageListView() {
    Directory galleryDir = Directory('galeria_img');

    List<FileSystemEntity> images = galleryDir.listSync();

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: images.length,
      itemBuilder: (context, index) {
        return Tooltip(
          message: 'Clic para enviar',
          child: MouseRegion(
            onEnter: (_) => _changeMouseOver(index, true),
            onExit: (_) => _changeMouseOver(index, false),
            child: AnimatedOpacity(
              opacity: isMouseOverList[index] ? 1.0 : 0.8,
              duration: Duration(milliseconds: 300),
              child: GestureDetector(
                onTap: () async {
                  bool confirm = await _showConfirmationDialog(context);
                  if (confirm) {
                    await _showLoadingScreen(context);
                    File imageFile = File(images[index].path);
                    List<int> imageBytes = await imageFile.readAsBytes();
                    String base64Image = base64Encode(imageBytes);
                    appData.reenviar_img(base64Image);
                  }
                },
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: FileImage(File(images[index].path)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return (await showDialog<bool?>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("¿Seguro que quieres enviar la foto?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text("Cancelar"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text("Aceptar"),
                ),
              ],
            );
          },
        )) ??
        false;
  }

  Future<void> _showLoadingScreen(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16.0),
              Text("Enviando foto..."),
            ],
          ),
        );
      },
    );

    await Future.delayed(Duration(seconds: 5));

    Navigator.of(context).pop();
  }

  void _changeMouseOver(int index, bool value) {
    setState(() {
      isMouseOverList[index] = value;
    });
  }
}
