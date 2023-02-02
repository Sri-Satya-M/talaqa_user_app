class TimelineModel {}

class Event {
  final String title;
  String? time;
  Event(this.title, [this.time]);
  addTime(String time) {
    this.time = time;
  }
}
