
class DB_Model{
  String _movieName;
  static final posterURL = "https://image.tmdb.org/t/p/w500/";
  String get movieName => _movieName;
  String _releasedate;
  String _posterUrl;
  DB_Model(this._movieName, this._releasedate, this._posterUrl);

  String get releasedate => _releasedate;

  String get posterUrl => _posterUrl;

  DB_Model.fromJson(Map<String,dynamic> json):
        _movieName = json['movieName'],
        _posterUrl = json['posterImage'],
        _releasedate = json['releaseDate'];
}