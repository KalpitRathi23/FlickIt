class Drill {
  final String id;
  final String name;
  final int totalCount;
  final String imageUrl;

  Drill({
    required this.id,
    required this.name,
    required this.totalCount,
    required this.imageUrl,
  });

  factory Drill.fromJson(Map<String, dynamic> json) {
    return Drill(
      id: json['_id'],
      name: json['name'],
      totalCount: json['totalCount'],
      imageUrl: json['imageUrl'],
    );
  }
}
