import 'package:final_year_project/stateManagement/controllers/profilesController.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:final_year_project/stateManagement/providers/authState.dart';
import 'package:final_year_project/stateManagement/providers/currentuserState.dart';

class SharePrefService {
  SharedPreferences prefs;
  ProviderProfilesController controller=Get.put(ProviderProfilesController());

  addBoolToSp() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setBool('boolValue', true);
  }

  getBoolSp(AuthState authState) async {
    prefs = await SharedPreferences.getInstance();
    bool boolValue = prefs.getBool('boolValue');
    if (boolValue == null) {
      authState.loggedUser = false;
    }
    //print('bool valur is ${boolValue}');
    else {
      authState.loggedUser = boolValue;
      
    }
  }

  updateBoolSp() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setBool('boolValue', false);
  }

  addCurrentuserToSf(String id) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('currentUserId', id);
  }
 logOutCurrentuserSf() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('currentUserId', 'log out');
  }
  getcurrentUserIdFromSp() async {
    prefs = await SharedPreferences.getInstance();
    String Id = prefs.getString('currentUserId');
    controller.id.value=Id;
    print('id is ${controller.id.value}');
    controller.update();
  //  idState.currentUserId = Id;
   // print(idState.currentUserId);
  }
}
