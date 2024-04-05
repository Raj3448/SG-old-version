import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/active_plan.dart';
import 'package:silver_genie/core/widgets/app_bar.dart';
import 'package:silver_genie/core/widgets/avatar.dart';
import 'package:silver_genie/core/widgets/coach_contact.dart';
import 'package:silver_genie/feature/members/screens/epr_phr_view_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Appbar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(Dimension.d4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Family Members health info',
                  style: AppTextStyle.bodyXLSemiBold,
                ),
                SizedBox(
                  height: Dimension.d4,
                ),
                Row(
                  children: [
                    SelectableAvatar(
                      imgPath: '',
                      maxRadius: 44,
                      isSelected: true,
                      ontap: () {
                        ActivePlanComponent(
                            name: 'Varun Nair',
                            onTap: () {
                              Navigator.push(
                                context,
                                // ignore: inference_failure_on_instance_creation
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const EPRPHRViewScreen(),
                                ),
                              );
                            });
                      },
                    ),
                    SizedBox(
                      width: Dimension.d4,
                    ),
                    SelectableAvatar(
                        imgPath: '',
                        maxRadius: 44,
                        isSelected: false,
                        ontap: () {})
                  ],
                ),
                SizedBox(
                  height: Dimension.d4,
                ),

                //TODO:
                // InactivePlanComponent(
                //   name: 'Shalini Nair',
                // ),
                SizedBox(
                  height: Dimension.d4,
                ),
                GestureDetector(
                    onTap: () {
                      context.pushNamed(RoutesConstants.emergencyServiceScreen);
                    },
                    child: CoachContact(imgpath: '', name: 'Suma Latha'))
              ],
            ),
          ),
        ));
  }
}
