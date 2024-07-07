import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/widgets/booking_service_listile_component.dart';
import 'package:silver_genie/core/widgets/customize_tabview_component.dart';
import 'package:silver_genie/core/widgets/empty_state_component.dart';
import 'package:silver_genie/core/widgets/error_state_component.dart';
import 'package:silver_genie/core/widgets/loading_widget.dart';
import 'package:silver_genie/feature/bookings/store/booking_service_store.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  final store = GetIt.I<BookingServiceStore>();
  late ReactionDisposer _reactionDisposer;

  @override
  void initState() {
    store.initGetAllServices();
    controller = TabController(length: 3, vsync: this);

    _reactionDisposer =
        reaction((_) => store.allServiceRefreshFailure, (refreshFailure) {
      if (refreshFailure != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(refreshFailure),
          duration: const Duration(seconds: 5),
        ));
      }
      store.allServiceRefreshFailure = null;
    });
    
    super.initState();
  }

  @override
  void dispose() {
    _reactionDisposer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: Dimension.d3),
              Text(
                'Bookings',
                style: AppTextStyle.bodyXLBold
                    .copyWith(color: AppColors.grayscale900),
              ),
              const SizedBox(height: Dimension.d3),
              CustomizeTabviewComponent(
                controller: controller,
                tabCount: 3,
                widgetList: const [
                  Tab(icon: Text('Requested')),
                  Tab(icon: Text('Active')),
                  Tab(icon: Text('Completed')),
                ],
              ),
              const SizedBox(
                height: Dimension.d2,
              ),
              Expanded(
                child: TabBarView(
                  controller: controller,
                  children: List.generate(
                      3,
                      (index) => BookingsStateComponent(
                            bookingServiceStatus: index == 0
                                ? BookingServiceStatus.requested
                                : index == 1
                                    ? BookingServiceStatus.active
                                    : BookingServiceStatus.completed,
                            store: store,
                          )),
                ),
              ),
            ],
          ),
        ));
  }
}

class BookingsStateComponent extends StatelessWidget {
  final BookingServiceStatus bookingServiceStatus;
  final BookingServiceStore store;
  const BookingsStateComponent(
      {required this.bookingServiceStatus, required this.store, super.key});

  @override
  Widget build(BuildContext context) {
    final bookingModelList =
        bookingServiceStatus == BookingServiceStatus.completed
            ? store.getAllCompletedServiceList
            : BookingServiceStatus.active == bookingServiceStatus
                ? store.getAllActiveServiceList
                : store.getAllRequestedServiceList;
    return Observer(
      builder: (context) {
        if (store.isAllServiceLoading || store.isAllServiceRefreshing) {
          return const Center(
            child: LoadingWidget(
              showShadow: false,
            ),
          );
        }
        if (store.fetchServiceError != null) {
          return const ErrorStateComponent(
              errorType: ErrorType.somethinWentWrong);
        }
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: bookingModelList.isEmpty
              ? EmptyStateComponent(
                  bookingServiceStatus: bookingServiceStatus,
                )
              : Column(
                  children: List.generate(
                      bookingModelList.length,
                      (index) => BookingListTileComponent(
                            bookingServiceStatus: bookingServiceStatus,
                            bookingServiceModel: bookingModelList[index],
                          )),
                ),
        );
      },
    );
  }
}
