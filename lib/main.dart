import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttersqflite/DB_Model.dart';
import 'package:fluttersqflite/MoviesModel.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'database_helper.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final dbHelper = DatabaseHelper.instance;
  var _db_model  = new List<DB_Model>();
  Future<String> loadMovieDataFromRest() async{
    var url = "https://api.themoviedb.org/3/trending/all/day?api_key=7711acb8f8b6f3055042df7bd9262609";
    var response = await http.get(url);
    return response.body;
  }
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onRefresh() async{
    // monitor network fetch
    loadMovieData();
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    loadMovieData();
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    if(mounted)
      setState(() {

      });
    _refreshController.loadComplete();
  }
  Future loadMovieData() async {
    String jsonResponse = await loadMovieDataFromRest();
    final jsonMovieData = json.decode(jsonResponse);
    MoviesModel model = new MoviesModel.fromJson(jsonMovieData);
    print("Movie Title" + model.results[0].title);
    for(var i = 0; i< model.results.length; i++){

      _insert(model.results[i].title, model.results[i].releaseDate, model.results[i].posterPath);

    }

  }
  


  @override
  void initState() {
    super.initState();

    loadMovieData();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
       
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: SingleChildScrollView(
          child: Container(
            child: _db_model.length<=0 ?Center(
              child: Text("No Movies Found"),
            ): ListView.builder(
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.fromLTRB(0, 50, 0, 50),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _db_model.length,
              itemBuilder: (context,index){
                return ListTile(title:Container(
                  height: 500,
                  width: 500,
                  child: Card(
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    elevation: 4.0,
                    color: Colors.black54,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: <Widget>[
                        Text(_db_model[index].movieName,
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                        Text(_db_model[index].releasedate,
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                        Image.network(DB_Model.posterURL + _db_model[index].posterUrl,height: 400),
                      ],
                    ),
                  ),
                ),
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _deleteAllData,
        tooltip: 'Increment',
        child: Icon(Icons.delete_forever),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _insert(String movieName, DateTime releaseDate, String moviePosterName) async {
    // row to insert
    try{
      Map<String, dynamic> row = {
        DatabaseHelper.columnMovieName : movieName,
        DatabaseHelper.columnReleaseData  : releaseDate.toString(),
        DatabaseHelper.columnPosterImage : moviePosterName
      };
      final id = await dbHelper.insert(row);
      _getMoviesDataLocal();
      print('inserted row id: $id');
    } on Exception catch(_){
      print("Exception caught");
    }

  }

  void _getMoviesDataLocal() async{
    Iterable list = await dbHelper.getAllMovies();
    setState(() {
      _db_model = list.map((model) => DB_Model.fromJson(model)).toList();
    });
  }

  void _deleteAllData() async{

    await dbHelper.delete();
    setState(() {
      _db_model  = new List<DB_Model>();
    });

  }
}
