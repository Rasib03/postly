import 'package:get/get.dart';
import 'package:postly/features/home/model/ai_draft.dart';
import 'package:postly/features/review_edit/viewmodel/review_edit_viewmodel.dart';

class ReviewEditBinding extends Bindings {
  @override
  void dependencies() {
    final draft = Get.arguments as AiDraft;
    Get.put<ReviewEditViewmodel>(ReviewEditViewmodel(draft: draft));
  }
}
