part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {}

class SearchName extends SearchEvent {
  final String name;

  SearchName(this.name);
}
