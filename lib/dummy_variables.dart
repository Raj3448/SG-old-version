import 'dart:math';
import 'package:silver_genie/feature/bookings/model/booking_service_model.dart';

final List<String> memberNames = [
  "John Smith",
  "Emily Johnson",
  "Michael Williams",
  "Sophia Brown",
  "William Jones",
  "Emma Davis",
  "Alexander Miller",
  "Olivia Wilson",
  "James Moore",
];
    final statuses = ["requested", "active", "completed"];
    final serviceNames = [
      "Critical nurse care",
      "Diagnostics",
      "Doctor consultation",
      "General duty attendant",
      "Home care unit setup",
      "Home radiology",
      "ICU setup",
      "Insurance",
      "Legal Support",
      "Neurodegenerative nurse",
      "Nurse",
      "Post operative care",
      "Tax"
    ];

    final List<BookingServiceModel> bookingServicesList = List.generate(20, (index) {
    final status = statuses[Random().nextInt(statuses.length)];
    final serviceName = serviceNames[Random().nextInt(serviceNames.length)];
    final memberName = memberNames[Random().nextInt(memberNames.length)];
    final requestedDate = DateTime.now().subtract(Duration(days: Random().nextInt(100)));
    final completedDate = status == "completed" ? DateTime.now().subtract(Duration(days: Random().nextInt(30))) : null;

    return BookingServiceModel(
      id: index + 1,
      status: status,
      serviceName: serviceName,
      memberName: memberName,
      requestedDate: requestedDate,
      completedDate: completedDate,
    );
  });