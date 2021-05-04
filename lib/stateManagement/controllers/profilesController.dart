import 'package:final_year_project/models/profile.dart';
import 'package:final_year_project/services/apiServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ProviderProfilesController extends GetxController {
  var isLoading = true.obs;
  var profilesList = <ProfileModel>[].obs as List<ProfileModel>;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getProfilesData();
  }

  void getProfilesData() async {
    dynamic currentUid;
    FirebaseAuth auth = FirebaseAuth.instance;

    if (auth.currentUser != null) {
      print(auth.currentUser.uid);
      currentUid = auth.currentUser.uid;
    }
    isLoading(true);
    try {
      var list = await ApiServices.getProvidersprofileData(currentUid);
      if (list != null) {
        profilesList = list;
      }
    } finally {
      isLoading(false);
    }
  }
}
