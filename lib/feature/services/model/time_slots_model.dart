class TimeSlotModel {
  TimeSlotModel({required this.timeSlot});

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      timeSlot: json['time_slot'] as String,
    );
  }
  String timeSlot;
}
