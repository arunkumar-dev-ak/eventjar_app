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
    title: "Goa Trip",
    location: "Goa, India",
    members: 4,
    expenses: 12,
    youOwe: 1200,
    youGet: 3000,
    lastActivity: "2 days ago",
    isActive: true,
    budget: 20000,
    individualSpent: 13500,
    totalSpent: 18000,
    pendingSettlements: 2,
    lastActivityDate: "2026-04-20",
    notes:
        "Hotel, bike rentals, beach activities covered. Pending dinner & cab.",
  ),

  /// 🔴 INACTIVE
  TripModel(
    title: "Manali Ride",
    location: "Manali",
    members: 6,
    expenses: 20,
    youOwe: 20000,
    youGet: 0,
    lastActivity: "1 week ago",
    isActive: false,
    budget: 60000,
    individualSpent: 40000,
    totalSpent: 45000,
    pendingSettlements: 2,
    lastActivityDate: "2026-04-15",
  ),

  TripModel(
    title: "Chennai Meetup",
    location: "Chennai",
    members: 3,
    expenses: 5,
    youOwe: 0,
    youGet: 0,
    lastActivity: "3 days ago",
    isActive: false,
    individualSpent: 19000,
    totalSpent: 50000,
    pendingSettlements: 0,
    lastActivityDate: "2026-04-18",
  ),

  TripModel(
    title: "Ooty Escape",
    location: "Ooty",
    members: 5,
    expenses: 10,
    youOwe: 1500,
    youGet: 500,
    lastActivity: "5 days ago",
    isActive: false,
    budget: 25000,
    individualSpent: 21000,
    totalSpent: 23000,
    pendingSettlements: 1,
    lastActivityDate: "2026-04-14",
  ),

  TripModel(
    title: "Bangalore Party",
    location: "Bangalore",
    members: 4,
    expenses: 8,
    youOwe: 0,
    youGet: 1200,
    lastActivity: "1 week ago",
    isActive: false,
    budget: 15000,
    individualSpent: 12000,
    totalSpent: 14000,
    pendingSettlements: 0,
    lastActivityDate: "2026-04-13",
  ),

  TripModel(
    title: "Pondicherry Chill",
    location: "Pondicherry",
    members: 3,
    expenses: 6,
    youOwe: 500,
    youGet: 0,
    lastActivity: "4 days ago",
    isActive: false,
    budget: 12000,
    individualSpent: 10000,
    totalSpent: 11000,
    pendingSettlements: 1,
    lastActivityDate: "2026-04-17",
  ),

  TripModel(
    title: "Hyderabad Food Tour",
    location: "Hyderabad",
    members: 5,
    expenses: 15,
    youOwe: 2500,
    youGet: 0,
    lastActivity: "10 days ago",
    isActive: false,
    budget: 30000,
    individualSpent: 27000,
    totalSpent: 29000,
    pendingSettlements: 3,
    lastActivityDate: "2026-04-10",
  ),

  TripModel(
    title: "Coorg Nature Trip",
    location: "Coorg",
    members: 4,
    expenses: 9,
    youOwe: 0,
    youGet: 800,
    lastActivity: "6 days ago",
    isActive: false,
    budget: 22000,
    individualSpent: 18000,
    totalSpent: 20000,
    pendingSettlements: 0,
    lastActivityDate: "2026-04-12",
  ),

  TripModel(
    title: "Mumbai Visit",
    location: "Mumbai",
    members: 6,
    expenses: 18,
    youOwe: 3000,
    youGet: 1000,
    lastActivity: "2 weeks ago",
    isActive: false,
    budget: 50000,
    individualSpent: 42000,
    totalSpent: 47000,
    pendingSettlements: 2,
    lastActivityDate: "2026-04-05",
  ),

  TripModel(
    title: "Kerala Backwaters",
    location: "Kerala",
    members: 4,
    expenses: 11,
    youOwe: 0,
    youGet: 2000,
    lastActivity: "8 days ago",
    isActive: false,
    budget: 35000,
    individualSpent: 30000,
    totalSpent: 33000,
    pendingSettlements: 0,
    lastActivityDate: "2026-04-11",
  ),

  TripModel(
    title: "Delhi Exploration",
    location: "Delhi",
    members: 5,
    expenses: 14,
    youOwe: 1800,
    youGet: 0,
    lastActivity: "12 days ago",
    isActive: false,
    budget: 40000,
    individualSpent: 36000,
    totalSpent: 38000,
    pendingSettlements: 2,
    lastActivityDate: "2026-04-08",
  ),
];
