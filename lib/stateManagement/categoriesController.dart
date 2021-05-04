
import 'package:final_year_project/models/category.dart';
import 'package:final_year_project/services/apiServices.dart';
import 'package:get/get.dart';

class CategoriesController extends GetxController {
  var isLoading = true.obs;
  var searhtag = ''.toString();
  // ignore: unnecessary_cast
  var categoriesList = <Categories>[].obs as List<Categories>;

  @override
  void onInit() {
    getCategories();
    super.onInit();
  }

  void getCategories() async {
    isLoading(true);
    try {
      var list = await ApiServices.getCategiesData();
      if (list != null) {
        categoriesList = list;
      }
    } finally {
      isLoading(false);
    }
  }
}
