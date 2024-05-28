import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_dropdown/models/value_item.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/fixed_button.dart';
import 'package:silver_genie/core/widgets/form_components.dart';
import 'package:silver_genie/core/widgets/multidropdown.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/feature/services/repo/services_repo.dart';
import 'package:silver_genie/feature/services/widgets/booking_status.dart';

class BookServiceScreen extends StatelessWidget {
  BookServiceScreen({super.key});
  final TextEditingController dobContr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const PageAppbar(title: 'Book Service'),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FixedButton(
        ontap: () {
          context.pushNamed(RoutesConstants.paymentScreen);
        },
        btnTitle: 'Submit & next',
        showIcon: false,
        iconPath: AppIcons.add,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BookingStatus(),
              const SizedBox(height: Dimension.d6),
              Text(
                '1. Select family member',
                style: AppTextStyle.bodyMediumMedium
                    .copyWith(color: AppColors.grayscale700),
              ),
              const SizedBox(height: Dimension.d2),
              const RelationDropdown(),
              const SizedBox(height: Dimension.d4),
              Text(
                '2. Select Date',
                style: AppTextStyle.bodyMediumMedium
                    .copyWith(color: AppColors.grayscale700),
              ),
              const SizedBox(height: Dimension.d2),
              // DateDropdown(controller: dobContr),
              const SizedBox(height: Dimension.d4),
              Text(
                '3. Select time slot',
                style: AppTextStyle.bodyMediumMedium
                    .copyWith(color: AppColors.grayscale700),
              ),
              const SizedBox(height: Dimension.d2),
              const SizedBox(
                height: 150,
                width: 300,
                child: _TimeSlot(),
              ),
              const SizedBox(height: Dimension.d3),
              Text(
                '4. Desired hours of consultation',
                style: AppTextStyle.bodyMediumMedium
                    .copyWith(color: AppColors.grayscale700),
              ),
              const SizedBox(height: Dimension.d2),
              MultiSelectFormField(
                
                values: [
                  ValueItem(
                    label: '30 mins'.tr(),
                    value: '30 mins',
                  ),
                  ValueItem(
                    label: '1 hour'.tr(),
                    value: '1 hour',
                  ),
                  ValueItem(
                    label: '2 hour'.tr(),
                    value: '2 hour',
                  ),
                ],
              ),
              const SizedBox(height: Dimension.d4),
              Text(
                '5. Purpose of consultation',
                style: AppTextStyle.bodyMediumMedium
                    .copyWith(color: AppColors.grayscale700),
              ),
              const SizedBox(height: Dimension.d2),
              CustomTextField(
                hintText: 'Write your purpose here',
                keyboardType: TextInputType.name,
                large: true,
                enabled: true,
              ),
              const SizedBox(height: Dimension.d4),
              Text(
                '6. Additional info',
                style: AppTextStyle.bodyMediumMedium
                    .copyWith(color: AppColors.grayscale700),
              ),
              const SizedBox(height: Dimension.d2),
              CustomTextField(
                hintText: 'Type here...',
                keyboardType: TextInputType.name,
                large: true,
                enabled: true,
              ),
              const SizedBox(height: Dimension.d20),
              const SizedBox(height: Dimension.d4),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimeSlot extends StatelessWidget {
  const _TimeSlot();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchTimeSlots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.data == null || snapshot.data!.isEmpty) {
          return const Text('No time slots available');
        } else {
          final timeSlots = snapshot.data!;
          return GridView.builder(
            itemCount: timeSlots.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 100,
              mainAxisExtent: 50,
            ),
            itemBuilder: (context, index) {
              final slot = timeSlots[index];
              return Align(
                alignment: Alignment.topLeft,
                child: _TimeSlotTile(title: slot.timeSlot),
              );
            },
          );
        }
      },
    );
  }
}

class _TimeSlotTile extends StatelessWidget {
  const _TimeSlotTile({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.grayscale400),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      child: Text(
        title,
        style: AppTextStyle.bodyMediumMedium
            .copyWith(color: AppColors.grayscale900),
      ),
    );
  }
}
