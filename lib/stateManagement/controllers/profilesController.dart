import 'package:final_year_project/models/profile.dart';
import 'package:final_year_project/services/apiServices.dart';
import 'package:get/state_manager.dart';

class ProviderProfilesController extends GetxController {
  var id = ''.obs;
  var isLoading = true.obs;
  var profilesList = <ProfileModel>[].obs;
  @override
  void onInit() {
    super.onInit();
    getProfilesData();
  }

  Future<List<ProfileModel>> getProfilesData() async {
    isLoading(true);
    try {
      var list = await ApiServices.getProvidersprofileData();
      if (list != null) {
        profilesList.addAll(list);
         
      }
    } finally {
      isLoading(false);
    }
    
   return profilesList;
   
  }
//  @override
//   void refresh() {
//     // TODO: implement refresh
//     super.refresh();
//     getProfilesData();
//   }
@override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
     
     profilesList.clear();
  }
}
