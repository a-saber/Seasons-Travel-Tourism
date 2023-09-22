import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seasons/core/core_widgets/flutter_toast.dart';
import 'package:seasons/features/settings/data/models/privacy_model.dart';
import 'package:seasons/features/settings/data/repo/settings_repo_implementation.dart';
import 'package:seasons/features/settings/presentation/cubit/privacy_cubit/privacy_states.dart';

class PrivacyCubit extends Cubit<PrivacyStates> {
  PrivacyCubit(this.privacySettingsRepoImplementation)
      : super(PrivacyInitialState());
  final SettingsRepoImplementation privacySettingsRepoImplementation;
  static PrivacyCubit get(context) => BlocProvider.of(context);
  List<PrivacyModel> privacyModel = [];
  Future<void> getPrivacy(context) async {
    privacyModel = [];
    emit(GetAllPrivacyLoadingState());
    var response = await privacySettingsRepoImplementation.getAllPrivacy();

    response.fold((failure) {
      emit(GetAllPrivacyErrorState(failure.errorMessage));
    }, (result) {
      privacyModel = result;
      emit(GetAllPrivacySuccessState(result));
    });
  }
}
