import 'package:get/get.dart';

class PrescribeContoller extends GetxController {
  RxList prescriptionlist = [].obs;

  void updatelist(prescribtion) {
    prescriptionlist.add(prescribtion.toMap());
    update();
  }

  void editlist(data) {
    prescriptionlist.addAll(data);
  }
}
