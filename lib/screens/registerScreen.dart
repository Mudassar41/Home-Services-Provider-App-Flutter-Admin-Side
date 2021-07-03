import 'package:country_code_picker/country_code_picker.dart';
import 'package:final_year_project/models/providerModel.dart';
import 'package:final_year_project/stateManagement/phoneAuthProvider.dart';
import 'package:final_year_project/reusableComponents/logoWidget.dart';
import 'package:final_year_project/reusableComponents/snackBar.dart';
import 'package:final_year_project/services/apiServices.dart';
import 'package:final_year_project/services/phoneAuthService.dart';
import 'package:final_year_project/reusableComponents/customColors.dart';
import 'package:final_year_project/reusableComponents/formField.dart';
import 'package:final_year_project/reusableComponents/sizing.dart';
import 'package:final_year_project/reusableComponents/verificationCodeFields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:final_year_project/stateManagement/providers/currentuserState.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:final_year_project/services/sharedPrefService.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool value = true;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isHidden = true;
  bool value1 = true;
  bool isHidden1 = true;
  PageController pageController = PageController();
  bool floatingCheck = true;
  bool hasError = false;
  PhoneAuthProvidr providr;
  dynamic countryCode = '+92';
  PhoneAuthFirebase phoneAuthFirebase = PhoneAuthFirebase();
  dynamic varificatioCode;
  CurrentUserIdState idState;
  ApiServices apiServices = ApiServices();
  SharePrefService service = SharePrefService();
  final focus = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();
  final focus5 = FocusNode();
  final focus6 = FocusNode();
  final focusPassword = FocusNode();
  String currentText = "";

  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();
  PhoneAuthCredential phoneAuthCredential;
  ProviderModel providerModel = ProviderModel();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController =
      TextEditingController();
  ProgressDialog progressDialog;
  final TextEditingController digit1Controller = TextEditingController();
  final TextEditingController digit2Controller = TextEditingController();
  final TextEditingController digit3Controller = TextEditingController();
  final TextEditingController digit4Controller = TextEditingController();
  final TextEditingController digit5Controller = TextEditingController();
  final TextEditingController digit6Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    focus.dispose();
    focus2.dispose();
    focus4.dispose();
    focus5.dispose();
    focus6.dispose();
    focusPassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    idState = Provider.of<CurrentUserIdState>(context);
    providr = Provider.of<PhoneAuthProvidr>(context);
    progressDialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);

    return SafeArea(
        child: Scaffold(
            key: scaffoldKey,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (pageController.page.toInt() == 2) {
                  setState(() {
                    floatingCheck = false;
                  });
                }
                if (pageController.page.toInt() == 0) {
                  if (!formKey1.currentState.validate()) {
                    return;
                  } else {
                    FocusScope.of(context).unfocus();
                    pageController.animateToPage(
                        pageController.page.toInt() + 1,
                        duration: Duration(milliseconds: 400),
                        curve: Curves.easeIn);
                    formKey1.currentState.save();
                  }
                } else if (pageController.page.toInt() == 1) {
                  if (!formKey2.currentState.validate()) {
                    return;
                  } else {
                    FocusScope.of(context).unfocus();
                    formKey2.currentState.save();
                    pageController.animateToPage(
                        pageController.page.toInt() + 1,
                        duration: Duration(milliseconds: 400),
                        curve: Curves.easeIn);
                    setState(() {
                      floatingCheck = false;
                    });
                  }
                } else if (pageController.page.toInt() == 2) {
                  FocusScope.of(context).unfocus();
                  if (!formKey3.currentState.validate()) {
                    return;
                  }
                }
              },
              backgroundColor: CustomColors.lightGreen,
              child: floatingCheck == true ? Text('Next') : Icon(Icons.done),
            ),
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
            ),
            body: ListView(
              children: [
                LogoWidget(Sizing.heightMultiplier * 35, 'Sign Up',
                    'Business Account'),
                Container(
                  height: MediaQuery.of(context).size.height * .5,
                  child: PageView(
                    //  physics: NeverScrollableScrollPhysics(),
                    controller: pageController,
                    children: [
                      Form(
                        key: formKey1,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25, right: 25, top: 8, bottom: 2),
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: firstNameController,
                                cursorColor: CustomColors.lightGreen,
                                onFieldSubmitted: (v) {
                                  FocusScope.of(context).requestFocus(focus);
                                },
                                decoration: FormFieldDesign.inputDecoration(
                                    'First Name', Icons.account_box_outlined),
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return 'First Name required';
                                  }
                                  return null;
                                },
                                onSaved: (String val) {
                                  providerModel.firstName = val;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25, right: 25, top: 8, bottom: 2),
                              child: TextFormField(
                                focusNode: focus,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: lastNameController,
                                cursorColor: CustomColors.lightGreen,
                                textInputAction: TextInputAction.done,
                                decoration: FormFieldDesign.inputDecoration(
                                    'Last Name', Icons.account_box_outlined),
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return 'Last Name required';
                                  }
                                  return null;
                                },
                                onSaved: (String val) {
                                  providerModel.lastName = val;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Form(
                        key: formKey2,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25, right: 25, top: 8, bottom: 2),
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: phoneNumberController,
                                  keyboardType: TextInputType.phone,
                                  cursorColor: CustomColors.lightGreen,
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                    focusedErrorBorder: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(5.0),
                                        borderSide: new BorderSide(
                                            color: CustomColors.lightGreen)),
                                    errorBorder: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(5.0),
                                        borderSide: new BorderSide(
                                            color: CustomColors.lightGreen)),
                                    enabledBorder: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(5.0),
                                        borderSide: new BorderSide(
                                            color: CustomColors.lightGreen)),
                                    focusedBorder: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(5.0),
                                        borderSide: new BorderSide(
                                            color: CustomColors.lightGreen)),
                                    labelText: 'Phone no',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    suffixIcon: Icon(
                                      Icons.phone_android_outlined,
                                      color: Colors.grey,
                                    ),
                                    prefixIcon: CountryCodePicker(
                                      onChanged: (CountryCode cC) {
                                        setState(() {
                                          countryCode = cC;
                                        });
                                      },
                                      // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                      initialSelection: 'PK',
                                      favorite: ['+92', 'PK'],
                                      // optional. Shows only country name and flag
                                      showCountryOnly: false,

                                      showFlagDialog: true,

                                      // optional. Shows only country name and flag when popup is closed.
                                      showOnlyCountryWhenClosed: false,
                                      // optional. aligns the flag and the Text left
                                      alignLeft: false,
                                    ),
                                  ),
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return 'Phone no required';
                                    }
                                    return null;
                                  },
                                  onSaved: (String value) {
                                    providerModel.phoneNumber = value;
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25, right: 25, top: 8, bottom: 2),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: CustomColors.lightRed),
                                  onPressed: () {
                                    print(
                                        '${countryCode}${phoneNumberController.text}');
                                    phoneAuthFirebase.verifyPhone(
                                        progressDialog,
                                        '${countryCode}${phoneNumberController.text}',
                                        providr);
                                  },
                                  child: Text('Verify'),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25, right: 25, top: 8, bottom: 2),
                                child: Text(
                                  'Enter varification code',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25, right: 25, top: 8, bottom: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: TextFormField(
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            controller: digit1Controller,
                                            textAlign: TextAlign.center,
                                            onChanged: (val) {
                                              if (val.length == 1) {
                                                FocusScope.of(context)
                                                    .requestFocus(focus2);
                                              }
                                            },
                                            keyboardType: TextInputType.number,
                                            //  textInputAction: TextInputAction.next,
                                            cursorColor:
                                                CustomColors.lightGreen,
                                            decoration: VarificationFields
                                                .varificationFieldDesign(),
                                            validator: (String value) {
                                              if (value.isEmpty) {
                                                return 'Digit required';
                                              }
                                              return null;
                                            },
                                            onSaved: (String value) {
                                              //   _user.displayName = value;
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Center(
                                          child: TextFormField(
                                            focusNode: focus2,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            controller: digit2Controller,
                                            textAlign: TextAlign.center,
                                            onChanged: (val) {
                                              if (val.length == 1) {
                                                FocusScope.of(context)
                                                    .requestFocus(focus3);
                                              }
                                            },
                                            keyboardType: TextInputType.number,
                                            //  textInputAction: TextInputAction.next,
                                            cursorColor:
                                                CustomColors.lightGreen,
                                            decoration: VarificationFields
                                                .varificationFieldDesign(),
                                            validator: (String value) {
                                              if (value.isEmpty) {
                                                return 'Digit required';
                                              }
                                              return null;
                                            },
                                            onSaved: (String value) {
                                              //   _user.displayName = value;
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Center(
                                          child: TextFormField(
                                            focusNode: focus3,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            controller: digit3Controller,
                                            textAlign: TextAlign.center,
                                            onChanged: (val) {
                                              if (val.length == 1) {
                                                FocusScope.of(context)
                                                    .requestFocus(focus4);
                                              }
                                            },
                                            keyboardType: TextInputType.number,
                                            //  textInputAction: TextInputAction.next,
                                            cursorColor:
                                                CustomColors.lightGreen,
                                            decoration: VarificationFields
                                                .varificationFieldDesign(),
                                            validator: (String value) {
                                              if (value.isEmpty) {
                                                return 'Digit required';
                                              }
                                              return null;
                                            },
                                            onSaved: (String value) {
                                              //   _user.displayName = value;
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Center(
                                          child: TextFormField(
                                            focusNode: focus4,
                                            textInputAction:
                                                TextInputAction.next,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            controller: digit4Controller,
                                            textAlign: TextAlign.center,
                                            onChanged: (val) {
                                              if (val.length == 1) {
                                                FocusScope.of(context)
                                                    .requestFocus(focus5);
                                              }
                                            },
                                            keyboardType: TextInputType.number,
                                            //  textInputAction: TextInputAction.next,
                                            cursorColor:
                                                CustomColors.lightGreen,
                                            decoration: VarificationFields
                                                .varificationFieldDesign(),
                                            validator: (String value) {
                                              if (value.isEmpty) {
                                                return 'Digit required';
                                              }
                                              return null;
                                            },
                                            onSaved: (String value) {
                                              //   _user.displayName = value;
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Center(
                                          child: TextFormField(
                                            focusNode: focus5,

                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            controller: digit5Controller,
                                            textAlign: TextAlign.center,
                                            onChanged: (val) {
                                              if (val.length == 1) {
                                                FocusScope.of(context)
                                                    .requestFocus(focus6);
                                              }
                                            },
                                            keyboardType: TextInputType.number,
                                            //  textInputAction: TextInputAction.next,
                                            cursorColor:
                                                CustomColors.lightGreen,
                                            decoration: VarificationFields
                                                .varificationFieldDesign(),
                                            validator: (String value) {
                                              if (value.isEmpty) {
                                                return 'Digit required';
                                              }
                                              return null;
                                            },
                                            onSaved: (String value) {
                                              //   _user.displayName = value;
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Center(
                                          child: TextFormField(
                                            focusNode: focus6,

                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            controller: digit6Controller,
                                            textAlign: TextAlign.center,
                                            onChanged: (val) {
                                              if (val.length == 1) {
                                                FocusScope.of(context)
                                                    .unfocus();
                                              }
                                            },
                                            keyboardType: TextInputType.number,
                                            //  textInputAction: TextInputAction.next,
                                            cursorColor:
                                                CustomColors.lightGreen,
                                            decoration: VarificationFields
                                                .varificationFieldDesign(),
                                            validator: (String value) {
                                              if (value.isEmpty) {
                                                return 'Digit required';
                                              }
                                              return null;
                                            },
                                            onSaved: (String value) {
                                              //   _user.displayName = value;
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25, right: 25, top: 8, bottom: 2),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: CustomColors.lightRed),
                                  onPressed: () async {
                                    var code =
                                        '${digit1Controller.text}${digit2Controller.text}${digit3Controller.text}${digit4Controller.text}${digit5Controller.text}${digit6Controller.text}';

                                    final AuthCredential credential =
                                        PhoneAuthProvider.credential(
                                      verificationId: providr.verificationId,
                                      smsCode: code,
                                    );

                                    try {
                                      var firebaseUser = await FirebaseAuth
                                          .instance
                                          .signInWithCredential(credential);
                                      print("Login Successful");
                                      CustomSnackBar.showSnackBar(
                                          'Valid OTP', context);
                                      pageController.animateToPage(
                                          pageController.page.toInt() + 1,
                                          duration: Duration(milliseconds: 400),
                                          curve: Curves.easeIn);
                                      setState(() {
                                        floatingCheck = false;
                                      });
                                    } catch (e) {
                                      print("Login not successful");
                                      CustomSnackBar.showSnackBar(
                                          'Try again something went wrong',
                                          context);
                                    }
                                  },
                                  child: Text('Submit'),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25, right: 25, top: 8, bottom: 2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Did\'t recieve any Code? '),
                                    TextButton(
                                        onPressed: () {
                                          phoneAuthFirebase.verifyPhone(
                                              progressDialog,
                                              phoneNumberController.text,
                                              providr);
                                        },
                                        child: Text(
                                          'Re-Send',
                                          style: TextStyle(
                                              color: CustomColors.lightGreen,
                                              fontWeight: FontWeight.bold),
                                        ))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Form(
                        key: formKey3,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25, right: 25, top: 8, bottom: 2),
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: passwordController,
                                textInputAction: TextInputAction.next,
                                obscureText: isHidden ? true : false,
                                keyboardType: TextInputType.visiblePassword,
                                cursorColor: CustomColors.lightGreen,
                                onFieldSubmitted: (v) {
                                  FocusScope.of(context)
                                      .requestFocus(focusPassword);
                                },
                                decoration: InputDecoration(
                                    focusedErrorBorder: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(5.0),
                                        borderSide: new BorderSide(
                                            color: CustomColors.lightGreen)),
                                    errorBorder: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(5.0),
                                        borderSide: new BorderSide(
                                            color: CustomColors.lightGreen)),
                                    enabledBorder: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(5.0),
                                        borderSide: new BorderSide(
                                            color: CustomColors.lightGreen)),
                                    focusedBorder: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(5.0),
                                        borderSide: new BorderSide(
                                            color: CustomColors.lightGreen)),
                                    labelText: 'Password',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    suffixIcon: TextButton(
                                        onPressed: () {
                                          setvalue();
                                        },
                                        child: isHidden
                                            ? Icon(
                                                Icons.visibility_off,
                                                color: CustomColors.lightGreen,
                                              )
                                            : Icon(Icons.visibility,
                                                color:
                                                    CustomColors.lightGreen)),
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
                                  providerModel.password = value;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25, right: 25, top: 8, bottom: 2),
                              child: TextFormField(
                                focusNode: focusPassword,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: confirmpasswordController,
                                textInputAction: TextInputAction.done,
                                obscureText: isHidden1 ? true : false,
                                keyboardType: TextInputType.visiblePassword,
                                cursorColor: CustomColors.lightGreen,
                                decoration: InputDecoration(
                                    focusedErrorBorder: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(5.0),
                                        borderSide: new BorderSide(
                                            color: CustomColors.lightGreen)),
                                    errorBorder: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(5.0),
                                        borderSide: new BorderSide(
                                            color: CustomColors.lightGreen)),
                                    enabledBorder: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(5.0),
                                        borderSide: new BorderSide(
                                            color: CustomColors.lightGreen)),
                                    focusedBorder: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(5.0),
                                        borderSide: new BorderSide(
                                            color: CustomColors.lightGreen)),
                                    labelText: 'Confirm Password',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    suffixIcon: TextButton(
                                        onPressed: () {
                                          setvalue1();
                                        },
                                        child: isHidden1
                                            ? Icon(
                                                Icons.visibility_off,
                                                color: CustomColors.lightGreen,
                                              )
                                            : Icon(Icons.visibility,
                                                color:
                                                    CustomColors.lightGreen)),
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
                                  providerModel.confirmPassword = value;
                                },
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
                                        primary: CustomColors.lightRed,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0)))),
                                    onPressed: () async {
                                      if (passwordController.text ==
                                          confirmpasswordController.text) {
                                        if (!formKey3.currentState.validate()) {
                                          return;
                                        } else {
                                          formKey3.currentState.save();

                                          var code =
                                              '${digit1Controller.text}${digit2Controller.text}${digit3Controller.text}${digit4Controller.text}${digit5Controller.text}${digit6Controller.text}';

                                          providerModel.phoneNumber =
                                              '${countryCode}${phoneNumberController.text}';

                                          String res = await apiServices
                                              .postPrvidersData(providerModel,
                                                  progressDialog, service);
                                          if (res ==
                                              'Data inserted for providers') {
                                            //LOGIC
                                            CustomSnackBar.showSnackBar(
                                                'Account Created', context);
                                            service.addBoolToSp();
                                           // controller.update();
                                            Navigator.pop(context);
                                          } else {
                                            CustomSnackBar.showSnackBar(
                                                'Something went wrong',
                                                context);
                                          }
                                        }
                                      } else {
                                        CustomSnackBar.showSnackBar(
                                            'Password does\'t match', context);
                                      }
                                    },
                                    child: Text('Create Account'),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )));
  }

  void setvalue() {
    setState(() {
      isHidden = !isHidden;
    });
  }

  void setvalue1() {
    setState(() {
      isHidden1 = !isHidden1;
    });
  }
}
