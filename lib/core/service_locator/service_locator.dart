import 'package:get_it/get_it.dart';
import 'package:seasons/features/cars/data/repo/car_repo_implementation.dart';
import 'package:seasons/features/sign_in/data/repo/login_repo_implementation.dart';

import '../../features/hotels/data/repos/hotel_repo_implementation.dart';
import '../../features/settings/data/repo/settings_repo_implementation.dart';

final getIt = GetIt.instance;

void setupForgotPassSingleton() {
  getIt.registerSingleton<LoginRepoImplementation>(LoginRepoImplementation());
  getIt.registerSingleton<CarRepoImplementation>(CarRepoImplementation());
  getIt.registerSingleton<SettingsRepoImplementation>(
      SettingsRepoImplementation());
  getIt.registerSingleton<HotelRepoImplementation>(HotelRepoImplementation());
}
