// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/active_plan.dart';
import 'package:silver_genie/core/widgets/app_bar.dart';
import 'package:silver_genie/core/widgets/avatar.dart';
import 'package:silver_genie/core/widgets/coach_contact.dart';
import 'package:silver_genie/core/widgets/inactive_plan.dart';
import 'package:silver_genie/feature/home/store/home_store.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({required this.store, super.key});
  final HomeScreenStore store;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(Dimension.d4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Family Members health info',
              style: AppTextStyle.bodyXLSemiBold,
            ),
            const SizedBox(height: Dimension.d4),
            Observer(
              builder: (_) {
                return Column(
                  children: [
                    Row(
                      children: [
                        for (var i = 0; i < store.familyMembers.length; i++)
                          Row(
                            children: [
                              SelectableAvatar(
                                imgPath: store.familyMembers[i].imagePath,
                                maxRadius: 24,
                                isSelected: store.selectedIndex == i,
                                ontap: () => store.selectAvatar(i),
                              ),
                              const SizedBox(width: Dimension.d4),
                            ],
                          ),
                        SelectableAvatar(
                          imgPath: 'assets/icon/44Px.png',
                          maxRadius: 24,
                          isSelected: false,
                          ontap: () {
                            context.pushNamed(
                              RoutesConstants.addEditFamilyMemberRoute,
                              pathParameters: {'edit': 'true'},
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimension.d4),
                    if (store.selectedIndex != -1)
                      Observer(
                        builder: (_) {
                          final selectedMember =
                              store.familyMembers[store.selectedIndex];
                          return selectedMember != null
                              ? selectedMember.isActive
                                  ? ActivePlanComponent(
                                      name: selectedMember.name,
                                      onTap: () {
                                        context.pushNamed(
                                          RoutesConstants.eprPhrRoute,
                                        );
                                      },
                                    )
                                  : InactivePlanComponent(
                                      name: selectedMember.name,
                                    )
                              : const SizedBox();
                        },
                      ),
                    const SizedBox(height: Dimension.d4),
                    if (store.selectedIndex != -1)
                      Observer(
                        builder: (_) {
                          final selectedMember =
                              store.familyMembers[store.selectedIndex];
                          return selectedMember != null &&
                                  selectedMember.isActive
                              ? const CoachContact(
                                  imgpath: '',
                                  name: 'Suma Latha',
                                )
                              : const SizedBox();
                        },
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeScreenStore store = HomeScreenStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Appbar(),
      body: HomeBody(store: store),
    );
  }
}
