class Transaction {
  final String id;
  final String buyerId;
  final String sellerId;
  final String carbonCreditId;
  final int credits;
  final double pricePerCredit;
  final double totalAmount;
  final String status;
  final String paymentStatus;
  final DateTime createdAt;

  Transaction({
    required this.id,
    required this.buyerId,
    required this.sellerId,
    required this.carbonCreditId,
    required this.credits,
    required this.pricePerCredit,
    required this.totalAmount,
    required this.status,
    required this.paymentStatus,
    required this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['_id'],
      buyerId: json['buyer'],
      sellerId: json['seller'],
      carbonCreditId: json['carbonCredit'],
      credits: json['credits'],
      pricePerCredit: json['pricePerCredit'].toDouble(),
      totalAmount: json['totalAmount'].toDouble(),
      status: json['status'],
      paymentStatus: json['paymentStatus'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
} 