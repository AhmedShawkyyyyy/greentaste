import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/utils/dio_helper.dart';
import 'core/utils/shared_prefs_helper.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  DioHelper.init();

  await SharedPrefsHelper.init();

  runApp(const HealthyBiteApp());
}