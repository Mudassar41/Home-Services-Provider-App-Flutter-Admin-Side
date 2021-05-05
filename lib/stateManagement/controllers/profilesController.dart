import 'package:final_year_project/models/profile.dart';
import 'package:final_year_project/services/apiServices.dart';
import 'package:get/get.dart';

class ProviderProfilesController extends GetxController {
  var id = ''.obs;
  var isLoading = true.obs;
  var profilesList = <ProfileModel>[].obs as List<ProfileModel>;

  @override
  void refresh() {
    // TODO: implement refresh
    super.refresh();
    getProfilesData(id.value);
  }

  void getProfilesData(String id) async {
    isLoading(true);
    try {
      var list = await ApiServices.getProvidersprofileData(id);
      if (list != null) {
        profilesList = list;
      }
    } finally {
      isLoading(false);
    }
  }
}
