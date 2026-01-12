class TagsResponseModel {
  final List<TagModel> tags;
  final int total;

  TagsResponseModel({required this.tags, required this.total});

  factory TagsResponseModel.fromJson(Map<String, dynamic> json) {
    try {
      return TagsResponseModel(
        tags:
            (json['data']?['tags'] as List<dynamic>?)
                ?.map(
                  (tagJson) =>
                      TagModel.fromJson(tagJson as Map<String, dynamic>),
                )
                .toList() ??
            [],
        total: json['data']?['total'] ?? 0,
      );
    } catch (e) {
      throw Exception('Error in TagsResponseModel: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {
        'tags': tags.map((tag) => tag.toJson()).toList(),
        'total': total,
      },
    };
  }
}

class TagModel {
  final String id;
  final String name;

  TagModel({required this.id, required this.name});

  factory TagModel.fromJson(Map<String, dynamic> json) {
    try {
      return TagModel(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
      );
    } catch (e) {
      throw Exception('Error in Tag.fromJson: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
