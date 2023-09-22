import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seasons/core/core_widgets/flutter_toast.dart';
import 'package:seasons/features/settings/data/models/terms_model.dart';
import 'package:seasons/features/settings/data/repo/settings_repo_implementation.dart';
import 'package:seasons/features/settings/presentation/cubit/terms_cubit/terms_states.dart';

class TermsCubit extends Cubit<TermsStates> {
  TermsCubit(this.termsSettingsRepoImplementation) : super(TermsInitialState());
  final SettingsRepoImplementation termsSettingsRepoImplementation;
  static TermsCubit get(context) => BlocProvider.of(context);
  List<TermsModel> terms = [];
  Future<void> getTerms(context) async {
    terms = [];
    emit(GetAllTermsLoadingState());
    var response = await termsSettingsRepoImplementation.getAllTerms();

    response.fold((failure) {
      emit(GetAllTermsErrorState(failure.errorMessage));
    }, (result) {
      terms = result;
      emit(GetAllTermsSuccessState(result));
    });
  }
}
