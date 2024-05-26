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

    // // spurr.setData('user03@yopmail.com', '+62811222003', 'ID', 'User', '03');
    // spurr.setData('m.jumari@gmail.com', '+62811269110', 'ID', 'Kazao', 'TM');

    // spurr.loyaltyAvailable({}).then((response) {
    //   print('loyaltyAvailable:response');
    //   if (response != null) {
    //     for (var data in response['data']) {
    //       print(data);
    //     }
    //   }
    // }).catchError((error) {
    //   print('loyaltyAvailable:error');
    //   print(error);
    // });

    // spurr.loyaltyList({}).then((response) {
    //   print('listLoyalty:response');
    //   if (response != null) {
    //     for (var data in response['data']) {
    //       print(data);
    //     }
    //   }
    // }).catchError((error) {
    //   print('listLoyalty:error');
    //   print(error);
    // });

    // spurr.loyaltyQrcode(
    //     {'loyaltyId': 'a11c4341-0dec-4195-a1c0-f51d210af30e'}).then((response) {
    //   print('loyaltyQrcode:response');
    //   print(response);
    //   spurr.qrcodeStatus(response['qrcodesId']).then((response) {
    //     print('qrcodeStatus:response');
    //     print(response);
    //   }).catchError((error) {
    //     print('qrcodeStatus:error');
    //     print(error);
    //   });
    // }).catchError((error) {
    //   print('loyaltyQrcode:error');
    //   print(error);
    // });

    // spurr.campaignList({}).then((response) {
    //   print('campaignList:response');
    //   // print(response);
    //   if (response != null) {
    //     for (var data in response['data']) {
    //       print(data);
    //     }
    //   }
    // }).catchError((error) {
    //   print('campaignList:error');
    //   print(error);
    // });

    // spurr.campaignQrcode({
    //   'promotionId': 'f628a457-190a-11ef-9ef9-42010a67a110'
    // }).then((response) {
    //   print('campaignQrcode:response');
    //   print(response);
    //   spurr.qrcodeStatus(response['qrcodesId']).then((response) {
    //     print('qrcodeStatus:response');
    //     print(response);
    //   }).catchError((error) {
    //     print('qrcodeStatus:error');
    //     print(error);
    //   });
    // }).catchError((error) {
    //   print('campaignQrcode:error');
    //   print(error);
    // });

    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
