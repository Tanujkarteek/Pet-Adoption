part of 'favorite_bloc.dart';

abstract class FavoriteEvent {}

class AddFavorite extends FavoriteEvent {
  final int petId;
  final DateTime timestamp;

  AddFavorite({required this.petId, required this.timestamp});
}

class RemoveFavorite extends FavoriteEvent {
  final int petId;
  final DateTime timestamp;

  RemoveFavorite({required this.petId, required this.timestamp});
}

class FavoriteLoading extends FavoriteEvent {}
