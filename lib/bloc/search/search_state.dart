part of 'search_bloc.dart';

@immutable
abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchInProgress extends SearchState {}

class SearchCompleted extends SearchState {
  final List<String> searchList;

  SearchCompleted(this.searchList);
}
