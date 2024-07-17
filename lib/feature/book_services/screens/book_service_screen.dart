// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
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
import 'package:silver_genie/feature/book_services/widgets/booking_status.dart';
import 'package:silver_genie/feature/genie/services/product_listing_services.dart';
import 'package:silver_genie/feature/genie/store/product_listing_store.dart';
import 'package:silver_genie/feature/members/model/member_model.dart';
import 'package:silver_genie/feature/members/store/members_store.dart';

class BookServiceScreen extends StatefulWidget {
  const BookServiceScreen({
    required this.productCode,
    required this.id,
    super.key,
  });
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
            duration: const Duration(seconds: 5),
          ),
        );
      }
      store.buyServiceFailed = null;
    });
    reaction((_) => store.servicePaymentInfoGotSuccess,
        (servicePaymentInfoGotSuccess) {
      if (servicePaymentInfoGotSuccess != null) {
        context.pushNamed(
          RoutesConstants.serviceBookingPaymentDetailScreen,
          extra: {'paymentDetails': servicePaymentInfoGotSuccess},
        );
      }
      store.servicePaymentInfoGotSuccess = null;
    });
    super.initState();
  }

  List<Map<String, dynamic>> _controllers = [];
  @override
  void dispose() {
    store
      ..servicePaymentInfoGotSuccess = null
      ..servicePaymentStatusModel = null;
    dobContr.dispose();
    for (final controller in _controllers) {
      for (final element in controller.values) {
        if (element is MultiSelectController) {
          element.dispose();
        } else {
          element.clear();
        }
      }
    }
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
              appBar: PageAppbar(title: 'Book Service'.tr()),
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
                  productCode: widget.productCode,
                ),
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
                      errorType: ErrorType.somethinWentWrong,
                    );
                  }
                  late FormDetailModel formDetailModel;
                  snapshot.data!.getRight().fold(
                        () => const ErrorStateComponent(
                          errorType: ErrorType.somethinWentWrong,
                        ),
                        (t) => formDetailModel = t,
                      );
                  final widgetList = <Widget>[];
                  final components = formDetailModel.attributes.productForm;
                  int order = 0;
                  for (var i = 0;
                      i < components.data.attributes.form.length;
                      i++) {
                    final component = components.data.attributes.form[i];
                    switch (component.component) {
                      case 'form-field-type.reference-question':
                        if (component.controlType == 'familyDropDown') {
                          order++;
                          widgetList.addAll([
                            const SizedBox(height: Dimension.d4),
                            if (component.formDetails.required)
                              AsteriskLabel(
                                label: '$order. ${component.formDetails.title}',
                              ),
                            if (!component.formDetails.required)
                              Text(
                                '$order. ${component.formDetails.title}',
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
                                    '${member?.id.toString()}' ?? '',
                                  ],
                                  forDId: component.formDetails.id.toString(),
                                );
                              },
                              canBookPlan: false,
                              isRequired: component.formDetails.required,
                            ),
                          ]);
                        }
                        break;
                      case 'form-field-type.text-question':
                        if (component.type == 'text') {
                          order++;
                          final TextEditingController controller =
                              TextEditingController();
                          _controllers
                              .add({component.formDetails.title: controller});
                          widgetList.addAll([
                            const SizedBox(height: Dimension.d4),
                            if (component.formDetails.required)
                              AsteriskLabel(
                                label: '$order. ${component.formDetails.title}',
                              ),
                            if (!component.formDetails.required)
                              Text(
                                '$order. ${component.formDetails.title}',
                                style: AppTextStyle.bodyMediumMedium
                                    .copyWith(color: AppColors.grayscale700),
                              ),
                            const SizedBox(height: Dimension.d2),
                            CustomTextField(
                              controller: _controllers.firstWhere(
                                (element) => element
                                    .containsKey(component.formDetails.title),
                              )[component.formDetails.title]
                                  as TextEditingController,
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
                                  forDId: component.formDetails.id.toString(),
                                );
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
                          order++;
                          final controller = MultiSelectController<dynamic>();
                          _controllers
                              .add({component.formDetails.title: controller});
                          final values = List.generate(
                            component.options.length,
                            (index) => ValueItem(
                              label: component.options[index].display,
                              value: component.options[index].value,
                            ),
                          );
                          widgetList.addAll([
                            const SizedBox(height: Dimension.d4),
                            if (component.formDetails.required)
                              AsteriskLabel(
                                label: '$order. ${component.formDetails.title}',
                              ),
                            if (!component.formDetails.required)
                              Text(
                                '$order. ${component.formDetails.title}',
                                style: AppTextStyle.bodyMediumMedium
                                    .copyWith(color: AppColors.grayscale700),
                              ),
                            const SizedBox(height: Dimension.d2),
                            MultiSelectFormField(
                              controller: controller,
                              selectedOptions: formAnswers
                                      .where(
                                        (element) =>
                                            element.question ==
                                            component.formDetails.title,
                                      )
                                      .toList()
                                      .isEmpty
                                  ? null
                                  : values
                                      .where(
                                        (element) =>
                                            element.value ==
                                            formAnswers
                                                .where(
                                                  (element) =>
                                                      element.question ==
                                                      component
                                                          .formDetails.title,
                                                )
                                                .toList()
                                                .first
                                                .valueChoice
                                                ?.first,
                                      )
                                      .toList(),
                              showClear: !component.formDetails.required,
                              hint: component.formDetails.placeholder,
                              onSaved: (newValue) {
                                _updateFormValues1(
                                  id: component.id,
                                  title: component.formDetails.title,
                                  type: component.type,
                                  valueChoice: [
                                    '${newValue!.first.value.toString().trim()}',
                                  ],
                                  controlType: component.controlType,
                                  hint: component.formDetails.hint,
                                  forDId: component.formDetails.id.toString(),
                                );
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
                              values: values,
                            ),
                          ]);
                        }
                        break;
                      case 'form-field-type.date-question':
                        if (component.type == 'date') {
                          order++;
                          widgetList.addAll([
                            const SizedBox(height: Dimension.d4),
                            if (component.formDetails.required)
                              AsteriskLabel(
                                label: '$order. ${component.formDetails.title}',
                              ),
                            if (!component.formDetails.required)
                              Text(
                                '$order. ${component.formDetails.title}',
                                style: AppTextStyle.bodyMediumMedium
                                    .copyWith(color: AppColors.grayscale700),
                              ),
                            const SizedBox(height: Dimension.d2),
                            DateDropdown(
                              controller: dobContr,
                              dateFormat: component.dateFormat,
                              futureDates: true,
                              onSaved: (value) {
                                _updateFormValues1(
                                  id: component.id,
                                  title: component.formDetails.title,
                                  type: component.type,
                                  valueDate: value.toString(),
                                  controlType: component.controlType,
                                  hint: component.formDetails.hint,
                                  forDId: component.formDetails.id.toString(),
                                );
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
                          order++;
                          final controller = TextEditingController(
                              text: component.defaultValue.toString());
                          _controllers
                              .add({component.formDetails.title: controller});
                          widgetList.addAll([
                            const SizedBox(height: Dimension.d4),
                            if (component.formDetails.required)
                              AsteriskLabel(
                                label: '$order. ${component.formDetails.title}',
                              ),
                            if (!component.formDetails.required)
                              Text(
                                '$order. ${component.formDetails.title}',
                                style: AppTextStyle.bodyMediumMedium
                                    .copyWith(color: AppColors.grayscale700),
                              ),
                            const SizedBox(height: Dimension.d2),
                            CustomTextField(
                              controller: _controllers.firstWhere(
                                (element) => element
                                    .containsKey(component.formDetails.title),
                              )[component.formDetails.title]
                                  as TextEditingController,
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
                                        isNum: true,
                                      );
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
                                  forDId: component.formDetails.id.toString(),
                                );
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
                        horizontal: Dimension.d4,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: Dimension.d4),
                            const BookingStatus(
                              currentStep: BookingStep.serviceDetails,
                            ),
                            ...widgetList,
                            const SizedBox(height: Dimension.d20),
                            const SizedBox(height: Dimension.d4),
                            const SizedBox(height: Dimension.d15),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (store.isBuyServiceLoading)
              const Material(
                color: Colors.transparent,
                child: LoadingWidget(),
              ),
          ],
        );
      },
    );
  }

  String? applyValidations({
    String? value,
    required List<Validations> validations,
    bool isNum = false,
  }) {
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
        valueText: valueText,
      );
    } else {
      formAnswers.add(
        FormAnswer(
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
          valueText: valueText,
        ),
      );
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
      formAnswer: formAnswers,
      productId: int.parse(widget.id),
    );
    store.buyService(formData: formAnswerModel);
  }
}
