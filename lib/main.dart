import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:spurr/sdk.dart';

void main() => runApp(Sample());

class Sample extends StatefulWidget {
  @override
  _Sample createState() => _Sample();
}

class _Sample extends State<Sample> {
  var campaigns = [], redeemed = [], loyalties = [];
  var partnerId = "bb6dd223-c043-11ee-80aa-42010a67a10d";
  var partnerKey = "0ea5a89c-2b57-11f0-8dd8-42010a67a115";
  var amount = 0.0;
  var pin = "";
  SDK? spurr;
  _Sample() {
    spurr = new SDK(partnerId, partnerKey);
    spurr?.setData('user91@yopmail.com', '+628110101001', 'ID', 'Kazao', 'TM');
    spurr?.setLatLon(0, 0);
    // spurr.fly();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadCampaign();
      loadLoyalty();
      loadRedeemed();
    });
  }

  void loadCampaign() {
    spurr?.campaignList({
      // 'keyword': 'Manis Caffe'
    }).then((response) {
      // print(response);
      if (response != null) {
        campaigns.clear();
        for (var data in response['data']) {
          setState(() {
            campaigns.add(data);
          });
        }
      }
      // print(campaign);
    }).catchError((error) {
      print(error);
    });
  }

  void loadRedeemed() {
    spurr?.campaignRedeemed({
      // 'keyword': 'Manis Caffe'
    }).then((response) {
      // print(response);
      if (response != null) {
        redeemed.clear();
        for (var data in response['data']) {
          setState(() {
            redeemed.add(data);
          });
        }
      }
      // print(campaign);
    }).catchError((error) {
      print(error);
    });
  }

  void loadLoyalty() {
    spurr?.loyaltyList({
      // 'keyword': 'Manis Caffe'
    }).then((response) {
      // print(response);
      if (response != null) {
        loyalties.clear();
        for (var data in response['data']) {
          setState(() {
            loyalties.add(data);
          });
        }
      }
      // print(response);
    }).catchError((error) {
      print(error);
    });
  }

  void showCampaign(context, data) {
    print(data['merchantFlags']['approvalMethod']);
    var promotionName = data['promotionName'];
    var merchantName = data['merchantName'];
    if (data['merchantFlags']['approvalMethod'] == "PIN") {
      AlertDialog dialog;
      print("Show Swipe and PIN");
      showDialog(
          context: context,
          builder: (context) {
            dialog = AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    20.0,
                  ),
                ),
              ),
              contentPadding: const EdgeInsets.only(
                top: 10.0,
              ),
              title: Text(
                '$promotionName by $merchantName',
                style: const TextStyle(fontSize: 24.0),
              ),
              content: Column(
                children: [
                  const Text("Amount"),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 2),
                    child: TextField(onChanged: (value) async {
                      amount = double.parse(value);
                    }),
                  ),
                  const Text("PIN"),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 2),
                    child: TextField(onChanged: (value) async {
                      pin = value;
                    }),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        print("issue");
                        spurr?.issue({
                          'type': 'promotion',
                          'amount': amount,
                          'pin': pin,
                          'promotionId': data['promotionId'],
                        }).then((response) {
                          //
                          print(response);
                        }).catchError((error) {
                          print(error);
                        });
                      },
                      child: const Text("Submit")),
                ],
              ),
            );
            return dialog;
          });
    } else {
      print("Show QR");
      var message = "Waiting approval!";
      // var color = Color.black;
      AlertDialog dialog;
      ImageProvider image = MemoryImage(
          base64Decode("R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw=="));
      spurr?.campaignQrcode({'promotionId': data['promotionId']}).then(
          (response) {
        if (response != null) {
          var qrcodesId = response['qrcodesId'];
          print(qrcodesId);
          setState(() {
            image = NetworkImage(
                'https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=$qrcodesId');
          });
          // var counter = 60;
          // countdown() {
          //   if (counter > 0) {
          //     setState(() {
          //       message = 'Waiting approval: $counter';
          //       counter--;
          //     });
          //     Future.delayed(Duration(seconds: 1), countdown);
          //   }
          // }
          // countdown();

          spurr?.qrcodeStatus(qrcodesId).then((response) {
            print(response);
            setState(() {
              message = "Redeemed successfully";
            });
            Future.delayed(Duration(seconds: 3), () {
              Navigator.pop(context);
            });
          }).catchError((error) {
            print(error);
            setState(() {
              message = "Timeout";
            });
            Future.delayed(Duration(seconds: 3), () {
              Navigator.pop(context);
            });
          });
        }
      });

      showDialog(
          context: context,
          builder: (context) {
            dialog = AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    20.0,
                  ),
                ),
              ),
              contentPadding: const EdgeInsets.only(
                top: 10.0,
              ),
              title: Text(
                '$promotionName by $merchantName',
                style: const TextStyle(fontSize: 24.0),
              ),
              content: Container(
                height: 400,
                decoration: BoxDecoration(
                  image: DecorationImage(image: image),
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    child: Text(message),
                    padding: EdgeInsets.all(10),
                  ),
                ),
              ),
            );
            return dialog;
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
            initialIndex: 0,
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                title: const Text("Spurr SDK"),
                bottom: const TabBar(tabs: <Widget>[
                  Tab(
                    icon: Icon(Icons.cloud_outlined),
                    text: "Campaign",
                  ),
                  Tab(
                    icon: Icon(Icons.cloud_outlined),
                    text: "Redeemed",
                  ),
                  Tab(
                    icon: Icon(Icons.cloud_outlined),
                    text: "Loyalty",
                  ),
                ]),
              ),
              body: TabBarView(
                children: <Widget>[
                  ListView.separated(
                    itemCount: campaigns.length,
                    itemBuilder: (BuildContext context, int index) {
                      var data = campaigns[index];
                      var merchantName = data['merchantName'];
                      return InkWell(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 160,
                                  height: 90,
                                  child: Image.network(data['promotionImage']),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(data['promotionName']),
                                    Text('By $merchantName')
                                  ],
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            print('tap $index');
                            showCampaign(context, data);
                          });
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider();
                    },
                  ),
                  ListView.separated(
                    itemCount: redeemed.length,
                    itemBuilder: (BuildContext context, int index) {
                      var data = redeemed[index];
                      var merchantName = data['merchantName'];
                      var redeemTimestamp = data['redeemTimestamp'];
                      return Container(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 160,
                              height: 90,
                              child: Image.network(data['promotionImage']),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(data['promotionName']),
                                Text('By $merchantName'),
                                Text('Timestamp $redeemTimestamp')
                              ],
                            )
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider();
                    },
                  ),
                  ListView.separated(
                    itemCount: loyalties.length,
                    itemBuilder: (BuildContext context, int index) {
                      var data = loyalties[index];
                      var merchantName = data['merchantName'];
                      var memberPointPoint = data['memberPointPoint'];
                      // print(data);
                      return Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(children: <Widget>[
                            Row(
                              children: <Widget>[
                                // Container(
                                //   width: 160,
                                //   height: 90,
                                //   child: Image.network(data['loyaltyImage']),
                                // ),
                                Column(
                                  children: <Widget>[
                                    Text(data['loyaltyName']),
                                    Text('By $merchantName')
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Text("Point"),
                                    Text('$memberPointPoint')
                                  ],
                                )
                              ],
                            )
                          ]));
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider();
                    },
                  ),
                ],
              ),
            )));
  }
}

// class TabBarApp extends StatelessWidget {
//   const TabBarApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     var partnerId = "bb6dd223-c043-11ee-80aa-42010a67a10d";
//     var partnerKey = "32158ebf-dd61-11ee-9ef9-42010a67a110";
//     var spurr = new SDK(partnerId, partnerKey);

//     // // spurr.setData('user03@yopmail.com', '+62811222003', 'ID', 'User', '03');
//     spurr.setData('m.jumari@gmail.com', '+62811269110', 'ID', 'Kazao', 'TM');

//     // spurr.setLatLon(0, 0);
//     spurr.campaignRedeemed({
//       // 'keyword': 'Manis Caffe'
//     }).then((response) {
//       print('campaignRedeemed:response');
//       // print(response);
//       if (response != null) {
//         for (var data in response['data']) {
//           print(data);
//         }
//       }
//     }).catchError((error) {
//       print('campaignList:error');
//       print(error);
//     });

//     return MaterialApp(
//       theme: ThemeData(useMaterial3: true),
//       home: new TabBarExample(spurr),
//     );
//   }
// }

// class TabBarExample extends StatelessWidget {
//   var campaigns = [];
//   final SDK spurr;
//   TabBarExample(this.spurr);

//   @override
//   Widget build(BuildContext context) {
//     print(spurr);
//     return DefaultTabController(
//       initialIndex: 1,
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Spurr SDK'),
//           bottom: const TabBar(
//             tabs: <Widget>[
//               Tab(
//                 icon: Icon(Icons.cloud_outlined),
//                 text: "Campaign",
//               ),
//               Tab(
//                 icon: Icon(Icons.beach_access_sharp),
//                 text: "Loyalty",
//               ),
//             ],
//           ),
//         ),
//         body: const TabBarView(
//           children: <Widget>[
//             ListView.separated(
//               itemCount: campaigns.count,
//               itemBuilder: (BuildContext context, int index) {

//                },
//                separatorBuilder: (BuildContext context, int index) { const Divider(color: Color.white,) },
//             ),
//             Center(
//               child: Text("Loyalty"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// void main() {
//   runApp(const MainApp());
// }

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     var partnerId = "bb6dd223-c043-11ee-80aa-42010a67a10d";
//     var partnerKey = "32158ebf-dd61-11ee-9ef9-42010a67a110";
//     var spurr = new SDK(partnerId, partnerKey);

//     // // spurr.setData('user03@yopmail.com', '+62811222003', 'ID', 'User', '03');
//     spurr.setData('m.jumari@gmail.com', '+62811269110', 'ID', 'Kazao', 'TM');

//     // spurr.setLatLon(0, 0);

//     // spurr.loyaltyAvailable({}).then((response) {
//     //   print('loyaltyAvailable:response');
//     //   if (response != null) {
//     //     for (var loyalty in response['data']) {
//     //       print(loyalty);
//     //     }
//     //   }
//     // }).catchError((error) {
//     //   print('loyaltyAvailable:error');
//     //   print(error);
//     // });

//     // spurr.loyaltyList({}).then((response) {
//     //   print('listLoyalty:response');
//     //   if (response != null) {
//     //     for (var data in response['data']) {
//     //       print(data);
//     //     }
//     //   }
//     // }).catchError((error) {
//     //   print('listLoyalty:error');
//     //   print(error);
//     // });

//     // spurr.loyaltyQrcode(
//     //     {'loyaltyId': 'a11c4341-0dec-4195-a1c0-f51d210af30e'}).then((response) {
//     //   print('loyaltyQrcode:response');
//     //   print(response);
//     //   spurr.qrcodeStatus(response['qrcodesId']).then((response) {
//     //     print('qrcodeStatus:response');
//     //     print(response);
//     //   }).catchError((error) {
//     //     print('qrcodeStatus:error');
//     //     print(error);
//     //   });
//     // }).catchError((error) {
//     //   print('loyaltyQrcode:error');
//     //   print(error);
//     // });

//     // spurr.campaignList({}).then((response) {
//     //   print('campaignList:response');
//     //   // print(response);
//     //   if (response != null) {
//     //     for (var data in response['data']) {
//     //       print(data);
//     //     }
//     //   }
//     // }).catchError((error) {
//     //   print('campaignList:error');
//     //   print(error);
//     // });

//     // spurr.campaignQrcode({
//     //   'promotionId': 'f628a457-190a-11ef-9ef9-42010a67a110'
//     // }).then((response) {
//     //   print('campaignQrcode:response');
//     //   print(response);
//     //   spurr.qrcodeStatus(response['qrcodesId']).then((response) {
//     //     print('qrcodeStatus:response');
//     //     print(response);
//     //   }).catchError((error) {
//     //     print('qrcodeStatus:error');
//     //     print(error);
//     //   });
//     // }).catchError((error) {
//     //   print('campaignQrcode:error');
//     //   print(error);
//     // });

//     return const MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: Text('Hello World!'),
//         ),
//       ),
//     );
//   }
// }
