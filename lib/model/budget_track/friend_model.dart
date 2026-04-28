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
