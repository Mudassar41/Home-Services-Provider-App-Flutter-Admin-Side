import 'package:final_year_project/models/providerModel.dart';
import 'package:flutter/cupertino.dart';

class ServiceProvidersProfileProvider  extends ChangeNotifier{

bool _loadingBar;
List<ProviderModel> _providerProfileList=[];

 bool get loadingBar => this._loadingBar;
 set loadingBar(bool value) {
   this._loadingBar = value;
   notifyListeners();
 } 

 List<ProviderModel> get providerProfileList => this._providerProfileList;
 set providerProfileList(List<ProviderModel> value) {
   this._providerProfileList = value;
   notifyListeners();
 } 




}