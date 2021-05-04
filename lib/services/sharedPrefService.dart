import 'package:shared_preferences/shared_preferences.dart';
import 'package:final_year_project/stateManagement/providers/authState.dart';
import 'package:final_year_project/stateManagement/providers/currentuserState.dart';

class SharePrefService {
  SharedPreferences prefs;
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
  getcurrentUserIdFromSp(CurrentUserIdState idState) async {
    prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('currentUserId');
    
    idState.currentUserId = id;
   // print(idState.currentUserId);
  }
}
