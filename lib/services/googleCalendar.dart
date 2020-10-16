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
    Event event = Event(); // Create object of event
    event.summary = name;

    EventDateTime start = new EventDateTime(); //Setting start time
      start.dateTime= startDate;
      event.start = start;

     EventDateTime end = new EventDateTime();
     end.dateTime=endDate;
     event.end=end;


 insertEvent(event);
 
  }

   insertEvent(event) {
    try {
      clientViaUserConsent(_clientID, _scopes, prompt)
          .then((AuthClient client) {
        var calendar = CalendarApi(client);
        String calendarId = "primary";
        calendar.events.insert(event, calendarId).then((value) {
          print("ADDEDDD_________________${value.status}");
          if (value.status == "confirmed") {
            log('Event added in google calendar');
          } else {
            log("Unable to add event in google calendar");
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
