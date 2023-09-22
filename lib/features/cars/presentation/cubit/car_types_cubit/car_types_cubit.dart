import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seasons/core/core_widgets/flutter_toast.dart';

import '../../../data/models/car_types.dart';
import '../../../data/repo/car_repo_implementation.dart';
import 'car_types_states.dart';

class CarTypesCubit extends Cubit<CarTypesStates> {
  CarTypesCubit(this.carTypesRepoImplementation)
      : super(CarTypesInitialState());
  final CarRepoImplementation carTypesRepoImplementation;
  static CarTypesCubit get(context) => BlocProvider.of(context);
  List<CarTypes> carTypes = [];
  List<String> carTypesNames = [];
  int length = 0;
  Future<void> getCarTypes(context) async {
    carTypes = [];
    emit(GetAllCarTypesLoadingState());
    var response = await carTypesRepoImplementation.getAllCarTypes();

    response.fold((failure) {
      emit(GetAllCarTypesErrorState(failure.errorMessage));
      showToast(state: ToastState.ERROR, massage: failure.errorMessage);
    }, (result) {
      carTypes = result;
      length = result.length;
      for (int i = 0; i < result.length; i++) {
        carTypesNames.add(result[i].nameEn!);
      }
      emit(GetAllCarTypesSuccessState(result));
      // showToast(
      //     state: ToastState.SUCCESS, massage: "Get Car Types Successfully");
    });
  }

  int typeIndex = 0;
  changeIndex(int index) {
    print(index);
    typeIndex = index;
    emit(ChangeIndexState());
  }
}
