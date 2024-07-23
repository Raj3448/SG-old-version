// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';
import 'package:silver_genie/feature/bookings/model/booking_service_model.dart';
import 'package:silver_genie/feature/bookings/services/booking_service.dart';

part 'booking_service_store.g.dart';

class BookingServiceStore = _BookingServiceStoreBase with _$BookingServiceStore;

abstract class _BookingServiceStoreBase with Store {
  _BookingServiceStoreBase({required this.ibookingService});

  final IBookingService ibookingService;

  @observable
  bool isAllServiceLoaded = false;

  @observable
  bool isAllServiceLoading = false;

  @observable
  bool isAllServiceRefreshing = false;

  @observable
  String? allServiceRefreshFailure;

  @observable
  String? fetchServiceError;

  @observable
  BookingServices? bookingServices;

  @observable
  bool isFileInDownloadProcess = false;

  @computed
  List<Service> get getAllRequestedServiceList => bookingServices == null
      ? []
      : bookingServices!.services
          .where(
            (element) =>
                element.status == 'requested' || element.status == 'processing',
          )
          .toList();

  @computed
  List<Service> get getAllActiveServiceList => bookingServices == null
      ? []
      : bookingServices!.services
          .where(
            (element) =>
                element.status == 'processed' || element.status == 'active',
          )
          .toList();

  @computed
  List<Service> get getAllCompletedServiceList => bookingServices == null
      ? []
      : bookingServices!.services
          .where(
            (element) =>
                element.status == 'completed' || element.status == 'rejected',
          )
          .toList();

  @action
  void initGetAllServices() {
    if (isAllServiceLoaded) {
      return;
    }
    isAllServiceLoading = true;
    ibookingService.getBookingServiceBasicDetails().then((value) {
      value.fold((l) {
        l.maybeMap(
          socketError: (value) => fetchServiceError = 'No_Internet',
          orElse: () => fetchServiceError = 'Something went wrong',
        );
      }, (r) {
        isAllServiceLoaded = true;
        bookingServices = r;
      });
      isAllServiceLoading = false;
    });
  }

  @action
  void refresh() {
    isAllServiceRefreshing = true;
    ibookingService.getBookingServiceBasicDetails().then(
      (value) {
        value.fold(
          (l) {
            l.maybeMap(
              socketError: (e) => allServiceRefreshFailure = 'No_Internet',
              orElse: () => allServiceRefreshFailure =
                  'Unable to load updated booking services',
            );
          },
          (r) {
            bookingServices = r;
          },
        );
        isAllServiceRefreshing = false;
      },
    );
  }

  void clear() {
    bookingServices = null;
  }
}
