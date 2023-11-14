import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_data.dart';

class LayoutDisconnected extends StatefulWidget {
  const LayoutDisconnected({Key? key}) : super(key: key);

  @override
  State<LayoutDisconnected> createState() => _LayoutDisconnectedState();
}

class _LayoutDisconnectedState extends State<LayoutDisconnected> {
  final _ipController = TextEditingController();

  Widget _buildTextFormField(
    String label,
    String defaultValue,
    TextEditingController controller,
  ) {
    controller.text = defaultValue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w200),
        ),
        Container(
          constraints: const BoxConstraints(maxWidth: 200),
          child: TextField(controller: controller),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);

    _ipController.text = appData.ip;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Display Crazy"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const SizedBox(height: 50),
            _buildTextFormField("Server IP", appData.ip, _ipController),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 96,
                  height: 32,
                  child: ElevatedButton(
                    onPressed: () {
                      appData.ip = _ipController.text;
                      appData.connectToServer();
                    },
                    child: const Text(
                      "Connect",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
