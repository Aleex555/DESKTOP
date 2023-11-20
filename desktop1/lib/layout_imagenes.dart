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

  @override
  Widget build(BuildContext context) {
    appData = Provider.of<AppData>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enviar Imágenes"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Agregamos el ListView horizontal
          Container(
            height: 100.0,
            child: _buildImageListView(),
          ),
          // Puedes agregar más contenido aquí
        ],
      ),
      // Agregamos un botón "Volver" en la parte inferior
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
        return GestureDetector(
          onTap: () async {
            File imageFile = File(images[index].path);
            List<int> imageBytes = await imageFile.readAsBytes();
            String base64Image = base64Encode(imageBytes);
            appData.reenviar_img(base64Image);
          },
          child: Container(
            margin: EdgeInsets.all(8.0),
            width: 80.0,
            height: 80.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: FileImage(File(images[index].path)),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}
