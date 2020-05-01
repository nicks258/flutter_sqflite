// To parse this JSON data, do
//
//     final moviesModel = moviesModelFromJson(jsonString);

import 'dart:convert';

MoviesModel moviesModelFromJson(String str) => MoviesModel.fromJson(json.decode(str));

String moviesModelToJson(MoviesModel data) => json.encode(data.toJson());

class MoviesModel {
  int page;
  List<Result> results;
  int totalPages;
  int totalResults;

  MoviesModel({
    this.page,
    this.results,
    this.totalPages,
    this.totalResults,
  });

  factory MoviesModel.fromJson(Map<String, dynamic> json) => MoviesModel(
    page: json["page"],
    results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
    totalPages: json["total_pages"],
    totalResults: json["total_results"],
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
    "total_pages": totalPages,
    "total_results": totalResults,
  };
}

class Result {
  int id;
  bool video;
  int voteCount;
  double voteAverage;
  String title;
  DateTime releaseDate;
  OriginalLanguage originalLanguage;
  String originalTitle;
  List<int> genreIds;
  String backdropPath;
  bool adult;
  String overview;
  String posterPath;
  double popularity;
  MediaType mediaType;
  String originalName;
  String name;
  DateTime firstAirDate;
  List<String> originCountry;

  Result({
    this.id,
    this.video,
    this.voteCount,
    this.voteAverage,
    this.title,
    this.releaseDate,
    this.originalLanguage,
    this.originalTitle,
    this.genreIds,
    this.backdropPath,
    this.adult,
    this.overview,
    this.posterPath,
    this.popularity,
    this.mediaType,
    this.originalName,
    this.name,
    this.firstAirDate,
    this.originCountry,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    video: json["video"] == null ? null : json["video"],
    voteCount: json["vote_count"],
    voteAverage: json["vote_average"].toDouble(),
    title: json["title"] == null ? null : json["title"],
    releaseDate: json["release_date"] == null ? null : DateTime.parse(json["release_date"]),
    originalLanguage: originalLanguageValues.map[json["original_language"]],
    originalTitle: json["original_title"] == null ? null : json["original_title"],
    genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
    backdropPath: json["backdrop_path"],
    adult: json["adult"] == null ? null : json["adult"],
    overview: json["overview"],
    posterPath: json["poster_path"],
    popularity: json["popularity"].toDouble(),
    mediaType: mediaTypeValues.map[json["media_type"]],
    originalName: json["original_name"] == null ? null : json["original_name"],
    name: json["name"] == null ? null : json["name"],
    firstAirDate: json["first_air_date"] == null ? null : DateTime.parse(json["first_air_date"]),
    originCountry: json["origin_country"] == null ? null : List<String>.from(json["origin_country"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "video": video == null ? null : video,
    "vote_count": voteCount,
    "vote_average": voteAverage,
    "title": title == null ? null : title,
    "release_date": releaseDate == null ? null : "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
    "original_language": originalLanguageValues.reverse[originalLanguage],
    "original_title": originalTitle == null ? null : originalTitle,
    "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
    "backdrop_path": backdropPath,
    "adult": adult == null ? null : adult,
    "overview": overview,
    "poster_path": posterPath,
    "popularity": popularity,
    "media_type": mediaTypeValues.reverse[mediaType],
    "original_name": originalName == null ? null : originalName,
    "name": name == null ? null : name,
    "first_air_date": firstAirDate == null ? null : "${firstAirDate.year.toString().padLeft(4, '0')}-${firstAirDate.month.toString().padLeft(2, '0')}-${firstAirDate.day.toString().padLeft(2, '0')}",
    "origin_country": originCountry == null ? null : List<dynamic>.from(originCountry.map((x) => x)),
  };
}

enum MediaType { MOVIE, TV }

final mediaTypeValues = EnumValues({
  "movie": MediaType.MOVIE,
  "tv": MediaType.TV
});

enum OriginalLanguage { EN, ES, PT }

final originalLanguageValues = EnumValues({
  "en": OriginalLanguage.EN,
  "es": OriginalLanguage.ES,
  "pt": OriginalLanguage.PT
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
