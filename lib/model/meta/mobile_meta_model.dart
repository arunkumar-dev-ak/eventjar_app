class MobileMeta {
  final Paging paging;

  MobileMeta({required this.paging});

  factory MobileMeta.fromJson(Map<String, dynamic> json) {
    return MobileMeta(paging: Paging.fromJson(json['paging']));
  }

  Map<String, dynamic> toJson() => {'paging': paging.toJson()};
}

class Paging {
  final PagingLinks links;
  final PagingPages pages;
  final int totalCount;

  Paging({required this.links, required this.pages, required this.totalCount});

  factory Paging.fromJson(Map<String, dynamic> json) {
    return Paging(
      links: PagingLinks.fromJson(json['links']),
      pages: PagingPages.fromJson(json['pages']),
      totalCount: json['totalCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'links': links.toJson(),
    'pages': pages.toJson(),
    'totalCount': totalCount,
  };
}

class PagingLinks {
  final String? prev;
  final String? next;
  final String? current;

  PagingLinks({this.prev, this.next, this.current});

  factory PagingLinks.fromJson(Map<String, dynamic> json) {
    return PagingLinks(
      prev: json['prev'],
      next: json['next'],
      current: json['current'],
    );
  }

  Map<String, dynamic> toJson() => {
    'prev': prev,
    'next': next,
    'current': current,
  };
}

class PagingPages {
  final int total;
  final int? prev;
  final int? next;
  final int current;

  PagingPages({
    required this.total,
    this.prev,
    this.next,
    required this.current,
  });

  factory PagingPages.fromJson(Map<String, dynamic> json) {
    return PagingPages(
      total: json['total'] ?? 0,
      prev: json['prev'],
      next: json['next'],
      current: json['current'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
    'total': total,
    'prev': prev,
    'next': next,
    'current': current,
  };
}
