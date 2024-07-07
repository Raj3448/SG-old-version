import 'package:mobx/mobx.dart';
import 'package:silver_genie/feature/bookings/model/booking_service_model.dart';
import 'package:silver_genie/feature/bookings/services/booking_service.dart';

part 'booking_service_store.g.dart';

class BookingServiceStore = _BookingServiceStoreBase with _$BookingServiceStore;

abstract class _BookingServiceStoreBase with Store {
  _BookingServiceStoreBase({required this.bookingService});

  final IBookingService bookingService;

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

  @computed
  List<Service> get getAllRequestedServiceList => bookingServices == null
      ? []
      : bookingServices!.services
          .where(
            (element) => element.paymentStatus == 'paid',
          )
          .toList();

  @computed
  List<Service> get getAllActiveServiceList => bookingServices == null
      ? []
      : bookingServices!.services
          .where(
            (element) => element.paymentStatus == 'due',
          )
          .toList();

  @computed
  List<Service> get getAllCompletedServiceList => bookingServices == null
      ? []
      : bookingServices!.services
          .where(
            (element) => element.paymentStatus == 'completed',
          )
          .toList();

  @action
  void initGetAllServices() {
    if (isAllServiceLoaded) {
      return;
    }
    isAllServiceLoading = true;
    bookingService.getBookingServiceBasicDetails().then((value) {
      value.fold((l) {
        fetchServiceError = 'Something went wrong';
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
    bookingService.getBookingServiceBasicDetails().then(
      (value) {
        value.fold(
          (l) {
            allServiceRefreshFailure = 'Unable to load updated booking services';
          },
          (r) {
            bookingServices = r;
          },
        );
        isAllServiceRefreshing = false;
      },
    );
  }
}
