import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/widgets/app_bar.dart';
import 'package:silver_genie/core/widgets/booking_service_listile_component.dart';
import 'package:silver_genie/core/widgets/customize_tabview_component.dart';
import 'package:silver_genie/core/widgets/empty_state_component.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const Appbar(),
        backgroundColor: AppColors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bookings',
                style: AppTextStyle.bodyXLSemiBold
                    .copyWith(color: AppColors.grayscale900, height: 2.6),
              ),
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
  const BookingsStateComponent({required this.bookingServiceStatus, super.key});

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: !isLoading
          ? EmptyStateComponent(
              bookingServiceStatus: bookingServiceStatus,
            )
          : Column(
              children: List.generate(
                  6,
                  (index) => BookingListTileComponent(
                        bookingServiceStatus: bookingServiceStatus,
                      )),
            ),
    );
  }
}
