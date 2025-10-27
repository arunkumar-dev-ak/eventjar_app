class Meta {
  final int total;
  final int page;
  final int limit;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  Meta({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    try {
      return Meta(
        total: json['total'] ?? 0,
        page: json['page'] ?? 1,
        limit: json['limit'] ?? 0,
        totalPages: json['totalPages'] ?? 1,
        hasNext: json['hasNext'] ?? false,
        hasPrevious: json['hasPrevious'] ?? false,
      );
    } catch (e) {
      throw Exception('Error in Meta: $e');
    }
  }

  Map<String, dynamic> toJson() => {
    'total': total,
    'page': page,
    'limit': limit,
    'totalPages': totalPages,
    'hasNext': hasNext,
    'hasPrevious': hasPrevious,
  };
}
