import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../constants/data.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    on<SearchName>((event, emit) {
      List<String> searchList = [];
      // for (var i = 0; i < dataList.length; i++) {
      //   if (dataList[i].name.toLowerCase().contains(event.name.toLowerCase())) {
      //     searchList.add(dataList[i].name);
      //   }
      // }
      emit(SearchCompleted(searchList));
    });
  }
}

