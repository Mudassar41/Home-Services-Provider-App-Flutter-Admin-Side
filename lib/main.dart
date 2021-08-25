import 'package:final_year_project/reusableComponents/customColors.dart';
import 'package:final_year_project/screens/bottomNavViews/tasksView.dart';

import 'package:final_year_project/stateManagement/phoneAuthProvider.dart';
import 'package:final_year_project/reusableComponents/lodingbar.dart';
import 'package:final_year_project/screens/loginScreen.dart';
import 'package:final_year_project/reusableComponents/sizing.dart';
import 'package:final_year_project/screens/BottonNavPage.dart';
import 'package:final_year_project/stateManagement/providers/DbProvider.dart';
import 'package:final_year_project/stateManagement/providers/chatProvider.dart';
import 'package:final_year_project/stateManagement/providers/serviceProvidersprofiles.dart';
import 'package:final_year_project/stateManagement/providers/tasksProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:final_year_project/stateManagement/providers/authState.dart';
import 'package:final_year_project/stateManagement/providers/currentuserState.dart';
import 'package:final_year_project/services/sharedPrefService.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print('Message is ${message.data['screen']}');
  if (message.data['screen'] == 'offers') {}
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
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
      ChangeNotifierProvider<PhoneAuthProvidr>(
        create: (BuildContext context) {
          return PhoneAuthProvidr();
        },
      ),
      ChangeNotifierProvider<DatabaseProvider>(
        create: (BuildContext context) {
          return DatabaseProvider();
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
      ChangeNotifierProvider<TasksProvider>(
        create: (BuildContext context) {
          return TasksProvider();
        },
      ),
      ChangeNotifierProvider<ServiceProvidersProfileProvider>(
        create: (BuildContext context) {
          return ServiceProvidersProfileProvider();
        },
      ),
      ChangeNotifierProvider<ChatProvider>(
        create: (BuildContext context) {
          return ChatProvider();
        },
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthState authState;

  SharePrefService sharePrefService = SharePrefService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      if (notification != null && android != null) {
        if (message.data['type'] == 'booking') {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channel.description,
                  color: Colors.blue,
                  playSound: true,
                  icon: '@mipmap/ic_launcher',
                ),
              ));
        }
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  @override
  Widget build(BuildContext context) {
    authState = Provider.of<AuthState>(context);
    sharePrefService.getBoolSp(authState);
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(builder: (context, orientaion) {
          Sizing().init(constraints, orientaion);
          return GetMaterialApp(
              theme: ThemeData(
                  fontFamily: 'Candal',
                  primaryColor: Colors.white,
                  primaryIconTheme: IconThemeData(color: Colors.black45)),
              debugShowCheckedModeBanner: false,
              title: 'ProviderSide',
              home: authState.loggedUser == null
                  ? LoadingBar()
                  : authState.loggedUser == true
                      ? NavPage()
                      : LoginScreen());
        });
      },
    );
  }

  Future<void> init() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['screen'] == 'offers') {
      print("yes");
      Get.to(TasksView());
    }
  }
}
