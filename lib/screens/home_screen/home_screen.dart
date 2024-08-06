import 'dart:async';

import 'package:flutter/material.dart';
import 'package:healthmini/provider/exercise_provider.dart';
import 'package:healthmini/provider/recipe_provider.dart';
import 'package:healthmini/screens/home_screen/view/desktop_home_view.dart';
import 'package:healthmini/screens/home_screen/view/mobile_home_view.dart';
import 'package:healthmini/screens/home_screen/view/tablet_home_view.dart';
import 'package:healthmini/widgets/appbar.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool isLoad = true;


  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100),() {
      apiCall();
    },);
  }

  void apiCall()  {
    Provider.of<ExerciseListProvider>(context,listen: false).getExerciseList(context: context);
    Provider.of<RecipeListProvider>(context,listen: false).getRecipeList(context: context);
  }



  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const ResponsiveAppBar(),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (screenWidth <= 650) {
                return const MobileHomeView();
              } else if (screenWidth > 650 && screenWidth <= 1024) {
                return  TabletHomeView();
              } else {
                return DesktopHomeView();
              }
            },
          ),
        ),
      ),
    );
  }

}
