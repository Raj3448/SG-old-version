import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/asterisk_label.dart';
import 'package:silver_genie/core/widgets/custom_drop_down_box.dart';
import 'package:silver_genie/core/widgets/error_state_component.dart';
import 'package:silver_genie/core/widgets/fixed_button.dart';
import 'package:silver_genie/core/widgets/form_components.dart';
import 'package:silver_genie/core/widgets/loading_widget.dart';
import 'package:silver_genie/core/widgets/multidropdown.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/feature/book_services/model/form_details_model.dart';
import 'package:silver_genie/feature/book_services/repo/services_repo.dart';
import 'package:silver_genie/feature/book_services/widgets/booking_status.dart';
import 'package:silver_genie/feature/genie/services/product_listing_services.dart';
import 'package:silver_genie/feature/members/model/member_model.dart';
import 'package:silver_genie/feature/members/store/members_store.dart';

class BookServiceScreen extends StatefulWidget {
  BookServiceScreen({required this.id, super.key});
  final String id;

  @override
  State<BookServiceScreen> createState() => _BookServiceScreenState();
}

class _BookServiceScreenState extends State<BookServiceScreen> {
  final TextEditingController dobContr = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<CustomDropDownBoxState> _customDropDownBoxKey =
      GlobalKey<CustomDropDownBoxState>();
  Map<String, String> formValues = {};
  Member? selectedMember;

  @override
  void dispose() {
    dobContr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const PageAppbar(title: 'Book Service'),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FixedButton(
        ontap: () {
          _submitAndNext(context);
        },
        btnTitle: 'Submit & next',
        showIcon: false,
        iconPath: AppIcons.add,
      ),
      body: FutureBuilder(
        future: GetIt.I<ProductLisitingServices>()
            .getBookingServiceDetailsById(id: widget.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget(
              showShadow: false,
            );
          }
          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isLeft()) {
            return const ErrorStateComponent(
                errorType: ErrorType.somethinWentWrong);
          }
          late FormDetailModel formDetailModel;
          snapshot.data!.getRight().fold(
              () => const ErrorStateComponent(
                  errorType: ErrorType.somethinWentWrong),
              (t) => formDetailModel = t);
          List<Widget> widgetList = [];
          final components = formDetailModel.attributes.form;
          for (var i = 0; i < components.length; i++) {
            if (components[i].component ==
                    'form-field-type.reference-question' &&
                components[i].controlType == 'familyDropDown') {
              widgetList.addAll([
                const SizedBox(height: Dimension.d4),
                if (components[i].formDetails.required)
                  AsteriskLabel(
                      label: '${i + 1}. ${components[i].formDetails.title}'),
                if (!components[i].formDetails.required)
                  Text(
                    '${i + 1}. ${components[i].formDetails.title}',
                    style: AppTextStyle.bodyMediumMedium
                        .copyWith(color: AppColors.grayscale700),
                  ),
                const SizedBox(height: Dimension.d2),
                CustomDropDownBox(
                  key: _customDropDownBoxKey,
                  
                  memberName: selectedMember?.name,
                  memberList: GetIt.I<MembersStore>().members,
                  updateMember: (member) {
                    selectedMember = member;
                    formValues[components[i].formDetails.title] =
                        member?.id.toString() ?? '';
                  },
                  isRequired: components[i].formDetails.required,
                )
              ]);
            } else if (components[i].component ==
                    'form-field-type.string-question' &&
                components[i].type == 'string') {
              final List<Validations> validations = components[i].validations;
              widgetList.addAll([
                const SizedBox(height: Dimension.d4),
                if (components[i].formDetails.required)
                  AsteriskLabel(
                      label: '${i + 1}. ${components[i].formDetails.title}'),
                if (!components[i].formDetails.required)
                  Text(
                    '${i + 1}. ${components[i].formDetails.title}',
                    style: AppTextStyle.bodyMediumMedium
                        .copyWith(color: AppColors.grayscale700),
                  ),
                const SizedBox(height: Dimension.d2),
                CustomTextField(
                  controller: TextEditingController(
                    text: formValues[components[i].formDetails.title],
                  ),
                  validationLogic: components[i].formDetails.required ? (value) {
                    if (value == null ) {
                      return '${components[i].formDetails.title} must not empty';
                    }
                    return applyValidations(value: value, validations: validations,);
                  } : null,
                  onChanged: (value) {
                    formValues[components[i].formDetails.title] = value.trim();
                  },
                  hintText: 'Type here',
                  keyboardType: TextInputType.name,
                  large: true,
                  enabled: true,
                ),
              ]);
            } else if (components[i].component ==
                    'form-field-type.choice-question' &&
                components[i].type == 'choice') {
              final List<Validations> validations = components[i].validations;
              widgetList.addAll([
                const SizedBox(height: Dimension.d4),
                if (components[i].formDetails.required)
                  AsteriskLabel(
                      label: '${i + 1}. ${components[i].formDetails.title}'),
                if (!components[i].formDetails.required)
                  Text(
                    '${i + 1}. ${components[i].formDetails.title}',
                    style: AppTextStyle.bodyMediumMedium
                        .copyWith(color: AppColors.grayscale700),
                  ),
                const SizedBox(height: Dimension.d2),
                MultiSelectFormField(
                  onSaved: (newValue) {
                    formValues[components[i].formDetails.title] =
                        newValue?.first.value.toString().trim() ?? '';
                  },
                  validator:components[i].formDetails.required ? (value) {
                    if (value == null ) {
                      return '${components[i].formDetails.title} must not empty';
                    }
                    return applyValidations(value: value.first.value.toString(),validations: validations,);
                  } : null,
                  values: List.generate(
                      components[i].options.length,
                      (index) => ValueItem(
                          label: components[i].options[index].display,
                          value: components[i].options[index].value)),
                )
              ]);
            } else if (components[i].component ==
                'form-field-type.date-question') {
              final List<Validations> validations = components[i].validations;
              widgetList.addAll([
                const SizedBox(height: Dimension.d4),
                if (components[i].formDetails.required)
                  AsteriskLabel(
                      label: '${i + 1}. ${components[i].formDetails.title}'),
                if (!components[i].formDetails.required)
                  Text(
                    '${i + 1}. ${components[i].formDetails.title}',
                    style: AppTextStyle.bodyMediumMedium
                        .copyWith(color: AppColors.grayscale700),
                  ),
                const SizedBox(height: Dimension.d2),
                DateDropdown(
                  controller: dobContr,
                  dateFormat: components[i].dateFormat,
                  onChanged: (value) {
                    print('Date time on changed $value');
                    formValues[components[i].formDetails.title] = dobContr.text;
                  },
                  validator: components[i].formDetails.required ? (value) {
                    if (value == null ) {
                      return '${components[i].formDetails.title} must not empty';
                    }
                    return applyValidations(value: dobContr.text,validations: validations,);
                  } : null,
                ),
              ]);
            }
          }
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BookingStatus(),
                    ...widgetList,
                    const SizedBox(height: Dimension.d20),
                    const SizedBox(height: Dimension.d4),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String? applyValidations({String? value, required List<Validations> validations}) {
    
  for (var validation in validations) {
    if (validation.type == 'minValue' &&  value!.length < (int.tryParse(validation.valueMsg.value) ?? 1)) {
      return validation.valueMsg.message;
    }
    if (validation.type == 'maxValue' &&  value!.length > (int.tryParse(validation.valueMsg.value) ?? 10)) {
      return validation.valueMsg.message;
    }
  }
  return null;
}

  void _submitAndNext(BuildContext context) {
    if (!_formKey.currentState!.validate() ||
        !_customDropDownBoxKey.currentState!.validate()) {
      return;
    }

    print(formValues);
    context.pushNamed(RoutesConstants.paymentScreen);
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
