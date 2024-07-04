// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/payment/payment_services.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/assigning_component.dart';
import 'package:silver_genie/core/widgets/asterisk_label.dart';
import 'package:silver_genie/core/widgets/custom_drop_down_box.dart';
import 'package:silver_genie/core/widgets/error_state_component.dart';
import 'package:silver_genie/core/widgets/fixed_button.dart';
import 'package:silver_genie/core/widgets/form_components.dart';
import 'package:silver_genie/core/widgets/loading_widget.dart';
import 'package:silver_genie/core/widgets/multidropdown.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/feature/book_services/model/form_details_model.dart';
import 'package:silver_genie/feature/book_services/widgets/booking_status.dart';
import 'package:silver_genie/feature/bookings/booking_sevice_status_page.dart';
import 'package:silver_genie/feature/genie/services/product_listing_services.dart';
import 'package:silver_genie/feature/genie/store/product_listing_store.dart';
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
  List<FormAnswer> formAnswers = [];
  Member? selectedMember;
  final service = GetIt.I<ProductListingServices>();
  final store = GetIt.I<ProductListingStore>();

  @override
  void initState() {
    reaction((_) => store.buyServiceFailed, (buyServiceFailed) {
      if (buyServiceFailed != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(buyServiceFailed),
            duration: const Duration(seconds: 3),
          ),
        );
      }
      store.buyServiceFailed = null;
    });
    reaction((_) => store.paymentStatus, (PaymentStatus? paymentStatus) {
      if (paymentStatus != null) {
        context.pushReplacementNamed(RoutesConstants.paymentScreen,
            extra: {'paymentStatus': paymentStatus});
      }
      store..paymentStatus = null;
    });
    super.initState();
  }

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
      floatingActionButton: Observer(
        builder: (_) {
          return FixedButton(
            ontap: () {
              if (store.servicePaymentInfoGotSuccess == null) {
                _submitAndNext(context);
              } else {
                _proceedToPay();
              }
            },
            btnTitle: store.servicePaymentInfoGotSuccess == null
                ? 'Submit & next'
                : 'Proceed to pay',
            showIcon: false,
            iconPath: AppIcons.add,
          );
        },
      ),
      body: FutureBuilder(
        future: service.getBookingServiceDetailsById(id: widget.id),
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
            final component = components[i];
            switch (component.component) {
              case 'form-field-type.reference-question':
                if (component.controlType == 'familyDropDown') {
                  widgetList.addAll([
                    const SizedBox(height: Dimension.d4),
                    if (component.formDetails.required)
                      AsteriskLabel(
                          label: '${i + 1}. ${component.formDetails.title}'),
                    if (!component.formDetails.required)
                      Text(
                        '${i + 1}. ${component.formDetails.title}',
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
                        _updateFormValues1(
                            id: component.id,
                            title: component.formDetails.title,
                            type: component.type,
                            controlType: component.controlType,
                            hint: component.formDetails.hint,
                            valueReference: [member?.id.toString() ?? ''],
                            forDId: component.formDetails.id.toString());
                      },
                      isRequired: component.formDetails.required,
                    )
                  ]);
                }
                break;
              case 'form-field-type.string-question':
                if (component.type == 'string') {
                  widgetList.addAll([
                    const SizedBox(height: Dimension.d4),
                    if (component.formDetails.required)
                      AsteriskLabel(
                          label: '${i + 1}. ${component.formDetails.title}'),
                    if (!component.formDetails.required)
                      Text(
                        '${i + 1}. ${component.formDetails.title}',
                        style: AppTextStyle.bodyMediumMedium
                            .copyWith(color: AppColors.grayscale700),
                      ),
                    const SizedBox(height: Dimension.d2),
                    CustomTextField(
                      controller: TextEditingController(),
                      validationLogic: component.formDetails.required
                          ? (value) {
                              if (value == null) {
                                return '${component.formDetails.title} must not be empty';
                              }
                              return applyValidations(
                                value: value,
                                validations: component.validations,
                              );
                            }
                          : null,
                      onSaved: (value) {
                        _updateFormValues1(
                            id: component.id,
                            title: component.formDetails.title,
                            type: component.type,
                            value: value?.trim(),
                            controlType: component.controlType,
                            hint: component.formDetails.hint,
                            forDId: component.formDetails.id.toString());
                      },
                      hintText: 'Type here',
                      keyboardType: TextInputType.name,
                      large: true,
                      enabled: true,
                    ),
                  ]);
                }
                break;
              case 'form-field-type.choice-question':
                if (component.type == 'choice') {
                  widgetList.addAll([
                    const SizedBox(height: Dimension.d4),
                    if (component.formDetails.required)
                      AsteriskLabel(
                          label: '${i + 1}. ${component.formDetails.title}'),
                    if (!component.formDetails.required)
                      Text(
                        '${i + 1}. ${component.formDetails.title}',
                        style: AppTextStyle.bodyMediumMedium
                            .copyWith(color: AppColors.grayscale700),
                      ),
                    const SizedBox(height: Dimension.d2),
                    MultiSelectFormField(
                      showClear: !component.formDetails.required,
                      onSaved: (newValue) {
                        _updateFormValues1(
                            id: component.id,
                            title: component.formDetails.title,
                            type: component.type,
                            value: newValue?.first.value.toString().trim(),
                            controlType: component.controlType,
                            hint: component.formDetails.hint,
                            forDId: component.formDetails.id.toString());
                      },
                      validator: component.formDetails.required
                          ? (value) {
                              if (value == null) {
                                return '${component.formDetails.title} must not be empty';
                              }
                              return applyValidations(
                                value: value.first.value.toString(),
                                validations: component.validations,
                              );
                            }
                          : null,
                      values: List.generate(
                        component.options.length,
                        (index) => ValueItem(
                          label: component.options[index].display,
                          value: component.options[index].value,
                        ),
                      ),
                    )
                  ]);
                }
                break;
              case 'form-field-type.date-question':
                if (component.type == 'date') {
                  widgetList.addAll([
                    const SizedBox(height: Dimension.d4),
                    if (component.formDetails.required)
                      AsteriskLabel(
                          label: '${i + 1}. ${component.formDetails.title}'),
                    if (!component.formDetails.required)
                      Text(
                        '${i + 1}. ${component.formDetails.title}',
                        style: AppTextStyle.bodyMediumMedium
                            .copyWith(color: AppColors.grayscale700),
                      ),
                    const SizedBox(height: Dimension.d2),
                    DateDropdown(
                      controller: dobContr,
                      dateFormat: component.dateFormat,
                      onSaved: (value) {
                        _updateFormValues1(
                            id: component.id,
                            title: component.formDetails.title,
                            type: component.type,
                            value: value.toString(),
                            controlType: component.controlType,
                            hint: component.formDetails.hint,
                            forDId: component.formDetails.id.toString());
                      },
                      validator: component.formDetails.required
                          ? (value) {
                              if (value == null) {
                                return '${component.formDetails.title} must not be empty';
                              }
                              return applyValidations(
                                value: dobContr.text,
                                validations: component.validations,
                              );
                            }
                          : null,
                    ),
                  ]);
                }
                break;
              case 'form-field-type.decimal-question':
                if (component.type == 'decimal') {
                  widgetList.addAll([
                    const SizedBox(height: Dimension.d4),
                    if (component.formDetails.required)
                      AsteriskLabel(
                          label: '${i + 1}. ${component.formDetails.title}'),
                    if (!component.formDetails.required)
                      Text(
                        '${i + 1}. ${component.formDetails.title}',
                        style: AppTextStyle.bodyMediumMedium
                            .copyWith(color: AppColors.grayscale700),
                      ),
                    const SizedBox(height: Dimension.d2),
                    CustomTextField(
                      controller: TextEditingController(
                        text: component.defaultValue.toString(),
                      ),
                      validationLogic: component.formDetails.required
                          ? (value) {
                              if (value == null) {
                                return '${component.formDetails.title} must not be empty';
                              }
                              return applyValidations(
                                  value: value,
                                  validations: component.validations,
                                  isNum: true);
                            }
                          : null,
                      onSaved: (value) {
                        _updateFormValues1(
                            id: component.id,
                            title: component.formDetails.title,
                            type: component.type,
                            value: value?.trim(),
                            controlType: component.controlType,
                            hint: component.formDetails.hint,
                            forDId: component.formDetails.id.toString());
                      },
                      hintText: 'Type here',
                      keyboardType: TextInputType.number,
                      large: false,
                      enabled: true,
                    ),
                  ]);
                }
            }
          }
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Observer(
              builder: (_) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BookingStatus(
                          currentStep:
                              store.servicePaymentInfoGotSuccess != null
                                  ? BookingStep.payment
                                  : BookingStep.serviceDetails,
                        ),
                        if (store.servicePaymentInfoGotSuccess == null)
                          ...widgetList,
                        if (store.servicePaymentInfoGotSuccess != null)
                          _BookingPaymentDetailComp(
                            paymentDetails: store.servicePaymentInfoGotSuccess!,
                          ),
                        const SizedBox(height: Dimension.d20),
                        const SizedBox(height: Dimension.d4),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  String? applyValidations(
      {String? value,
      required List<Validations> validations,
      bool isNum = false}) {
    for (var validation in validations) {
      if (validation.type == 'minValue' &&
          (isNum ? int.tryParse(value!) ?? 1 : value!.length) <
              (int.tryParse(validation.valueMsg.value) ?? 1)) {
        return validation.valueMsg.message;
      }
      if (validation.type == 'maxValue' &&
          (isNum ? int.tryParse(value!) ?? 10 : value!.length) >
              (int.tryParse(validation.valueMsg.value) ?? 10)) {
        return validation.valueMsg.message;
      }
    }
    return null;
  }

  void _updateFormValues1({
    required int id,
    required String title,
    required String type,
    String? value,
    String? controlType,
    required String? hint,
    List<String>? valueReference,
    required String forDId,
  }) {
    final existingIndex =
        formAnswers.indexWhere((element) => element.forDId == forDId);

    if (existingIndex >= 0) {
      formAnswers[existingIndex] = FormAnswer(
        id: id,
        questionTitle: title,
        type: type,
        valueChoice: value,
        controlType: controlType,
        hint: hint,
        valueReference: valueReference,
        forDId: forDId,
      );
    } else {
      formAnswers.add(FormAnswer(
        id: id,
        questionTitle: title,
        type: type,
        valueChoice: value,
        controlType: controlType,
        hint: hint,
        valueReference: valueReference,
        forDId: forDId,
      ));
    }
  }

  void _submitAndNext(BuildContext context) {
    final formValidate = !_formKey.currentState!.validate();
    final isCustomValidate = !_customDropDownBoxKey.currentState!.validate();
    if (formValidate || isCustomValidate) {
      return;
    }
    _formKey.currentState!.save();
    final formAnswerModel = FormAnswerModel(
        formAnswer: formAnswers, productId: int.parse(widget.id));
    store.buyService(formData: formAnswerModel);
  }

  void _proceedToPay() {
    GetIt.I<PaymentService>().openCheckout(amount: 10, receipt: '');
  }
}

class _BookingPaymentDetailComp extends StatelessWidget {
  final String paymentDetails;
  const _BookingPaymentDetailComp({
    required this.paymentDetails,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Order Summery',
            style: AppTextStyle.bodyLargeSemiBold.copyWith(
                fontSize: 18, color: AppColors.grayscale900, height: 2.6)),
        const AssigningComponent(
          name: 'Service opted for',
          initializeElement: 'Vinita nair',
        ),
        const SizedBox(
          height: Dimension.d2,
        ),
        const AssigningComponent(
          name: 'Duty hours',
          initializeElement: '8 hours per day',
        ),
        const SizedBox(
          height: Dimension.d2,
        ),
        const AssigningComponent(
          name: 'Expected duration of service',
          initializeElement: '60 Days',
        ),
        const SizedBox(
          height: Dimension.d2,
        ),
        const AssigningComponent(
          name: 'Expected date to start service',
          initializeElement: '24/5/2024',
        ),
        const SizedBox(
          height: Dimension.d2,
        ),
        const Divider(
          color: AppColors.line,
        ),
        Text('Payment breakdown',
            style: AppTextStyle.bodyLargeSemiBold.copyWith(
                fontSize: 18, color: AppColors.grayscale900, height: 2.6)),
        ElementSpaceBetween(title: 'Base rate', description: '₹ 1,200'),
        ElementSpaceBetween(
            title: '60 days × 12 hours rate', description: '₹ 72,000'),
        ElementSpaceBetween(title: 'Other', description: '₹ 2,000'),
        const Divider(
          color: AppColors.line,
        ),
        ElementSpaceBetween(
          title: 'Total to pay',
          description: '₹ 75,400',
          isTitleBold: true,
        ),
      ],
    );
  }
}
