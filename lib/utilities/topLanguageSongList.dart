class Languagesong {
  final String name;
  final String imageUrl;

  const Languagesong({
    required this.name,
    required this.imageUrl,
  });
}

class LanguagesongList {
  static const List<Languagesong> languageInfo = [
    Languagesong(
        name: "Hindi Songs",
        imageUrl: "https://i.ibb.co/NxFbKS1/The-Art-of-Living.png"),
    Languagesong(
        name: "English Songs",
        imageUrl: "https://i.ibb.co/J7xbnhh/The-Art-of-Living-1.png"),
    Languagesong(
        name: "Punjabi Songs",
        imageUrl: "https://i.ibb.co/MkF8Kt8/The-Art-of-Living-3.png"),
    Languagesong(
        name: "Telugu Songs",
        imageUrl: "https://i.ibb.co/Dzgr4P9/The-Art-of-Living-2.png"),
    Languagesong(
        name: "Odia Songs",
        imageUrl: "https://i.ibb.co/QvbqWfn/The-Art-of-Living-4.png"),
    Languagesong(
        name: "Tamil Songs",
        imageUrl: "https://i.ibb.co/hZVPH3R/The-Art-of-Living-5.png"),
    Languagesong(
        name: "Bengali Songs",
        imageUrl: "https://i.ibb.co/mHBNg50/The-Art-of-Living-6.png"),
    Languagesong(
        name: "Malayalam Songs",
        imageUrl: "https://i.ibb.co/4mZ6gHn/The-Art-of-Living-7.png"),
  ];
}
