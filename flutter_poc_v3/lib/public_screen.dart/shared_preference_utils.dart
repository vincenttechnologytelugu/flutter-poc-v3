import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceUtils {
  late SharedPreferences sharedPreferences;
  init()async{
    sharedPreferences=await SharedPreferences.getInstance();
  }
}