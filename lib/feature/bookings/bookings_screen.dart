import 'package:easy_localization/easy_localization.dart';
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
    store.refresh();
    controller = TabController(length: 3, vsync: this);

    _reactionDisposer =
        reaction((_) => store.allServiceRefreshFailure, (refreshFailure) {
      if (refreshFailure != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(refreshFailure),
            duration: const Duration(seconds: 5),
          ),
        );
      }
      store.allServiceRefreshFailure = null;
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
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
              widgetList: [
                Tab(icon: Text('Requested'.tr())),
                Tab(icon: Text('Active'.tr())),
                Tab(icon: Text('Completed'.tr())),
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
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookingsStateComponent extends StatelessWidget {
  const BookingsStateComponent({
    required this.bookingServiceStatus,
    required this.store,
    super.key,
  });
  final BookingServiceStatus bookingServiceStatus;
  final BookingServiceStore store;

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
        if (store.isAllServiceLoading) {
          return const Center(
            child: LoadingWidget(
              showShadow: false,
            ),
          );
        }
        if (store.fetchServiceError != null ||
            store.allServiceRefreshFailure == 'No_Internet') {
          final error =
              store.fetchServiceError ?? store.allServiceRefreshFailure;
          store
            ..fetchServiceError = null
            ..allServiceRefreshFailure = null;
          return ErrorStateComponent(
            errorType: error == 'No_Internet'
                ? ErrorType.noInternetConnection
                : ErrorType.somethinWentWrong,
          );
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
                    (index) => bookingModelList[index].requestedFor.isEmpty
                        ? const SizedBox()
                        : BookingListTileComponent(
                            bookingServiceStatus: bookingServiceStatus,
                            bookingServiceModel: bookingModelList[index],
                          ),
                  ),
                ),
        );
      },
    );
  }
}
