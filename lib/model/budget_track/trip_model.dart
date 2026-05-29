class TripModel {
  final String title;
  final String location;
  final int members;
  final int expenses;
  final double youOwe;
  final double youGet;
  final String lastActivity;
  final bool isActive;

  final double? budget;
  final double? individualSpent;
  final double? totalSpent;
  final int? pendingSettlements;
  final String? lastActivityDate;
  final String? notes;

  TripModel({
    required this.title,
    required this.location,
    required this.members,
    required this.expenses,
    required this.youOwe,
    required this.youGet,
    required this.lastActivity,
    required this.isActive,
    this.budget,
    this.individualSpent,
    this.totalSpent,
    this.pendingSettlements,
    this.lastActivityDate,
    this.notes,
  });

  /// 🔁 Convert from Map (useful for API later)
  factory TripModel.fromMap(Map<String, dynamic> map) {
    return TripModel(
      title: map["title"] ?? "",
      location: map["location"] ?? "",
      members: map["members"] ?? 0,
      expenses: map["expenses"] ?? 0,
      youOwe: (map["youOwe"] ?? 0).toDouble(),
      youGet: (map["youGet"] ?? 0).toDouble(),
      lastActivity: map["lastActivity"] ?? "",
      isActive: map["isActive"] ?? false,
      budget: map["budget"]?.toDouble(),
      individualSpent: map["individualSpent"]?.toDouble(),
      totalSpent: map["totalSpent"]?.toDouble(),
      pendingSettlements: map["pendingSettlements"],
      lastActivityDate: map["lastActivityDate"],
      notes: map["notes"],
    );
  }

  /// 🔁 Convert to Map (optional)
  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "location": location,
      "members": members,
      "expenses": expenses,
      "youOwe": youOwe,
      "youGet": youGet,
      "lastActivity": lastActivity,
      "isActive": isActive,
      "budget": budget,
      "individualSpent": individualSpent,
      "totalSpent": totalSpent,
      "pendingSettlements": pendingSettlements,
      "lastActivityDate": lastActivityDate,
      "notes": notes,
    };
  }
}

final List<TripModel> dummyTrips = [
  /// 🟢 ACTIVE
  TripModel(
    title: "Goa Beach Escape",
    location: "Goa",
    members: 4,
    expenses: 8,
    youOwe: 320,
    youGet: 120,
    lastActivity: "2 hours ago",
    isActive: true,
    budget: 4500,
    individualSpent: 800,
    totalSpent: 3900,
    pendingSettlements: 2,
    lastActivityDate: "2026-05-28",
    notes: "Beach stay, bike rentals, café hopping and watersports included.",
  ),

  /// 🔴 INACTIVE
  TripModel(
    title: "Ooty Chill Trip",
    location: "Ooty",
    members: 3,
    expenses: 6,
    youOwe: 180,
    youGet: 0,
    lastActivity: "3 days ago",
    isActive: false,
    budget: 3200,
    individualSpent: 2500,
    totalSpent: 2900,
    pendingSettlements: 1,
    lastActivityDate: "2026-05-25",
  ),

  TripModel(
    title: "Chennai Meetup",
    location: "Chennai",
    members: 2,
    expenses: 4,
    youOwe: 0,
    youGet: 150,
    lastActivity: "5 days ago",
    isActive: false,
    budget: 2500,
    individualSpent: 1900,
    totalSpent: 2200,
    pendingSettlements: 0,
    lastActivityDate: "2026-05-23",
  ),

  TripModel(
    title: "Bangalore Weekend",
    location: "Bangalore",
    members: 4,
    expenses: 7,
    youOwe: 220,
    youGet: 0,
    lastActivity: "1 week ago",
    isActive: false,
    budget: 4000,
    individualSpent: 3100,
    totalSpent: 3600,
    pendingSettlements: 1,
    lastActivityDate: "2026-05-20",
  ),

  TripModel(
    title: "Pondicherry Ride",
    location: "Pondicherry",
    members: 3,
    expenses: 5,
    youOwe: 0,
    youGet: 200,
    lastActivity: "6 days ago",
    isActive: false,
    budget: 2800,
    individualSpent: 2200,
    totalSpent: 2500,
    pendingSettlements: 0,
    lastActivityDate: "2026-05-22",
  ),

  TripModel(
    title: "Kerala Backwaters",
    location: "Kerala",
    members: 4,
    expenses: 9,
    youOwe: 350,
    youGet: 0,
    lastActivity: "10 days ago",
    isActive: false,
    budget: 5000,
    individualSpent: 3900,
    totalSpent: 4500,
    pendingSettlements: 2,
    lastActivityDate: "2026-05-18",
  ),

  TripModel(
    title: "Hyderabad Food Tour",
    location: "Hyderabad",
    members: 4,
    expenses: 8,
    youOwe: 240,
    youGet: 80,
    lastActivity: "2 weeks ago",
    isActive: false,
    budget: 4200,
    individualSpent: 3300,
    totalSpent: 3800,
    pendingSettlements: 1,
    lastActivityDate: "2026-05-15",
  ),

  TripModel(
    title: "Coorg Nature Stay",
    location: "Coorg",
    members: 3,
    expenses: 5,
    youOwe: 0,
    youGet: 170,
    lastActivity: "12 days ago",
    isActive: false,
    budget: 3000,
    individualSpent: 2400,
    totalSpent: 2700,
    pendingSettlements: 0,
    lastActivityDate: "2026-05-14",
  ),
];
