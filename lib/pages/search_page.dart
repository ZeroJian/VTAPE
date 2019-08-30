import 'package:flutter/material.dart';

import 'package:vtape/utils/api.dart';
import 'package:vtape/models/request_params.dart';
import 'package:vtape/pages/views/video_list_widget.dart';


class AppSearchBarDelegate extends SearchDelegate<String> {

  AppSearchBarDelegate({
      String hintText,
  }) : super(
       searchFieldLabel: hintText,
       keyboardType: TextInputType.text,
       textInputAction: TextInputAction.search,
  );

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle d = TextStyle(color: Colors.yellow);
    return theme.copyWith(
      primaryColor: theme.appBarTheme.color,
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.white),
      inputDecorationTheme: InputDecorationTheme(
            hintStyle: TextStyle(color: theme.textTheme.subtitle.color)),
      // primaryTextTheme: 
    );
  }
  
  @override
  List<Widget> buildActions(BuildContext context) {
    return query.isEmpty ? [] : [
      IconButton(
        color: Theme.of(context).textTheme.subtitle.color,
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
          // showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
    icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow, 
        progress: transitionAnimation,
        color: Theme.of(context).textTheme.subtitle.color,
    ),
    onPressed: () {
      if (query.isEmpty) {
        close(context, null);
      } else {
        query = "";
        // showSuggestions(context);
      }
    },
  );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }

    return VideoListWidget(
      parentContext: context,
      url: API_Search,
      initialRefresh: true,
      paramsCallback: (page){
        RequestParams requestParams = RequestParams.search(query, page, 20);
        return requestParams.getParams();
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }

}