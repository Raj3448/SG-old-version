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
  String? fetchServiceError;

  @observable
  List<BookingServiceModel> bookingServiceList = [];

  @computed
  List<BookingServiceModel> get getAllRequestedServiceList =>
      bookingServiceList.where((element) => element.status == 'requested',).toList();

  @computed
  List<BookingServiceModel> get getAllActiveServiceList =>
      bookingServiceList.where((element) => element.status == 'active',).toList();

  @computed
  List<BookingServiceModel> get getAllCompletedServiceList =>
      bookingServiceList.where((element) => element.status == 'completed',).toList();

  void initGetAllServices() {
    isAllServiceLoading = true;
    bookingService.getBookingServiceBasicDetails().then((value) {
      value.fold((l) {
        fetchServiceError = 'Something went wrong';
      }, (r) {
        isAllServiceLoaded = true;
        bookingServiceList = r;
      });
      isAllServiceLoading = false;
    });
  }
}
