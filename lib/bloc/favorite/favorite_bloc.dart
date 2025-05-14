import 'package:bloc/bloc.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:meta/meta.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc() : super(FavoriteInitial()) {
    on<FavoriteEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<AddFavorite>((event, emit) {
      try {
        final myBox = Hive.box('favorites');
        myBox.put(event.petId, event.timestamp);
        emit(FavoriteCompleted(message: 'Favorite added'));
      } catch (e) {
        emit(FavoriteFailed(error: e.toString()));
      }
    });
    on<RemoveFavorite>((event, emit) {
      try {
        final myBox = Hive.box('favorites');
        myBox.delete(event.petId);
        emit(FavoriteCompleted(message: 'Favorite removed'));
      } catch (e) {
        emit(FavoriteFailed(error: e.toString()));
      }
    });
    on<FavoriteLoading>((event, emit) {
      emit(FavoriteInProgress());
    });
  }
}
