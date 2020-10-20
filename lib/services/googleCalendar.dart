import 'dart:developer';

import "package:googleapis_auth/auth_io.dart";
import 'package:googleapis/calendar/v3.dart';
import 'package:url_launcher/url_launcher.dart';

class GoogleCalendar {
  
  GoogleCalendar();
   static const _scopes = const [CalendarApi.CalendarScope];
  var _clientID = new ClientId(
      "761711840085-1pfna7muukpjvqgn48c44ghjliu35vnu.apps.googleusercontent.com",
      "");


  void setEvent(String name , DateTime startDate ,DateTime endDate ){
    print("deadline for event"+endDate.toString());
    
   Event event = Event(); // Create object of event
    event.summary = name;

    EventDateTime start = new EventDateTime(); //Setting start time
      start.dateTime= startDate;
      start.timeZone  = "GMT+03:00";
      event.start = start;

     EventDateTime end = new EventDateTime();
     end.dateTime=endDate;
     end.timeZone = "GMT+03:00";
     event.end=end;

      insertEvent(event);
      // String calendarId = "primary";
      // event = service.events().insert(calendarId, event).execute();
      // print("Event created: %s\n"+event.getHtmlLink());

      

 
      // clientViaUserConsent(_clientID, _scopes, prompt)
      //     .then((AuthClient client) {
      //   var calendar = CalendarApi(client);
      //   String calendarId = "primary";
      //   calendar.events.insert(event, calendarId);
      //   // .then((value) {
      //   //   if (value.status == "confirmed") {
      //   //     log('Event added in google calendar');
      //   //   } else {
      //   //     log("Unable to add event in google calendar");
      //   //   }
      // //  });
      // });
    
  }

  insertEvent(event) async {
try {
        await clientViaUserConsent(_clientID, _scopes, prompt).then((AuthClient client) async {
        var calendar = CalendarApi(client);
        String calendarId = "primary";
        print("try before insert");
      await  calendar.events.insert(event,calendarId).then((value) {
          print("try after insert");
          print("ADDEDDD_________________${value.status}");
          if (value.status == "confirmed") {
            print('Event added in google calendar');
          } else {
            print("Unable to add event in google calendar");
          }
        });
        });
      } catch (e) {
        log('Error creating event $e');
      }
}





  void prompt(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}


