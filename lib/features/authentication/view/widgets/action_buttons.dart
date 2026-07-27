import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:postly/features/authentication/view/widgets/linkedIN_button.dart';
import 'package:postly/features/authentication/viewmodel/sign_in_viewmodel.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key, required SignInViewmodel vm}) : _vm = vm;

  final SignInViewmodel _vm;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LinkedInButton(
        isLoading: _vm.isLoading.value,
        onTap: _vm.linkedINTapped,
      ),
    );
  }
}
