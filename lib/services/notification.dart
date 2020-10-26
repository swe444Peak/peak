import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:peak/enums/taskType.dart';

class NotificationManager {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  DateTime goalDeadline = new DateTime(2020);
  int countNoti = 0;

  NotificationManager() {
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
    print('Notification Selected');
  }

  getPlatformChannelSpecfics() {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      'your channel description',
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    return platformChannelSpecifics;
  }

  Future<void> showNotificationOnce(
      String title, String body, DateTime date) async {
    //  DateTime date2 = date.add(Duration(hours:12));
       DateTime timeMonthly = DateTime.utc(date.year,date.month,date.day,8);
    await flutterLocalNotificationsPlugin.schedule(
        countNoti++, title, body, timeMonthly, getPlatformChannelSpecfics());
  }

  Future<void> showDailyNotification(
      String title, String body, DateTime deadline) async {
    Duration sinceDeadline = deadline.difference(DateTime.now());
    int indays = sinceDeadline.inDays+2;
    var incMins = 30;
    var addDay = 1;
    for (var i = 1; i <= indays; i++) {
     // DateTime timeDaily = DateTime.now().add(Duration(days: addDay++)).add(Duration(hours: 11));
       DateTime timeDaily = DateTime.utc(DateTime.now().year,DateTime.now().month,DateTime.now().day+addDay++,8);
       print(timeDaily);
      await flutterLocalNotificationsPlugin.schedule(
          countNoti++, title, body, timeDaily, getPlatformChannelSpecfics());
    }
  }

  void showNotification(String title, String body) async {
    DateTime now = DateTime.now().add(Duration(seconds: 12));
    await flutterLocalNotificationsPlugin.schedule(
        countNoti++, title, body, now, getPlatformChannelSpecfics());
  }

  void showTaskNotification(
      String title, String body, List<DateTime> dates) async {
    var incHour = 0;
    for (var item in dates) {
      await flutterLocalNotificationsPlugin.schedule(countNoti++, title, body,
          item.add(Duration(hours: 8)), getPlatformChannelSpecfics());
      incHour = incHour + 60;
    }

    print('Notification Succesfully Scheduled at the Selected time');
  }

  void showDeadlineNotification(
      String title, String body, DateTime slectedTime) async {
    await flutterLocalNotificationsPlugin.schedule(countNoti++, title, body,
        slectedTime.subtract(Duration(days: 1)).add(Duration(hours: 8)), getPlatformChannelSpecfics());
  }

  Future<void> removeReminder() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
