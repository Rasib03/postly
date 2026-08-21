import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:postly/app/route_names.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final token = GetStorage().read<String>('linkedin_access_token');
    if (token != null && token.isNotEmpty) {
      return const RouteSettings(name: Routes.home);
    }
    return null;
  }
}
