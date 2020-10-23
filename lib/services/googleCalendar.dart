import 'dart:developer';

import "package:googleapis_auth/auth_io.dart";
import 'package:googleapis/calendar/v3.dart';
import 'package:peak/locator.dart';
import 'package:peak/services/databaseServices.dart';
import 'package:url_launcher/url_launcher.dart';

class GoogleCalendar {
  DatabaseServices db = locator<DatabaseServices>();

  GoogleCalendar();
  static const _scopes = const [CalendarApi.CalendarScope];
  var _clientID = new ClientId(
      "761711840085-1pfna7muukpjvqgn48c44ghjliu35vnu.apps.googleusercontent.com",
      "");

  Future setEvent(String name, DateTime startDate, DateTime endDate) {
    print("deadline for event" + endDate.toString());
    Event event = Event(); // Create object of event
    event.summary = name;

    EventDateTime start = new EventDateTime(); //Setting start time
    start.dateTime = startDate;
    start.timeZone = "GMT+03:00";
    event.start = start;

    EventDateTime end = new EventDateTime();
    end.dateTime = endDate;
    end.timeZone = "GMT+03:00";
    event.end = end;

    return insertEvent(event);
  }

  Future<void> deleteEvent(String id) async {
    try {
      await clientViaUserConsent(_clientID, _scopes, prompt)
          .then((AuthClient client) async {
        var calendar = CalendarApi(client);
        String calendarId = "primary";
        print("try before delete");
        await calendar.events.delete(calendarId, id);
        print("try after delete");
      });
    } catch (e) {
      log('Error Deleting $e');
    }
  }

  Future<void> updateEvent(
      String name, DateTime creation, DateTime deadline, String id) async {
    Event event = Event(); // Create object of event
    event.summary = name;
    EventDateTime start = new EventDateTime(); //Setting start time
    start.dateTime = creation;
    start.timeZone = "GMT+03:00";
    event.start = start;

    EventDateTime end = new EventDateTime();
    end.dateTime = deadline;
    end.timeZone = "GMT+03:00";
    event.end = end;

    try {
      await clientViaUserConsent(_clientID, _scopes, prompt)
          .then((AuthClient client) async {
        var calendar = CalendarApi(client);
        String calendarId = "primary";
        print("try before updating");
        await calendar.events.update(event, calendarId, id);
      });
      print("event updated succsesfully");
    } catch (e) {
      log('Error Updating $e');
    }
  }

  insertEvent(event) async {
    try {
      await clientViaUserConsent(_clientID, _scopes, prompt)
          .then((AuthClient client) async {
        var calendar = CalendarApi(client);
        String calendarId = "primary";
        print("try before insert");
        await calendar.events.insert(event, calendarId).then((value) {
          print("try after insert");
          print("ADDEDDD_________________${value.status}");
          if (value.status == "confirmed") {
            db.eventId = value.id;
            print(db.eventId);
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
