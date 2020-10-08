import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:peak/enums/taskType.dart';

class NotificationManager {
  var flutterLocalNotificationsPlugin;
  DateTime goalDeadline = new DateTime(2020);

  
 
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


 Future<void> showNotificationOnce(String title, String body,DateTime date ) async {
   await flutterLocalNotificationsPlugin.schedule(
         title, body, date, getPlatformChannelSpecfics());

 }
 Future<void> showDailyNotification(String title, String body ,DateTime deadline) async {
    Duration sinceDeadline = deadline.difference(DateTime.now());
   int indays = sinceDeadline.inDays;
   var incMins= 30;
   var hour =0;
   var min =0;
   var addDay=1;
   for(var i=1; i<=indays;i++ ){
    DateTime timeDaily = DateTime.utc(DateTime.now().year,DateTime.now().month,DateTime.now().day+addDay++,hour,min+incMins);
     incMins = incMins+30;
     await flutterLocalNotificationsPlugin.schedule(
         title, body, timeDaily, getPlatformChannelSpecfics());
 }}

  void showTaskNotification(  String title, String body, List<DateTime> dates) async {
    
    for (var item in dates) {
     await flutterLocalNotificationsPlugin.schedule( title, body ,item , getPlatformChannelSpecfics());
   }

    print('Notification Succesfully Scheduled at the Selected time');
  }
   /*Duration sinceDeadline = goalDeadline.difference(DateTime.now());
   int indays = sinceDeadline.inDays;
   var incMins= 30;
   var hour =0;
   var min =0;
   switch(taskType){
   case 'Weekly':
   for (var item in dates) {
     await flutterLocalNotificationsPlugin.schedule( title, body ,item , getPlatformChannelSpecfics());
   }
   

   // var inWeeks = indays/7;
   // var addWeek=7; 
    
   //for (var i=1  ;i <= inWeeks ;i++ ){
  // DateTime timeweekly = DateTime.utc(DateTime.now().year,DateTime.now().month,DateTime.now().day+addWeek,hour,min+incMins);
  // addWeek=addWeek+7;
   //incMins = incMins+30;
 // await flutterLocalNotificationsPlugin.schedule( title, body ,timeweekly , getPlatformChannelSpecfics());
  // }

   break;
   case 'Monthly': 

   for (var item in dates) {
     await flutterLocalNotificationsPlugin.schedule( title, body ,item , getPlatformChannelSpecfics());
   }

   //var inMonths =  indays/30;
   //var addMoth=1; 

   //for (var i=1  ;i <= inMonths ;i++ ){
   //DateTime timeweekly = DateTime.utc(DateTime.now().year,DateTime.now().month+addMoth,DateTime.now().day,hour,min+incMins);
   //addMoth++;
   //incMins = incMins+30;
 // await flutterLocalNotificationsPlugin.schedule( title, body ,timeweekly , getPlatformChannelSpecfics());
  // }
   break;
   default:
    print('Somthing went WRONG');
   }
    */
    
  



  void showDeadlineNotification( String title , String body, DateTime slectedTime ) async {
  goalDeadline = slectedTime;
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