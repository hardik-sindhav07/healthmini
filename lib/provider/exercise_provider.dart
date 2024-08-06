// ignore_for_file: collection_methods_unrelated_type, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:healthmini/api/gemini_api.dart';
import 'package:healthmini/api/pexels_api.dart';
import 'package:healthmini/helper/prompt_helper.dart';
import 'package:healthmini/models/exercise_model.dart';
import 'package:healthmini/models/pexels_model.dart';
import 'package:healthmini/utils/snackbar.dart';


enum ExerciseState {
  initial,
  loaded,
  loading,
  error,
}

class ExerciseListProvider extends ChangeNotifier {
  ExerciseState _exerciseState = ExerciseState.initial;
  String message = '';

  ExerciseState get exerciseState => _exerciseState;


  List<ExerciseModel> exerciseList = [];
  PexelsModel? pexelsModel;

  Future<void> getExerciseList({required BuildContext context}) async {
    exerciseList = [];
    _exerciseState = ExerciseState.loading;
    notifyListeners();

    try {

          var res = await GeminiApi().callGemini(
              PromptHelper().exercisePrompt());


          if (res != null && res['data'] != null) {
            ExerciseModel exerciseModel = ExerciseModel.fromJson(res);
            exerciseList.add(exerciseModel);
            print(exerciseList);
            pexelsModel = await PexelsApi().searchPhotos(exerciseModel.data?.aasanName??"");
            _exerciseState = ExerciseState.loaded;
            notifyListeners();

            print(res);
          } else if (res['message'] != '') {
            message = res['message'];
            _exerciseState = ExerciseState.loaded;
            notifyListeners();
          } else {
            message = "An error occurred. Please try again.";
            showCustomSnackbar(context, 'An error occurred. Please try again.',
                MessageType.warning);
            _exerciseState = ExerciseState.error;
            notifyListeners();
          }


    } catch (e) {
      print('Error occurred: $e');
      showCustomSnackbar(
          context, 'An error occurred. Please try again.', MessageType.error);
      _exerciseState = ExerciseState.error;
      notifyListeners();
    }
  }
}
