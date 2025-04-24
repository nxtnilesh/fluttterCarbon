class CarbonCredit {
  final String id;
  final String companyName;
  final String companySector;
  final int credits;
  final double pricePerCredit;
  final String description;
  final String status;
  final String verificationStatus;
  final List<String> verificationDocuments;
  final String sellerId;

  CarbonCredit({
    required this.id,
    required this.companyName,
    required this.companySector,
    required this.credits,
    required this.pricePerCredit,
    required this.description,
    required this.status,
    required this.verificationStatus,
    required this.verificationDocuments,
    required this.sellerId,
  });

  factory CarbonCredit.fromJson(Map<String, dynamic> json) {
    return CarbonCredit(
      id: json['_id'],
      companyName: json['companyName'],
      companySector: json['companySector'],
      credits: json['credits'],
      pricePerCredit: json['pricePerCredit'].toDouble(),
      description: json['description'],
      status: json['status'],
      verificationStatus: json['verificationStatus'],
      verificationDocuments: List<String>.from(json['verificationDocuments']),
      sellerId: json['seller'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'companyName': companyName,
      'companySector': companySector,
      'credits': credits,
      'pricePerCredit': pricePerCredit,
      'description': description,
      'verificationDocuments': verificationDocuments,
    };
  }
} 