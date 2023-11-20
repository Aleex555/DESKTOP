import 'package:desktop/app_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LayoutRegistro extends StatefulWidget {
  const LayoutRegistro({Key? key}) : super(key: key);

  @override
  _LayoutRegistroState createState() => _LayoutRegistroState();
}

class _LayoutRegistroState extends State<LayoutRegistro> {
  final _usuarioController = TextEditingController();
  final _contrasenaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Registro"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usuarioController,
              decoration: InputDecoration(
                labelText: 'Usuario',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contrasenaController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña',
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                String usuario = _usuarioController.text;
                String contrasena = _contrasenaController.text;
                appData.registro(usuario, contrasena);
                print('Usuario: $usuario');
                print('Contraseña: $contrasena');
              },
              child: Text("Enviar"),
            ),
          ],
        ),
      ),
    );
  }
}
