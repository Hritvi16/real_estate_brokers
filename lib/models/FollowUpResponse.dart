/// followUp : [{"id":"1","lp_id":"2","name":"task1","details":"det","datetime":"2022-09-05 17:47:56","created_by":"1","created_at":"2022-09-05 17:48:08"}]

class FollowUpResponse {
  FollowUpResponse({
      List<FollowUp>? followUp,}){
    _followUp = followUp;
}

  FollowUpResponse.fromJson(dynamic json) {
    if (json['followUp'] != null) {
      _followUp = [];
      json['followUp'].forEach((v) {
        _followUp?.add(FollowUp.fromJson(v));
      });
    }
  }
  List<FollowUp>? _followUp;

  List<FollowUp>? get followUp => _followUp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_followUp != null) {
      map['followUp'] = _followUp?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class FollowUpDetailResponse {
  FollowUpDetailResponse({
      FollowUp? followUp,}){
    followUp = followUp;
}

  FollowUpDetailResponse.fromJson(dynamic json) {
    followUp = FollowUp.fromJson(json['followUp']);
  }
  FollowUp? followUp;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['followUp'] = followUp?.toJson();
    return map;
  }

}

/// id : "1"
/// lp_id : "2"
/// name : "task1"
/// details : "det"
/// datetime : "2022-09-05 17:47:56"
/// created_by : "1"
/// created_at : "2022-09-05 17:48:08"

class FollowUp {
  FollowUp({
      String? id, 
      String? lpId, 
      String? name, 
      String? details, 
      String? datetime, 
      String? createdBy, 
      String? createdAt,
      String? createdName,
      String? leadName,
      String? status,
  }){
    id = id;
    lpId = lpId;
    name = name;
    details = details;
    datetime = datetime;
    createdBy = createdBy;
    createdAt = createdAt;
    createdName = createdName;
    leadName = leadName;
    status = status;
}

  FollowUp.fromJson(dynamic json) {
    id = json['id'];
    lpId = json['lp_id'];
    name = json['name'];
    details = json['details'];
    datetime = json['datetime'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    createdName = json['created_name'];
    leadName = json['lead_name'];
    status = json['status'];
  }
  String? id;
  String? lpId;
  String? name;
  String? details;
  String? datetime;
  String? createdBy;
  String? createdAt;
  String? createdName;
  String? leadName;
  String? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['lp_id'] = lpId;
    map['name'] = name;
    map['details'] = details;
    map['datetime'] = datetime;
    map['created_by'] = createdBy;
    map['created_at'] = createdAt;
    map['created_name'] = createdName;
    map['lead_name'] = leadName;
    map['status'] = status;
    return map;
  }

}