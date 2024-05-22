import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:silver_genie/core/widgets/error_state_component.dart';
import 'package:silver_genie/core/widgets/loading_widget.dart';
import 'package:silver_genie/feature/home/store/home_store.dart';

class SplashscreenWidget extends StatefulWidget {
  const SplashscreenWidget({super.key});

  @override
  State<SplashscreenWidget> createState() => _SplashscreenWidgetState();
}

class _SplashscreenWidgetState extends State<SplashscreenWidget> {
  final store = GetIt.I<HomeStore>();
  @override
  void initState() {
    super.initState();
    reaction((_) => store.isHomepageDataLoaded, (loaded) {
      if (store.isHomepageDataLoaded) {
        GoRouter.of(context).goNamed('/');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Observer(builder: (ctx) {
          return store.isHomepageComponentInitialloading ||
                  store.isHomepageDataLoaded
              ? const LoadingWidget()
              : const ErrorStateComponent(
                  errorType: ErrorType.somethinWentWrong,
                );
        }),
      ),
    );
  }
}
