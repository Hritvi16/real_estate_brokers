/// status : [{"id":"1","status":"New Lead","lmid":null},{"id":"2","status":"Interested","lmid":null},{"id":"3","status":"Unanswered","lmid":null},{"id":"4","status":"Busy","lmid":null},{"id":"5","status":"Not Interested","lmid":null},{"id":"6","status":"Converted","lmid":null},{"id":"7","status":"helel","lmid":"1"}]

class StatusResponse {
  StatusResponse({
      List<Status>? status,}){
    status = status;
}

  StatusResponse.fromJson(dynamic json) {
    if (json['status'] != null) {
      status = [];
      json['status'].forEach((v) {
        status?.add(Status.fromJson(v));
      });
    }
  }
  List<Status>? status;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (status != null) {
      map['status'] = status?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "1"
/// status : "New Lead"
/// lmid : null

class Status {
  Status({
      String? id, 
      String? status, 
      String? color,
      String? lmId,
      String? count,

  }){
    id = id;
    status = status;
    color = color;
    lmId = lmId;
    count = count;
}

  Status.fromJson(dynamic json) {
    id = json['id'];
    status = json['status'];
    color = json['color'];
    lmId = json['lm_id'];
    count = json['count'];
  }
  String? id;
  String? status;
  String? color;
  String? lmId;
  String? count;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['status'] = status;
    map['color'] = color;
    map['lm_id'] = lmId;
    map['count'] = count;
    return map;
  }

}