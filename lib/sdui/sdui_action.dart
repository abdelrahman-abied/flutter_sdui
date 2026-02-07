class SDUIAction {
  final String type;
  final String? url;
  final Map<String, dynamic>? payload;

  SDUIAction({
    required this.type,
    this.url,
    this.payload,
  });

  factory SDUIAction.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return SDUIAction(
      type: json['type'] ?? 'unknown',
      url: json['url'],
      payload: data is Map ? Map<String, dynamic>.from(data) : null,
    );
  }
}