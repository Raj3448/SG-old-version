import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/app_bar.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/feature/main/repo/main_repo.dart';
import 'package:silver_genie/feature/members/model/member_model.dart';
import 'package:silver_genie/feature/members/repo/member_repo.dart';
import 'package:silver_genie/feature/members/store/members_store.dart';
import 'package:silver_genie/feature/members/widgets/member_card.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({required this.membersService, super.key});

  final IMembersService membersService;

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  final store = GetIt.I<MembersStore>();

  late Future<List<Member>> _memberData;

  @override
  void initState() {
    super.initState();
    _memberData = widget.membersService.getMembers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Appbar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              FutureBuilder(
                // future: fetchMembers(),
                future: _memberData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    // TODO(Amanjot): update this with the new error screens.
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final members = snapshot.data!;
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          Text(
                            'Your Family Members'.tr(),
                            style: AppTextStyle.bodyLargeBold.copyWith(
                              height: 1.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: members.length,
                            itemBuilder: (context, index) {
                              final member = members[index];
                              return GestureDetector(
                                onTap: () {
                                  final hasCareSub =
                                      member.hasCareSub ? 'true' : 'false';

                                  GoRouter.of(context).pushNamed(
                                    RoutesConstants.memberDetailsRoute,
                                    pathParameters: {
                                      'name': member.name,
                                      'age': member.age,
                                      'gender': member.gender,
                                      'relation': member.relation,
                                      'mobileNo': member.mobileNo,
                                      'address': member.address,
                                      'hasCareSub': hasCareSub,
                                    },
                                  );
                                },
                                child: MemberCard(
                                  name: member.name,
                                  relation: member.relation,
                                  hasCareSub: member.hasCareSub,
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(height: 12);
                            },
                          ),
                          const SizedBox(height: 24),
                          CustomButton(
                            ontap: () {
                              GoRouter.of(context).pushNamed(
                                RoutesConstants.addEditFamilyMemberRoute,
                                pathParameters: {'edit': 'false'},
                              );
                            },
                            title: 'Add new member',
                            showIcon: false,
                            iconPath: AppIcons.add,
                            size: ButtonSize.normal,
                            type: ButtonType.primary,
                            expanded: true,
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
