class ListModel {
  int id;
  String title;
  String image;
  String releaseDate;
  String vote;

  ListModel(
      {required this.id,
      required this.title,
      required this.image,
      required this.releaseDate,
      required this.vote});

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'image': image,
        'releaseDate': releaseDate,
        'vote': vote,
      };
}

class MovieDetails {
  String title;
  String image;
  String description;
  List genre;
  String releaseDate;
  List cast;

  MovieDetails(
      {required this.title,
      required this.image,
      required this.description,
      required this.genre,
      required this.releaseDate,
      required this.cast});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'image': image,
      'description': description,
      'genre': genre,
      'releaseDate': releaseDate,
      'cast': cast,
    };
  }
}
