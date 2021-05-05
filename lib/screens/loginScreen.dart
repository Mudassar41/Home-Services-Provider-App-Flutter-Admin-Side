import 'package:final_year_project/animations/pageRouteAnimation.dart';
import 'package:final_year_project/models/providerModel.dart';
import 'package:final_year_project/reusableComponents/logoWidget.dart';
import 'package:final_year_project/reusableComponents/sizing.dart';
import 'package:final_year_project/reusableComponents/snackBar.dart';
import 'package:final_year_project/screens/registerScreen.dart';
import 'package:final_year_project/reUsableComponents/customColors.dart';
import 'package:final_year_project/reUsableComponents/formField.dart';
import 'package:final_year_project/services/apiServices.dart';
import 'package:final_year_project/services/sharedPrefService.dart';
import 'package:final_year_project/stateManagement/providers/currentuserState.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool value = true;
  bool _isHidden = true;
  ProviderModel user = ProviderModel();
  final formKey1 = GlobalKey<FormState>();
  ApiServices apiServices = ApiServices();
  SharePrefService service = SharePrefService();
  CurrentUserIdState idState;

  ProgressDialog progressDialog;

  @override
  Widget build(BuildContext context) {
    idState = Provider.of<CurrentUserIdState>(context);

    progressDialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Form(
              key: formKey1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LogoWidget(Sizing.heightMultiplier * 35, 'Welcome Back',
                      'Sign In to continue'),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 25, right: 25, top: 8, bottom: 2),
                    child: Container(
                      height: Sizing.heightMultiplier * 7,
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        cursorColor: CustomColors.lightGreen,
                        textInputAction: TextInputAction.next,
                        decoration: FormFieldDesign.inputDecoration(
                            'Phone no', Icons.phone_android_outlined),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Phone no required';
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          user.phoneNumber = value;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 25, right: 25, top: 8, bottom: 2),
                    child: Container(
                      height: Sizing.heightMultiplier * 7,
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        textInputAction: TextInputAction.done,
                        obscureText: _isHidden ? true : false,
                        keyboardType: TextInputType.visiblePassword,
                        cursorColor: CustomColors.lightGreen,
                        decoration: InputDecoration(
                            enabledBorder: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(
                                    color: CustomColors.lightGreen)),
                            focusedBorder: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(
                                    color: CustomColors.lightGreen)),
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.grey),
                            suffixIcon: TextButton(
                                onPressed: () {
                                  setvalue();
                                },
                                child: _isHidden
                                    ? Icon(
                                        Icons.visibility_off,
                                        color: CustomColors.lightGreen,
                                      )
                                    : Icon(Icons.visibility,
                                        color: CustomColors.lightGreen)),
                            prefixIcon: Icon(
                              Icons.lock_outlined,
                              color: Colors.grey,
                            )),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Password required';
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          user.password = value;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 25, right: 25, top: 8, bottom: 2),
                    child: Container(
                        height: Sizing.heightMultiplier * 6.5,
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: CustomColors.lightRed),
                          onPressed: () async {
                            if (!formKey1.currentState.validate()) {
                              return;
                            } else {
                              formKey1.currentState.save();
                              String res = await apiServices.loginUser(
                                  service, user, progressDialog);
                              if (res == 'Data Exist') {
                                CustomSnackBar.showSnackBar(
                                    'Login Success', context);
                                service.addBoolToSp();
                              } else {
                                CustomSnackBar.showSnackBar(
                                    'Something Went wrong', context);
                              }
                            }
                          },
                          child: Text('Sign In'),
                        )),
                  ),
                  TextButton(
                    child: Text(
                      'Forgot Password',
                      style: TextStyle(color: Colors.grey),
                    ),
                    onPressed: () {},
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an Account? ',
                      ),
                      TextButton(
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .push(SlideRightRoute(widget: RegisterScreen()));
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void setvalue() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}
