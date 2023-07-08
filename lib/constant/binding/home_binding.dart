import 'package:get/get.dart';
import 'package:mytask/controller/home_controller.dart';

class HomeBinding implements Bindings{
  @override
  void dependencies() {
  Get.put(HomeController(),permanent: true);
  }

}