part of 'adopted_bloc.dart';

@immutable
abstract class AdoptedEvent {}

class AdoptionRequested extends AdoptedEvent {
  final int petId;
  final _myBox = Hive.box('pets');

  void updatePetAdoptionStatus(int petId) {
    _myBox.put(petId, DateTime.now());
  }

  AdoptionRequested({required this.petId});
}

class AdoptionSuccess extends AdoptedEvent {
  final int petId;

  AdoptionSuccess({required this.petId});
}

class AdoptionFailed extends AdoptedEvent {
  final String error;

  AdoptionFailed({required this.error});
}

class AdoptionLoading extends AdoptedEvent {}

class AdoptionExit extends AdoptedEvent {}

class AdoptionCleared extends AdoptedEvent {}
