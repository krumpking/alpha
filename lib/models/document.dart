class Document {
  String documentName;
  String documentUrl;
  String? expiryDate;

  Document({
    required this.documentName,
    required this.documentUrl,
    this.expiryDate,
  });

  Map<String, dynamic> toJson() => {
    'documentName': documentName,
    'documentUrl': documentUrl,
    'expiryDate': expiryDate,
  };

  factory Document.fromJson(Map<String, dynamic> json) => Document(
    documentName: json['documentName'],
    documentUrl: json['documentUrl'],
    expiryDate: json['expiryDate'],
  );
}
