class Merchant {
  double wallet;
  double collected;
  double reservations;
  double payments;
  Chat chat;

  Merchant({
    required this.wallet,
    required this.collected,
    required this.reservations,
    required this.payments,
    required this.chat,
  });

  factory Merchant.fromJson(Map<String, dynamic> json) {
    return Merchant(
      wallet: (json['wallet'] ?? 0).toDouble(),
      collected: (json['collected'] ?? 0).toDouble(),
      reservations: (json['reservations'] ?? 0).toDouble(),
      payments: (json['payments'] ?? 0).toDouble(),
      chat: Chat.fromJson(json['chat'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wallet': wallet,
      'collected': collected,
      'reservations': reservations,
      'payments': payments,
      'chat': chat.toJson(),
    };
  }
}

class Chat {
  double reservations;
  double payments;

  Chat({
    required this.reservations,
    required this.payments,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      reservations: (json['reservations'] ?? 0).toDouble(),
      payments: (json['payments'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reservations': reservations,
      'payments': payments,
    };
  }
}
