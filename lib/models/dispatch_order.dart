class DispatchOrder {
  final int id;
  final DateTime dateTime;
  final int createdBy;
  final bool notified;
  final String notes;
  final String createdByName;
  final String relatedUserNames;
  final String relatedEmployeeNames;

  DispatchOrder({
    required this.id,
    required this.dateTime,
    required this.createdBy,
    required this.notified,
    required this.notes,
    required this.createdByName,
    required this.relatedUserNames,
    required this.relatedEmployeeNames,
  });

  factory DispatchOrder.fromJson(Map<String, dynamic> json) {
    final dispatchOrderData = json['dispatchOrders'];
    
    return DispatchOrder(
      id: dispatchOrderData['Id'],
      dateTime: DateTime.parse(dispatchOrderData['dateTime']),
      createdBy: dispatchOrderData['createdBy'],
      notified: dispatchOrderData['notified'],
      notes: dispatchOrderData['notes'] ?? '',
      createdByName: json['CreatedByName'] ?? '',
      relatedUserNames: json['RelatedUserNames'] ?? '',
      relatedEmployeeNames: json['RelatedEmployeeNames'] ?? '',
    );
  }
}
