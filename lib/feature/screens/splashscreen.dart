import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:silver_genie/core/utils/custom_tuple.dart';
import 'package:silver_genie/core/widgets/error_state_component.dart';
import 'package:silver_genie/core/widgets/loading_widget.dart';
import 'package:silver_genie/feature/auth/auth_store.dart';
import 'package:silver_genie/feature/genie/store/product_listing_store.dart';
import 'package:silver_genie/feature/home/store/home_store.dart';
import 'package:silver_genie/feature/user_profile/store/user_details_store.dart';

class SplashscreenWidget extends StatefulWidget {
  const SplashscreenWidget({super.key, this.redirectRouteName});

  final String? redirectRouteName;

  @override
  State<SplashscreenWidget> createState() => _SplashscreenWidgetState();
}

class _SplashscreenWidgetState extends State<SplashscreenWidget> {
  final homeStore = GetIt.I<HomeStore>();
  final authStore = GetIt.I<AuthStore>();
  final productStore = GetIt.I<ProductListingStore>();

  late ReactionDisposer _reactionDisposer;

  @override
  void initState() {
    super.initState();
    _reactionDisposer = reaction(
      (_) => Tuple3(
        homeStore.isHomepageDataLoaded,
        authStore.isAuthenticated,
        productStore.isProductLoaded,
      ),
      (Tuple3<bool, bool, bool> loaded) async {
        final isHomepageDataLoaded = loaded.item1;
        final isAuthenticated = loaded.item2;

        if (isAuthenticated) {
          await GetIt.I<UserDetailStore>().fetchUserDetailsFromCache();
        }

        if (isHomepageDataLoaded && mounted) {
          context.goNamed(
            '/',
            queryParameters: {'redirectRouteName': widget.redirectRouteName},
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _reactionDisposer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Observer(
        builder: (ctx) {
          return homeStore.isHomepageComponentInitialloading ||
                  homeStore.isHomepageDataLoaded ||
                  productStore.fetchProductLoading
              ? const LoadingWidget()
              : const ErrorStateComponent(
                  errorType: ErrorType.somethinWentWrong,
                );
        },
      ),
    );
  }
}
