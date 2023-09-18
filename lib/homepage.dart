import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
      AwesomeNotifications().createNotification(
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
              onTap: () async {
                String? token = await FirebaseMessaging.instance.getToken();
                print(token);
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
                sendPushNotification();
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
  Future<void> sendPushNotification() async {
    try {
      http.Response response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'key=AAAArlCJ4T0:APA91bE662FBMa7kP-DyYwOxmqMLFDHkmSjcDOF0AFbevXHRUJBxCKoLczx15DZnieGW3YwfoSig-iprTHfBiTdaNCIAuhSAbnoUqsNSjs5N22C_RRHLiJC1xXqZBC6V610ngwUUWkzk',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': "Din",
              'title': 'Incoming Call',
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            'to': "cyq6v-jPQ-efi1_f7lGtqC:APA91bF0GmvQXFVx8ju10gW0l9UGGC6XgNnrTYqYv2g_8oB4Ii5fbEEp9k85ZIPuYs6hl2LiII5u0nB7EDouFDbtwrqw6Hyi3sbIWxlzHi4x8QI419RFmGtgApYgAB3ff7QcEUrDJyLW",
          },
        ),
      );
      response;
    } catch (e) {
      e;
    }
  }
}
