part of 'adopted_bloc.dart';

@immutable
abstract class AdoptedState {}

class AdoptedInitial extends AdoptedState {}

class AdoptionInProgress extends AdoptedState {}

class AdoptionCompleted extends AdoptedState {}

class AdoptionFailure extends AdoptedState {
  final String error;

  AdoptionFailure({required this.error});
}

class AdoptionExited extends AdoptedState {}

class AdoptionClearedState extends AdoptedState {}
