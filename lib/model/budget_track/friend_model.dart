class FriendModel {
  final String name;
  final double amount;

  final String email;
  final String? phone;

  final bool isYou;
  final bool youOwe;
  final bool isSettled;

  FriendModel({
    required this.name,
    required this.amount,
    required this.email,
    this.phone,
    this.isYou = false,
    this.youOwe = false,
    this.isSettled = false,
  });
}

final List<FriendModel> dummyFriends = [
  FriendModel(
    name: "You",
    amount: 0,
    email: "you@mail.com",
    phone: "9999999999",
    isYou: true,
    isSettled: true,
  ),
  FriendModel(
    name: "Rahul",
    amount: 1200,
    email: "rahul@mail.com",
    phone: "9876543210",
    youOwe: true,
  ),
  FriendModel(
    name: "Arjun",
    amount: 2500,
    email: "arjun@mail.com",
    phone: "9123456780",
    youOwe: false,
  ),
  FriendModel(
    name: "Karthik",
    amount: 0,
    email: "karthik@mail.com",
    phone: "9000000001",
    isSettled: true,
  ),
  FriendModel(
    name: "Vignesh",
    amount: 800,
    email: "vignesh@mail.com",
    phone: "9012345678",
    youOwe: true,
  ),
  FriendModel(
    name: "Sanjay",
    amount: 1500,
    email: "sanjay@mail.com",
    phone: "9090909090",
    youOwe: false,
  ),
  FriendModel(
    name: "Dinesh",
    amount: 0,
    email: "dinesh@mail.com",
    phone: "8888888888",
    isSettled: true,
  ),
];

final Map<String, List<FriendModel>> dummyTripFriends = {
  "Goa Beach Escape": [
    FriendModel(
      name: "You",
      amount: 0,
      email: "you@mail.com",
      phone: "9999999999",
      isYou: true,
      isSettled: true,
    ),

    // YOU OWE = 320
    FriendModel(
      name: "Rahul",
      amount: 120,
      email: "rahul@mail.com",
      phone: "9876543210",
      youOwe: true,
    ),

    FriendModel(
      name: "Karthik",
      amount: 200,
      email: "karthik@mail.com",
      phone: "9000000001",
      youOwe: true,
    ),

    // YOU RECEIVE = 120
    FriendModel(
      name: "Arjun",
      amount: 120,
      email: "arjun@mail.com",
      phone: "9123456780",
      youOwe: false,
    ),
  ],

  "Ooty Chill Trip": [
    FriendModel(
      name: "You",
      amount: 0,
      email: "you@mail.com",
      phone: "9999999999",
      isYou: true,
      isSettled: true,
    ),

    FriendModel(
      name: "Vignesh",
      amount: 180,
      email: "vignesh@mail.com",
      phone: "9012345678",
      youOwe: true,
    ),

    FriendModel(
      name: "Dinesh",
      amount: 0,
      email: "dinesh@mail.com",
      phone: "8888888888",
      isSettled: true,
    ),
  ],

  "Chennai Meetup": [
    FriendModel(
      name: "You",
      amount: 0,
      email: "you@mail.com",
      phone: "9999999999",
      isYou: true,
      isSettled: true,
    ),

    FriendModel(
      name: "Sanjay",
      amount: 150,
      email: "sanjay@mail.com",
      phone: "9090909090",
      youOwe: false,
    ),
  ],

  "Bangalore Weekend": [
    FriendModel(
      name: "You",
      amount: 0,
      email: "you@mail.com",
      phone: "9999999999",
      isYou: true,
      isSettled: true,
    ),

    FriendModel(
      name: "Rahul",
      amount: 220,
      email: "rahul@mail.com",
      phone: "9876543210",
      youOwe: true,
    ),

    FriendModel(
      name: "Arjun",
      amount: 0,
      email: "arjun@mail.com",
      phone: "9123456780",
      isSettled: true,
    ),

    FriendModel(
      name: "Vignesh",
      amount: 0,
      email: "vignesh@mail.com",
      phone: "9012345678",
      isSettled: true,
    ),
  ],

  "Pondicherry Ride": [
    FriendModel(
      name: "You",
      amount: 0,
      email: "you@mail.com",
      phone: "9999999999",
      isYou: true,
      isSettled: true,
    ),

    FriendModel(
      name: "Sanjay",
      amount: 200,
      email: "sanjay@mail.com",
      phone: "9090909090",
      youOwe: false,
    ),

    FriendModel(
      name: "Karthik",
      amount: 0,
      email: "karthik@mail.com",
      phone: "9000000001",
      isSettled: true,
    ),
  ],

  "Kerala Backwaters": [
    FriendModel(
      name: "You",
      amount: 0,
      email: "you@mail.com",
      phone: "9999999999",
      isYou: true,
      isSettled: true,
    ),

    FriendModel(
      name: "Rahul",
      amount: 150,
      email: "rahul@mail.com",
      phone: "9876543210",
      youOwe: true,
    ),

    FriendModel(
      name: "Vignesh",
      amount: 200,
      email: "vignesh@mail.com",
      phone: "9012345678",
      youOwe: true,
    ),

    FriendModel(
      name: "Arjun",
      amount: 0,
      email: "arjun@mail.com",
      phone: "9123456780",
      isSettled: true,
    ),
  ],

  "Hyderabad Food Tour": [
    FriendModel(
      name: "You",
      amount: 0,
      email: "you@mail.com",
      phone: "9999999999",
      isYou: true,
      isSettled: true,
    ),

    // OWE = 240
    FriendModel(
      name: "Rahul",
      amount: 240,
      email: "rahul@mail.com",
      phone: "9876543210",
      youOwe: true,
    ),

    // RECEIVE = 80
    FriendModel(
      name: "Sanjay",
      amount: 80,
      email: "sanjay@mail.com",
      phone: "9090909090",
      youOwe: false,
    ),

    FriendModel(
      name: "Dinesh",
      amount: 0,
      email: "dinesh@mail.com",
      phone: "8888888888",
      isSettled: true,
    ),
  ],

  "Coorg Nature Stay": [
    FriendModel(
      name: "You",
      amount: 0,
      email: "you@mail.com",
      phone: "9999999999",
      isYou: true,
      isSettled: true,
    ),

    FriendModel(
      name: "Arjun",
      amount: 170,
      email: "arjun@mail.com",
      phone: "9123456780",
      youOwe: false,
    ),

    FriendModel(
      name: "Karthik",
      amount: 0,
      email: "karthik@mail.com",
      phone: "9000000001",
      isSettled: true,
    ),
  ],
};
