/// filter : [{"id":"1","lmid":"1","filter":" AND c.type='COMMERCIAL' AND sp.Purpose IN ('SALE') AND sp.City=2347","name":"Test1"},{"id":"2","lmid":"1","filter":" AND c.type='COMMERCIAL' AND sp.Purpose IN ('SALE') AND sp.City=2347","name":"dr"},{"id":"5","lmid":"1","filter":" AND c.type='COMMERCIAL' AND sp.Purpose IN ('SALE') AND sp.City=2347","name":"Test2"},{"id":"6","lmid":"1","filter":" AND c.type='NON COMMERCIAL' AND sp.Purpose IN ('SALE') AND sp.City=2347 AND c.name IN ('FLAT')","name":"Test3"}]

class FilterResponse {
  FilterResponse({
      List<Filter>? filter,}){
    filter = filter;
}

  FilterResponse.fromJson(dynamic json) {
    if (json['filter'] != null) {
      filter = [];
      json['filter'].forEach((v) {
        filter?.add(Filter.fromJson(v));
      });
    }
  }
  List<Filter>? filter;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (filter != null) {
      map['filter'] = filter?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "1"
/// lmid : "1"
/// filter : " AND c.type='COMMERCIAL' AND sp.Purpose IN ('SALE') AND sp.City=2347"
/// name : "Test1"

class Filter {
  Filter({
      String? id, 
      String? lmId, 
      String? filter, 
      String? name,
      String? description,
      String? createdAt,
  }){
    id = id;
    lmId = lmId;
    filter = filter;
    name = name;
    description = description;
    createdAt = createdAt;
}

  Filter.fromJson(dynamic json) {
    id = json['id'];
    lmId = json['lm_id'];
    filter = json['filter'];
    name = json['name'];
    description = json['description'];
    createdAt = json['created_at'];
  }
  String? id;
  String? lmId;
  String? filter;
  String? name;
  String? description;
  String? createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['lm_id'] = lmId;
    map['filter'] = filter;
    map['name'] = name;
    map['description'] = description;
    map['created_at'] = createdAt;
    return map;
  }

}