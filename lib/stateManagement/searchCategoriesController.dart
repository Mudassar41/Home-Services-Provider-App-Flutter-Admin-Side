import 'package:final_year_project/models/category.dart';
import 'package:final_year_project/services/apiServices.dart';
import 'package:get/get.dart';

class SearchCategoriescontroller extends GetxController {
  var searhtag = ''.obs;
  var isLoading = true.obs;
  var categoriesList = <Categories>[].obs as List<Categories>;
  var tempcategoriesList = <Categories>[].obs as List<Categories>;


@override
  void refresh() {
    // TODO: implement refresh
    super.refresh();
  //  getCategories();
    fetchCategories(searhtag.value);
  }


  void fetchCategories(String tag) async {
    isLoading(true);
    try {
      var list = await ApiServices.searchCategiesData(tag);
      if (list != null) {
        categoriesList = list;
      }
    } finally {
      isLoading(false);
    }
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
