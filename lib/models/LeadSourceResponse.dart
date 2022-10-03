/// leadSources : [{"id":"2","source":"Direct Marketing"},{"id":"1","source":"Friend"},{"id":"3","source":"Outbound Call"},{"id":"4","source":"Referral"},{"id":"5","source":"Social Media"}]

class LeadSourceResponse {
  LeadSourceResponse({
      List<LeadSources>? leadSources,}){
    leadSources = leadSources;
}

  LeadSourceResponse.fromJson(dynamic json) {
    if (json['leadSources'] != null) {
      leadSources = [];
      json['leadSources'].forEach((v) {
        leadSources?.add(LeadSources.fromJson(v));
      });
    }
  }
  List<LeadSources>? leadSources;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (leadSources != null) {
      map['leadSources'] = leadSources?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "2"
/// source : "Direct Marketing"

class LeadSources {
  LeadSources({
      String? id, 
      String? source,}){
    id = id;
    source = source;
}

  LeadSources.fromJson(dynamic json) {
    id = json['id'];
    source = json['source'];
  }
  String? id;
  String? source;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['source'] = source;
    return map;
  }

}