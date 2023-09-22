import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seasons/core/core_widgets/flutter_toast.dart';
import 'package:seasons/features/settings/data/models/about_model.dart';
import 'package:seasons/features/settings/data/models/info_model.dart';
import 'package:seasons/features/settings/data/repo/settings_repo_implementation.dart';

import 'about_states.dart';

class AboutCubit extends Cubit<AboutStates> {
  AboutCubit(this.settingsRepoImplementation) : super(AboutInitialState());
  final SettingsRepoImplementation settingsRepoImplementation;
  static AboutCubit get(context) => BlocProvider.of(context);
  List<AboutModel> about = [];
  Future<void> getAbout(context) async {
    about = [];
    emit(GetAboutLoadingState());
    var response = await settingsRepoImplementation.getAbout();

    response.fold((failure) {
      emit(GetAboutErrorState(failure.errorMessage));
    }, (result) {
      about = result;
      emit(GetAboutSuccessState());
    });
  }
}
