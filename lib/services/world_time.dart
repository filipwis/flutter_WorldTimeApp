import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime {
  String location;
  String time;
  String flag;
  String url;
  bool isDaytime;

  WorldTime({this.location, this.flag, this.url});

  Future<void> getTime() async {
    try {
      Response response =
          await get('http://worldtimeapi.org/api/timezone/$url');
      Map data = jsonDecode(response.body);

      String dateTime = data['datetime'];
      String offset = data['utc_offset'];
      bool addTime = false;

      if (offset.contains('+')) {
        addTime = true;
      }

      offset = offset.substring(1, 3);

      DateTime now = DateTime.parse(dateTime);

      if (addTime) {
        now = now.add(Duration(hours: int.parse(offset)));
      } else {
        now = now.subtract(Duration(hours: int.parse(offset)));
      }

      isDaytime = now.hour > 6 && now.hour < 19 ? true : false;

      time = DateFormat.Hm().format(now);
    } catch (e) {
      print('Error: $e');
      time = 'Cannot get time data';
    }
  }
}
