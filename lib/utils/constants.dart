import 'package:flutter/material.dart';
import 'package:get/get.dart';

Color kColorAppbar = Color(0xFF6200EE);
Color kPrimaryBG = Color(0xFF1A1A1A);
Color kPrimaryFont = Colors.white;
Color kBorderColor = Colors.pink;
RxBool showWaiting = false.obs;
  Rxn<bool> responseDone = Rxn<bool>();
