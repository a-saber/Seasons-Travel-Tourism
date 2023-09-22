import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seasons/core/core_widgets/flutter_toast.dart';
import 'package:seasons/features/cars/data/models/book_model.dart';
import 'package:seasons/features/cars/presentation/cubit/book_cubit/car_book_states.dart';

import '../../../data/repo/car_repo_implementation.dart';

class CarBookCubit extends Cubit<CarBookStates> {
  CarBookCubit(this.carBookRepoImplementation) : super(CarBookInitialState());
  final CarRepoImplementation carBookRepoImplementation;

  void setDate(DateTime from, DateTime to)
  {
    this.from = from;
    this.to = to;
    emit(CarBookDateLoadingState());
  }
  DateTime? from;
  DateTime? to;

  static CarBookCubit get(context) => BlocProvider.of(context);
  BookModel? bookModel;

  Future<void> bookCar({
    required context,
    required String typedId,
    required String driver,
    required String fName,
    required String lName,
    required String phone,
    required String startDate,
    required String endDate,
    required String email,
    required String totalDays,
    required String totalAmount,
    required String tax,
    required String net,
    required String notes,
  }) async {
    emit(CarBookCarBookLoadingState());
    var response = await carBookRepoImplementation.BookCar(
      typedId: typedId,
      driver: driver,
      fName: fName,
      lName: lName,
      phone: phone,
      startDate: startDate,
      endDate: endDate,
      email: email,
      totalDays: totalDays,
      totalAmount: totalAmount,
      tax: tax,
      net: net,
      notes: notes,
    );
    response.fold((failure) {
      emit(CarBookCarBookErrorState(failure.errorMessage));
      //showToast(state: ToastState.SUCCESS, massage: failure.errorMessage);
    }, (result) async {
      if (result.status == 'success') {
        print("in success");
        emit(CarBookCarBookSuccessState(result));
        //showToast(state: ToastState.SUCCESS, massage: result.message!);
      } else {
        emit(CarBookCarBookErrorState(result.message!));
        //showToast(state: ToastState.ERROR, massage: result.message!);
      }
    });
  }
}
