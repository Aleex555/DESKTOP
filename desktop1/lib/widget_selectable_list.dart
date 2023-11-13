import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'app_data.dart';

class WidgetSelectableList extends StatefulWidget {
  const WidgetSelectableList({super.key});

  @override
  WidgetSelectableListState createState() => WidgetSelectableListState();
}

class WidgetSelectableListState extends State<WidgetSelectableList> {
  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);
    return ListView.builder(
      itemCount: appData.clients.length,
      itemBuilder: (context, index) {
        final client = appData.clients[index];
        return Container(
          child: Text(
            client,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        );
      },
    );
  }
}
