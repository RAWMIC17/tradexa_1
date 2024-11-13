class MovieModel {
  String title;
  String genre;
  String imdbRating;
  String poster;

  MovieModel({
    required this.title,
    required this.genre,
    required this.imdbRating,
    required this.poster,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) => MovieModel(
        title: json["Title"] ?? "Unknown Title",
        genre: _formatGenres(json["Genre"] ?? "Unknown Genre"),
        imdbRating: json["imdbRating"] ?? "N/A",
        poster: json["Poster"] ?? "",  // Assuming poster URL is also included in the response
      );

  // Helper function to format genres as "Action | Adventure | Comedy"
  static String _formatGenres(String genres) {
    // Split by commas and join with ' | '
    return genres.split(", ").join(" | ");
  }

  Map<String, dynamic> toJson() => {
        "Title": title,
        "Genre": genre,
        "imdbRating": imdbRating,
        "Poster": poster,
      };
}
