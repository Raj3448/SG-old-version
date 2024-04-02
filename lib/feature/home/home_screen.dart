import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/widgets/active_plan.dart';
import 'package:silver_genie/core/widgets/app_bar.dart';
import 'package:silver_genie/core/widgets/avatar.dart';
import 'package:silver_genie/core/widgets/coach_contact.dart';
import 'package:silver_genie/core/widgets/inactive_plan.dart';
import 'package:silver_genie/feature/home/store/home_store.dart';
import 'package:silver_genie/feature/members/screens/add_edit_family_member_screen.dart';
import 'package:silver_genie/feature/members/screens/epr_phr_view_screen.dart';

class HomeBody extends StatelessWidget {
  final HomeScreenStore store;

  const HomeBody({required this.store});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                Observer(
                  builder: (_) => SelectableAvatar(
                    imgPath: '',
                    maxRadius: 24,
                    isSelected: store.isAvatar1Selected,
                    ontap: store.selectAvatar1,
                  ),
                ),
                SizedBox(width: Dimension.d4),
                Observer(
                  builder: (_) => SelectableAvatar(
                    imgPath: '',
                    maxRadius: 24,
                    isSelected: !store.isAvatar1Selected,
                    ontap: store.selectAvatar2,
                  ),
                ),
                SizedBox(
                  width: Dimension.d4,
                ),
                SelectableAvatar(
                  imgPath: 'assets/icon/44Px.png',
                  maxRadius: 24,
                  isSelected: false,
                  ontap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddEditFamilyMemberScreen(
                          edit: false,
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
            SizedBox(height: Dimension.d4),
            Observer(
              builder: (_) {
                if (store.isAvatar1Selected)
                  return ActivePlanComponent(
                    name: 'Varun Nair',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EPRPHRViewScreen(),
                        ),
                      );
                    },
                  );
                else
                  return InactivePlanComponent(
                    name: 'Shalini Nair',
                  );
              },
            ),
            SizedBox(height: Dimension.d4),
            Observer(
              builder: (_) {
                if (store.isAvatar1Selected)
                  return CoachContact(imgpath: '', name: 'Suma Latha');
                else
                  return SizedBox(); 
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final HomeScreenStore store = HomeScreenStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(),
      body: HomeBody(store: store),
    );
  }
}
