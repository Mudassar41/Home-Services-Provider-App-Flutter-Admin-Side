import 'package:final_year_project/reusableComponents/customColors.dart';
import 'package:final_year_project/stateManagement/athenticationProvider.dart';
import 'package:final_year_project/stateManagement/phoneAuthProvider.dart';
import 'package:final_year_project/reusableComponents/lodingbar.dart';
import 'package:final_year_project/screens/loginScreen.dart';
import 'package:final_year_project/reusableComponents/sizing.dart';
import 'package:final_year_project/screens/BottonNavPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:final_year_project/stateManagement/databaseProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:final_year_project/stateManagement/providers/authState.dart';
import 'package:final_year_project/stateManagement/providers/currentuserState.dart';
import 'package:final_year_project/services/sharedPrefService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.light,
    statusBarColor: CustomColors.lightGreen, // status bar color
  ));
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<PhoneAuthProvidr>(
        create: (BuildContext context) {
          return PhoneAuthProvidr();
        },
      ),
      ChangeNotifierProvider<AuthProvider>(
        create: (BuildContext context) {
          return AuthProvider();
        },
      ),
       ChangeNotifierProvider<CurrentUserIdState>(
        create: (BuildContext context) {
          return CurrentUserIdState();
        },
      ),
       ChangeNotifierProvider<AuthState>(
        create: (BuildContext context) {
          return AuthState();
        },
      ),
      ChangeNotifierProvider<DataBaseProvider>(
        create: (BuildContext context) {
          return DataBaseProvider();
        },
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  AuthState authState;
  SharePrefService sharePrefService = SharePrefService();

  @override
  Widget build(BuildContext context) {
    authState = Provider.of<AuthState>(context);
    sharePrefService.getBoolSp(authState);
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(builder: (context, orientaion) {
          Sizing().init(constraints, orientaion);
          return MaterialApp(
              theme: ThemeData(
                  fontFamily: 'Candal',
                  primaryColor: Colors.white,
                  primaryIconTheme: IconThemeData(color: Colors.black45)),
              debugShowCheckedModeBanner: false,
              title: 'Providerlance',
              home: authState.loggedUser==null
                  ? LoadingBar()
                  : authState.loggedUser == true
                      ? NavPage()
                      : LoginScreen());
        });
      },
    );
  }
}
