import 'package:eventjar/model/event_info/event_info_model.dart';
import 'package:get/get.dart';

class CartLine {
  final TicketTier ticket;
  final RxInt quantity;

  CartLine({required this.ticket, required int qty}) : quantity = qty.obs;

  Map<String, dynamic> toJson() {
    return {
      'tierId': ticket.id,
      'name': ticket.name,
      'description': ticket.description,
      'quantity': quantity.value,
      'unitPrice': double.tryParse(ticket.price) ?? 0.0,
      'totalPrice': (double.tryParse(ticket.price) ?? 0.0) * quantity.value,
    };
  }
}
