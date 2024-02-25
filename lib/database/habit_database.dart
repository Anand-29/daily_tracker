import 'package:daily_tracker/models/app_settings.dart';
import 'package:daily_tracker/models/habit.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

  // init database
  static Future<void> initalise() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [HabitSchema, AppSettingsSchema],
      directory: dir.path,
    );
  }

  // Save first date of app startup ( for Heatmap )
  Future<void> saveFirstLaunch() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  // Get first date of app startup (for Heatmap)
  Future<DateTime?> getFirstLaunchDate() async {
    final setting = await isar.appSettings.where().findFirst();
    return setting?.firstLaunchDate;
  }
}
