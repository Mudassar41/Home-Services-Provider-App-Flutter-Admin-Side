import 'package:final_year_project/stateManagement/athenticationProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthStateService {


  Future<User> checkUser(AuthProvider authProvider) {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
       // print('User is currently signed out!');
        return authProvider.user = user;
      } else {
        //print('User is signed in!');
        return authProvider.user = user;
      }
    });
    // return authProvider.user;
  }
}
