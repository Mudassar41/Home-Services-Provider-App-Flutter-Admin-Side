import 'package:final_year_project/models/chatModel.dart';
import 'package:final_year_project/services/apiServices.dart';
import 'package:final_year_project/services/sharedPrefService.dart';
import 'package:final_year_project/stateManagement/controllers/profileController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatProvider extends ChangeNotifier {
  List<Chat> _chatList = [];
  List<Chat> _chatUserList = [];
  Chat _twoWayChat = Chat();

  Chat get twoWayChat => _twoWayChat;

  set twoWayChat(Chat value) {
    _twoWayChat = value;
    notifyListeners();
  }

  ScrollController scrollController;

  var chatEditTextController = TextEditingController();
  ApiServices apiServices = ApiServices();
  SharePrefService sharePrefService = SharePrefService();
  ProfileController userInfo = Get.put(ProfileController());

  bool loadingbar = true;

  List<Chat> get chatList => _chatList;

  set chatList(List<Chat> value) {
    _chatList = value;
    notifyListeners();
    loadingbar = false;
  }

  List<Chat> get chatUserList => _chatUserList;

  set chatUserList(List<Chat> value) {
    _chatUserList = value;
    notifyListeners();
  }

  Future<String> getId() async {
    String id = '';
    id = await sharePrefService.getcurrentUserId();
    return id;
  }
}
