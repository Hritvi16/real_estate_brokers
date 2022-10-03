/// deal : [{"id":"1","lp_id":"2","name":"bn","details":"ghh","amount":"4000","commission":"1","type":"1","created_by":"1","created_at":"2022-09-07 12:28:34","created_name":"Self"}]

class DealResponse {
  DealResponse({
      List<Deal>? deal,}){
    _deal = deal;
}

  DealResponse.fromJson(dynamic json) {
    if (json['deal'] != null) {
      _deal = [];
      json['deal'].forEach((v) {
        _deal?.add(Deal.fromJson(v));
      });
    }
  }
  List<Deal>? _deal;

  List<Deal>? get deal => _deal;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_deal != null) {
      map['deal'] = _deal?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "1"
/// lp_id : "2"
/// name : "bn"
/// details : "ghh"
/// amount : "4000"
/// commission : "1"
/// type : "1"
/// created_by : "1"
/// created_at : "2022-09-07 12:28:34"
/// created_name : "Self"

class Deal {
  Deal({
      String? id, 
      String? lpId, 
      String? name, 
      String? details, 
      String? amount, 
      String? commission, 
      String? type, 
      String? createdBy, 
      String? createdAt, 
      String? createdName,}){
    _id = id;
    _lpId = lpId;
    _name = name;
    _details = details;
    _amount = amount;
    _commission = commission;
    _type = type;
    _createdBy = createdBy;
    _createdAt = createdAt;
    _createdName = createdName;
}

  Deal.fromJson(dynamic json) {
    _id = json['id'];
    _lpId = json['lp_id'];
    _name = json['name'];
    _details = json['details'];
    _amount = json['amount'];
    _commission = json['commission'];
    _type = json['type'];
    _createdBy = json['created_by'];
    _createdAt = json['created_at'];
    _createdName = json['created_name'];
  }
  String? _id;
  String? _lpId;
  String? _name;
  String? _details;
  String? _amount;
  String? _commission;
  String? _type;
  String? _createdBy;
  String? _createdAt;
  String? _createdName;

  String? get id => _id;
  String? get lpId => _lpId;
  String? get name => _name;
  String? get details => _details;
  String? get amount => _amount;
  String? get commission => _commission;
  String? get type => _type;
  String? get createdBy => _createdBy;
  String? get createdAt => _createdAt;
  String? get createdName => _createdName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['lp_id'] = _lpId;
    map['name'] = _name;
    map['details'] = _details;
    map['amount'] = _amount;
    map['commission'] = _commission;
    map['type'] = _type;
    map['created_by'] = _createdBy;
    map['created_at'] = _createdAt;
    map['created_name'] = _createdName;
    return map;
  }

}