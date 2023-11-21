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
    appData.ccontext = context;
    return Scaffold(
      appBar: AppBar(
        title: Text("Registro"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: 300,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              shrinkWrap: true,
              children: [
                const SizedBox(height: 50),
                _buildTextFormField("Usuario", _usuarioController,
                    onEditingComplete: _onEditingComplete),
                const SizedBox(height: 20),
                _buildTextFormField("Contraseña", _contrasenaController,
                    obscureText: true, onEditingComplete: _onEditingComplete),
                const SizedBox(height: 32),
                SizedBox(
                  width: 140,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: _onEnviarPressed,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                    ),
                    child: const Text(
                      "Enviar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(String label, TextEditingController controller,
      {bool obscureText = false, VoidCallback? onEditingComplete}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
      ),
      onEditingComplete: onEditingComplete,
    );
  }

  void _onEditingComplete() {
    _onEnviarPressed();
  }

  void _onEnviarPressed() {
    String usuario = _usuarioController.text;
    String contrasena = _contrasenaController.text;
    AppData appData = Provider.of<AppData>(context, listen: false);
    appData.registro(usuario, contrasena);
    _usuarioController.text = "";
    _contrasenaController.text = "";
  }
}
