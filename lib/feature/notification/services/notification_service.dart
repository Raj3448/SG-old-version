// ignore_for_file: lines_longer_than_80_chars, one_member_abstracts

import 'package:fpdart/fpdart.dart';
import 'package:silver_genie/core/failure/failure.dart';
import 'package:silver_genie/feature/notification/model/notification_model.dart';

abstract class INotificationFacade {
  Future<Either<Failure, List<NotificationModel>>> fetchNotification();
}

class NotificationServices extends INotificationFacade {
  final List<NotificationModel> _notifications = [
    NotificationModel(
      title: 'Doctor Consultation Completed',
      description:
          'Your doctor consultation request with Order Id: 140780 has been successfully concluded.',
      datetime: DateTime(2024, 03, 31, 10, 30),
    ),
    NotificationModel(
      title: 'Get 30% OFF for Wellness Plan ',
      description:
          "Special Offer: Upgrade to Silver Genie's Platinum Plan and get 30% off for the first month. Limited time only!",
      datetime: DateTime(2022, 01, 31, 08, 30),
    ),
    NotificationModel(
      title: 'Get 20% OFF for Wellness Plan ',
      description:
          "Special Offer: Upgrade to Silver Genie's Platinum Plan and get 30% off for the first month. Limited time only!",
      datetime: DateTime(2022, 01, 31, 09, 30),
      imageUrl: 'assets/icon/notification_image.png',
    ),
    NotificationModel(
      title: 'Home Diagnosis request confirmed ',
      description:
          'Your Home Diagnosis request with Order Id: 140780 is been confirmed',
      datetime: DateTime(2024, 02, 31, 10, 30),
    ),
    NotificationModel(
      title: 'Home Diagnosis request confirmed ',
      description:
          'Your Home Diagnosis request with Order Id: 140780 is been confirmed',
      datetime: DateTime(2024, 04, 31, 10, 30),
    ),
    NotificationModel(
      title: 'Get 50% OFF for Wellness Plan ',
      description:
          "Special Offer: Upgrade to Silver Genie's Platinum Plan and get 30% off for the first month. Limited time only!",
      datetime: DateTime(2024, 04, 15, 10, 30),
      imageUrl: 'assets/icon/notification_image.png',
    ),
  ];
  @override
  Future<Either<Failure, List<NotificationModel>>> fetchNotification() async {
    //  API call here to fetch user details
    try {
      // final response = await HttpClient().get<String>('/notifications');

      // if (response.statusCode == 200) {
      //   final json = jsonDecode(response.data!);
      //   final existingNotifyList = json.map((jsonObject) {
      //     return NotificationModel.fromJson(jsonObject as Map<String,dynamic>);
      //   }).toList();
      //   return Right(existingNotifyList as List<NotificationModel>);
      // } else {
      //   return Left(Failure.badResponse());
      // }
      return Right(_notifications);
    } on SocketException {
      return const Left(Failure.socketException());
    } catch (error) {
      return const Left(Failure.someThingWentWrong());
    }
  }
}
