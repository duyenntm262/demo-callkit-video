import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  void initState(){
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      String? title = message.notification!.title;
      String? body = message.notification!.body;
      FAwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 123,
            channelKey: "call_channel",
            color: Colors.white,
            title: title,
            body: body,
            category: NotificationCategory.Call,
            wakeUpScreen: true,
            fullScreenIntent: true,
            autoDismissible: false,
            backgroundColor: Colors.orange,
          ),
          actionButtons: [
            NotificationActionButton(key: "ACCEPT", label: "Accept Call",
              color: Colors.green,
              autoDismissible: true,
            ),
            NotificationActionButton(key: "REJECT", label: "Reject Call",
              color: Colors.red,
              autoDismissible: true,
            ),
          ]
      );
      AwesomeNotifications().actionStream.listen((event) {
        if(event.buttonKeyPressed == "REJECT") {
          print("Call rejected");
        }
        else if(event.buttonKeyPressed == "ACCEPT") {
          print("Call Accepted");
        }
        else {
          print("Clicked on notification");
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HomePage"),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () {

              },
              child: Container(
                width: 100,
                height: 50,
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Colors.orangeAccent
                ),
                child: const Text("Get Token", textAlign: TextAlign.center,),
              ),
            ),
            InkWell(
              onTap: () {

              },
              child: Container(
                width: 100,
                height: 50,
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                    color: Colors.orangeAccent
                ),
                child: const Text("Send Push Notifications", textAlign: TextAlign.center,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
