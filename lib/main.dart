import 'package:flutter/material.dart';
import 'package:spurr/sdk.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    var partnerId = "bb6dd223-c043-11ee-80aa-42010a67a10d";
    var partnerKey = "32158ebf-dd61-11ee-9ef9-42010a67a110";
    var spurr = new SDK(partnerId, partnerKey);

    spurr.listLoyalty({})
        .then((response) {
            print('listLoyalty:response');
            print(response);
        })
        .catchError((error) {
            print('listLoyalty:error');
            print(error);
        });

    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}