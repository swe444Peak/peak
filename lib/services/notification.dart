import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationManager {
  var flutterLocalNotificationsPlugin;


  NotificationManager() {
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    initalizNotifications();
  }



 // initiate Notification setting 
  void initalizNotifications() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

   Future onSelectNotification(String payload) async {
  
   //Navigator.pushNamed(context, 'home');
  }


   getPlatformChannelSpecfics() {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max,
        priority: Priority.High,);

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    return platformChannelSpecifics;
  }


  void showNotificationDaily(  int id, String title, String body) async {
    var time =  new Time(9,0,0);
    flutterLocalNotificationsPlugin.showDailyAtTime(
        id, title, body, time, getPlatformChannelSpecfics());
    print('Notification Succesfully Scheduled at the Selected time');
  }


  void showDeadlineNotification(int id , String title , String body, Time slectedTime ){
  
  var time = slectedTime;

    flutterLocalNotificationsPlugin.schedule(id, title, body ,time , getPlatformChannelSpecfics());
  }

 
  //turn off notification by id
  void removeReminder(int id) {
    flutterLocalNotificationsPlugin.cancel(id);
  }

}