import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/cartInfo.dart';

class CurrentIndexProvide with ChangeNotifier
{

  int currentIndex = 0;

  changeIndex(int newIndex)
  {

    currentIndex = newIndex;
    notifyListeners();
  }


}