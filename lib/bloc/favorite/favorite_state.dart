part of 'favorite_bloc.dart';

abstract class FavoriteState {}

class FavoriteInitial extends FavoriteState {}

class FavoriteInProgress extends FavoriteState {}

class FavoriteCompleted extends FavoriteState {
  final String message;
  FavoriteCompleted({required this.message});
}

class FavoriteFailed extends FavoriteState {
  final String error;
  FavoriteFailed({required this.error});
}

class FavoriteExited extends FavoriteState {}
