import 'package:flutter/material.dart';

class ImageLayout extends StatefulWidget {
  const ImageLayout({Key? key}) : super(key: key);

  @override
  _ImageLayoutState createState() => _ImageLayoutState();
}

class _ImageLayoutState extends State<ImageLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enviar Imágenes"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                print('Seleccionar/Enviar Imágenes presionado');
              },
              child: Text('Seleccionar/Enviar Imágenes'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Lógica para "Galería"
                print('Galería presionada');
              },
              child: Text('Galería'),
            ),
          ],
        ),
      ),
    );
  }
}
