import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seasons/core/core_widgets/flutter_toast.dart';
import 'package:seasons/features/settings/data/models/info_model.dart';
import 'package:seasons/features/settings/data/repo/settings_repo_implementation.dart';

import 'info_states.dart';

class InfoCubit extends Cubit<InfoStates> {
  InfoCubit(this.settingsRepoImplementation) : super(InfoInitialState());
  final SettingsRepoImplementation settingsRepoImplementation;
  static InfoCubit get(context) => BlocProvider.of(context);
  List<InfoModel> info = [];
  Future<void> getInfo(context) async {
    info = [];
    emit(GetAllInfoLoadingState());
    var response = await settingsRepoImplementation.getAllInfo();

    response.fold((failure) {
      emit(GetAllInfoErrorState(failure.errorMessage));
    }, (result) {
      info = result;
      emit(GetAllInfoSuccessState(result));
    });
  }
}
