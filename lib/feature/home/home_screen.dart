import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/widgets/active_plan.dart';
import 'package:silver_genie/core/widgets/app_bar.dart';
import 'package:silver_genie/core/widgets/avatar.dart';
import 'package:silver_genie/core/widgets/coach_contact.dart';
import 'package:silver_genie/core/widgets/inactive_plan.dart';
import 'package:silver_genie/feature/members/screens/add_edit_family_member_screen.dart';
import 'package:silver_genie/feature/members/screens/epr_phr_view_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isAvatar1Selected = false;

  void selectAvatar1() {
    setState(() {
      isAvatar1Selected = true;
    });
  }

  void selectAvatar2() {
    setState(() {
      isAvatar1Selected = false;
    });
  }

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
              SizedBox(height: Dimension.d4),
              Row(
                children: [
                  SelectableAvatar(
                    imgPath: '',
                    maxRadius: 44,
                    isSelected: isAvatar1Selected,
                    ontap: selectAvatar1,
                  ),
                  SizedBox(width: Dimension.d4),
                  SelectableAvatar(
                    imgPath: '',
                    maxRadius: 44,
                    isSelected: !isAvatar1Selected,
                    ontap: selectAvatar2,
                  ),
                  SizedBox(
                    width: Dimension.d4,
                  ),
                  SelectableAvatar(imgPath: 'assets/icon/44Px.png', maxRadius: 44, isSelected:false, ontap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddEditFamilyMemberScreen(
                          edit: false,
                        )
                      ),
                    );
                  })
                ],
              ),
              SizedBox(height: Dimension.d4),
              if (isAvatar1Selected)
                ActivePlanComponent(
                  name: 'Varun Nair',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EPRPHRViewScreen(),
                      ),
                    );
                  },
                )
              else
                InactivePlanComponent(
                  name: 'Shalini Nair',
                ),
              SizedBox(height: Dimension.d4),
              if (isAvatar1Selected)
                CoachContact(imgpath: '', name: 'Suma Latha'),
            ],
          ),
        ),
      ),
    );
  }
}
