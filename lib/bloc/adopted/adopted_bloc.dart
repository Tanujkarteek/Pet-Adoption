import 'dart:async';
import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

part 'adopted_event.dart';
part 'adopted_state.dart';

class AdoptedBloc extends Bloc<AdoptedEvent, AdoptedState> {
  AdoptedBloc() : super(AdoptedInitial()) {
    on<AdoptedEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<AdoptionRequested>((event, emit) {
      print('hello');
      emit(AdoptionInProgress());
    });
    on<AdoptionSuccess>((event, emit) {
      emit(AdoptionCompleted());
    });
    on<AdoptionFailed>((event, emit) {
      emit(AdoptionFailure(error: event.error));
    });
    on<AdoptionExit>((event, emit) {
      emit(AdoptionExited());
    });
  }
}
