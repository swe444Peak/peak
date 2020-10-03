import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationManager {
  var flutterLocalNotificationsPlugin;
  DateTime goalDeadline;

  
 
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
   print ('Notification Selected');
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




  void showTaskNotification(  String title, String body, String taskType) async {
  
  
   Duration sinceDeadline = goalDeadline.difference(DateTime.now());
   int indays = sinceDeadline.inDays;
   switch(taskType){

   case 'Daily':
   var addDay=1;
   for(var i=1; i<=indays;i++ ){
    DateTime timeDaily = DateTime.utc(DateTime.now().year,DateTime.now().month,DateTime.now().day+addDay++);
  await flutterLocalNotificationsPlugin.schedule(
         title, body, timeDaily, getPlatformChannelSpecfics());
   }
   break;

   case 'Weekly':
    var inWeeks = indays/7;
    var addWeek=7; 

   for (var i=1  ;i <= inWeeks ;i++ ){
   DateTime timeweekly = DateTime.utc(DateTime.now().year,DateTime.now().month,DateTime.now().day+addWeek);
   addWeek=addWeek+7;
  await flutterLocalNotificationsPlugin.schedule( title, body ,timeweekly , getPlatformChannelSpecfics());
   }

   break;
   case 'Monthly': 
   var inMonths =  indays/30;
   var addMoth=1; 

   for (var i=1  ;i <= inMonths ;i++ ){
   DateTime timeweekly = DateTime.utc(DateTime.now().year,DateTime.now().month+addMoth,DateTime.now().day);
   addMoth++;
  await flutterLocalNotificationsPlugin.schedule( title, body ,timeweekly , getPlatformChannelSpecfics());
   }
   break;
   default:
    print('Somthing went WRONG');
   }
    
    print('Notification Succesfully Scheduled at the Selected time');
  }




  void showDeadlineNotification( String title , String body, DateTime slectedTime ) async {
  goalDeadline=slectedTime;
  var day= slectedTime.day-1;
  var month = slectedTime.month;
  var year =slectedTime.year;
 
  DateTime time = DateTime.utc(year,month,day);
  await flutterLocalNotificationsPlugin.schedule( title, body ,time , getPlatformChannelSpecfics());
  }



 
  //turn off notification by id
  Future<void> removeReminder() async {
  await  flutterLocalNotificationsPlugin.cancelAll();
  }

}