import 'package:mobx/mobx.dart';
import 'package:silver_genie/feature/emergency_services/model/emergency_service_model.dart';
part 'emergency_service_store.g.dart';

class EmergencyServiceStore = _EmergencyServiceStoreBase
    with _$EmergencyServiceStore;

abstract class _EmergencyServiceStoreBase with Store {
  @observable
  EmergencyServiceModel emergencyServiceModel = const EmergencyServiceModel(
      defination:
          "Life\'s unpredictability won \'t affect your well-being. Our comprehensive emergency support ensures holistic care. From sickness to health, we promise to deliver.",
      support: Support(
          preparedness:
              "To set up your emergency protocols, we will create an Emergency Preparedness Form with details we receive from you, so that we can help you and your loved ones during an emergency, without losing any time.",
          hospital:
              "Contacting and coordinating with either a General Physician or the preferred hospital, insurance providers, and family members. Also, arranging for hospital admission money if needed.",
          postDischarge:
              "Arranging and ensuring a well-equipped ambulance reaches your location, along with constant call support, throughout the way to the hospital.",
          healthMonitor:
              "Constant health monitoring and checking in with the patient, and keeping family members cognizant and aligned with your health and needs.",
          genieCare:
              "Our Genie will take care of everything - from contacting your family members and insurance providers, arranging and coordinating with ambulance, hospital, and General Physician, and support during and post-emergency."),
      plans: <Plan>[
        Plan(
            title: "Basic",
            duration: "Yearly",
            descrip: "Including all tax if there is more text",
            amount: 18000,
            discountamount: 14000),
        Plan(
            title: "Premium",
            duration: "6 Months",
            descrip: "Including all tax if there is more text",
            amount: 7689,
            discountamount: 3500),
        Plan(
            title: "Standard",
            duration: "1 Months",
            descrip: "Including all tax if there is more text",
            amount: 3500,
            discountamount: 2677)
      ], plansDescription: 'Silvergenie ensures your safety with emergency preparedness forms, ambulance services, and Genie Care support. Our SOS app and speed dial feature offer immediate assistance, making your well-being our priority.');
}
