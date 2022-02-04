// ignore_for_file: file_names

class DisplayingTimeSlot {
  final String timeSlot;
  final int indexOfTimeSlot;
  final int indexOfTimeSection;
  final int dateOfTimeSlot;

  DisplayingTimeSlot(this.timeSlot, this.indexOfTimeSlot,
      this.indexOfTimeSection, this.dateOfTimeSlot);

  @override
  String toString() {
    return 'The timeSlot is ------ $timeSlot'
        ', and index is --------- $indexOfTimeSlot '
        'and the timeSection is '
        '${indexOfTimeSection == 0 ? 'Day' : 'night'}';
  }
}