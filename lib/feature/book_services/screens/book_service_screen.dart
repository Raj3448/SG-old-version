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
  const BookServiceScreen(
      {required this.productCode, required this.id, super.key});
  final String productCode;
  final String id;

  @override
  State<BookServiceScreen> createState() => _BookServiceScreenState();
}

class _BookServiceScreenState extends State<BookServiceScreen>
    with AutomaticKeepAliveClientMixin<BookServiceScreen> {
  final TextEditingController dobContr = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<CustomDropDownBoxState> _customDropDownBoxKey =
      GlobalKey<CustomDropDownBoxState>();
  List<FormAnswer> formAnswers = [];
  Member? selectedMember;
  final service = GetIt.I<ProductListingServices>();
  final store = GetIt.I<ProductListingStore>();

  @override
  bool get wantKeepAlive => true;

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
    reaction((_) => store.servicePaymentInfoGotSuccess,
        (servicePaymentInfoGotSuccess) {
      if (servicePaymentInfoGotSuccess != null) {
        context.pushNamed(RoutesConstants.bookingPaymentDetailScreen,
            extra: {'paymentDetails': servicePaymentInfoGotSuccess});
      }
      store.servicePaymentInfoGotSuccess = null;
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
    super.build(context);
    return Observer(
      builder: (_) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: AppColors.white,
              appBar: const PageAppbar(title: 'Book Service'),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: FixedButton(
                ontap: () {
                  _submitAndNext(context);
                },
                btnTitle: 'Submit & next',
                showIcon: false,
                iconPath: AppIcons.add,
              ),
              body: FutureBuilder(
                future: service.getBookingServiceDetailsById(
                    productCode: widget.productCode),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      !store.isBuyServiceLoading) {
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
                  final widgetList = <Widget>[];
                  final components = formDetailModel.attributes.productForm;
                  for (var i = 0;
                      i < components.data.attributes.form.length;
                      i++) {
                    final component = components.data.attributes.form[i];
                    switch (component.component) {
                      case 'form-field-type.reference-question':
                        if (component.controlType == 'familyDropDown') {
                          widgetList.addAll([
                            const SizedBox(height: Dimension.d4),
                            if (component.formDetails.required)
                              AsteriskLabel(
                                  label:
                                      '${i + 1}. ${component.formDetails.title}'),
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
                              memberList: GetIt.I<MembersStore>().familyMembers,
                              placeHolder: component.formDetails.placeholder,
                              updateMember: (member) {
                                selectedMember = member;
                                _updateFormValues1(
                                    id: component.id,
                                    title: component.formDetails.title,
                                    type: component.type,
                                    controlType: component.controlType,
                                    hint: component.formDetails.hint,
                                    valueReference: [
                                      member?.id.toString() ?? ''
                                    ],
                                    forDId:
                                        component.formDetails.id.toString());
                              },
                              isRequired: component.formDetails.required,
                            )
                          ]);
                        }
                        break;
                      case 'form-field-type.text-question':
                        if (component.type == 'text') {
                          widgetList.addAll([
                            const SizedBox(height: Dimension.d4),
                            if (component.formDetails.required)
                              AsteriskLabel(
                                  label:
                                      '${i + 1}. ${component.formDetails.title}'),
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
                                    valueText: value?.trim(),
                                    controlType: component.controlType,
                                    hint: component.formDetails.hint,
                                    forDId:
                                        component.formDetails.id.toString());
                              },
                              hintText: component.formDetails.placeholder ??
                                  'Type here',
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
                                  label:
                                      '${i + 1}. ${component.formDetails.title}'),
                            if (!component.formDetails.required)
                              Text(
                                '${i + 1}. ${component.formDetails.title}',
                                style: AppTextStyle.bodyMediumMedium
                                    .copyWith(color: AppColors.grayscale700),
                              ),
                            const SizedBox(height: Dimension.d2),
                            MultiSelectFormField(
                              showClear: !component.formDetails.required,
                              hint: component.formDetails.placeholder,
                              onSaved: (newValue) {
                                _updateFormValues1(
                                    id: component.id,
                                    title: component.formDetails.title,
                                    type: component.type,
                                    valueChoice: [
                                      newValue!.first.value.toString().trim()
                                    ],
                                    controlType: component.controlType,
                                    hint: component.formDetails.hint,
                                    forDId:
                                        component.formDetails.id.toString());
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
                                  label:
                                      '${i + 1}. ${component.formDetails.title}'),
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
                                    valueDate: value.toString(),
                                    controlType: component.controlType,
                                    hint: component.formDetails.hint,
                                    forDId:
                                        component.formDetails.id.toString());
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
                      case 'form-field-type.integer-question':
                        if (component.type == 'integer') {
                          widgetList.addAll([
                            const SizedBox(height: Dimension.d4),
                            if (component.formDetails.required)
                              AsteriskLabel(
                                  label:
                                      '${i + 1}. ${component.formDetails.title}'),
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
                                      if (int.tryParse(value) == null) {
                                        return '${component.formDetails.title} must be an integer';
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
                                    valueInteger: value?.trim(),
                                    controlType: component.controlType,
                                    hint: component.formDetails.hint,
                                    forDId:
                                        component.formDetails.id.toString());
                              },
                              hintText: component.formDetails.placeholder ??
                                  'Type here',
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimension.d4),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const BookingStatus(
                                currentStep: BookingStep.serviceDetails,
                              ),
                              ...widgetList,
                              const SizedBox(height: Dimension.d20),
                              const SizedBox(height: Dimension.d4),
                            ],
                          ),
                        ),
                      ));
                },
              ),
            ),
            if (store.isBuyServiceLoading)
              const Material(
                color: Colors.transparent,
                child: LoadingWidget(),
              )
          ],
        );
      },
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
    List<String>? valueChoice,
    String? valueInteger,
    String? valueDate,
    String? valueText,
    String? controlType,
    required String? hint,
    List<String>? valueReference,
    required String forDId,
  }) {
    final existingIndex =
        formAnswers.indexWhere((element) => element.forDId == forDId);

    if (existingIndex >= 0) {
      formAnswers[existingIndex] = FormAnswer(
          questionId: id,
          question: title,
          type: type,
          valueChoice: valueChoice,
          controlType: controlType,
          hint: hint,
          valueReference: valueReference,
          forDId: forDId,
          valueDate: valueDate,
          valueInteger: valueInteger,
          valueText: valueText);
    } else {
      formAnswers.add(FormAnswer(
          questionId: id,
          question: title,
          type: type,
          valueChoice: valueChoice,
          controlType: controlType,
          hint: hint,
          valueReference: valueReference,
          forDId: forDId,
          valueDate: valueDate,
          valueInteger: valueInteger,
          valueText: valueText));
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
    print(formAnswerModel.toJson());
    store.buyService(formData: formAnswerModel);
  }
}
