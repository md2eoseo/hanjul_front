import 'package:flutter/material.dart';

class SearchResultsListView extends StatefulWidget {
  const SearchResultsListView({
    Key key,
    this.keyword,
  }) : super(key: key);

  final keyword;

  @override
  _SearchResultsListViewState createState() => _SearchResultsListViewState();
}

class _SearchResultsListViewState extends State<SearchResultsListView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: _delayFetch(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            default:
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  snapshot.data.toString(),
                  style: TextStyle(fontSize: 15),
                ),
              );
          }
        },
      ),
    );
  }

  Future _delayFetch() async {
    await Future.delayed(Duration(milliseconds: 200));
    return widget.keyword;
  }
}
