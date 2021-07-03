import 'package:final_year_project/models/tasksModel.dart';
import 'package:flutter/cupertino.dart';


class TasksProvider extends ChangeNotifier {
  List<TasksModel> _tasksList = [];
  TasksModel _tasksModel=TasksModel();
  double rating;
  TextEditingController reviewController = TextEditingController();

  TasksModel get tasksModel => _tasksModel;

  set tasksModel(TasksModel value) {
    _tasksModel = value;
    notifyListeners();
  }

  List<TasksModel> get tasksList => _tasksList;

  set tasksList(List<TasksModel> value) {
    _tasksList = value;
    notifyListeners();
  }
}
