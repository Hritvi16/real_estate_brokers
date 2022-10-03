import 'package:real_estate_brokers/models/FollowUpResponse.dart';

class LeadDetailResponse {
  LeadDetailResponse({
      List<LeadDetails>? leadDetails,
      List<FollowUp>? followUp,
  }){
    leadDetails = leadDetails;
    followUp = followUp;
}

  LeadDetailResponse.fromJson(dynamic json) {
    if (json['lead_details'] != null) {
      leadDetails = [];
      json['lead_details'].forEach((v) {
        leadDetails?.add(LeadDetails.fromJson(v));
      });
    }
    if (json['followUp'] != null) {
      followUp = [];
      json['followUp'].forEach((v) {
        followUp?.add(FollowUp.fromJson(v));
      });
    }
  }
  List<LeadDetails>? leadDetails;
  List<FollowUp>? followUp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (leadDetails != null) {
      map['lead_details'] = leadDetails?.map((v) => v.toJson()).toList();
    }
    if (followUp != null) {
      map['followUp'] = followUp?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class LeadResponse {
  LeadResponse({
    List<Lead>? lead,}){
    lead = lead;
  }

  LeadResponse.fromJson(dynamic json) {
    if (json['lead'] != null) {
      lead = [];
      json['lead'].forEach((v) {
        lead?.add(Lead.fromJson(v));
      });
    }
  }
  List<Lead>? lead;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (lead != null) {
      map['lead'] = lead?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class LeadDetails {
  LeadDetails({
      Lead? lead, 
      Criteria? criteria,
      FollowUp? followUp,
  }){
    lead = lead;
    criteria = criteria;
    followUp = followUp;
}

  LeadDetails.fromJson(dynamic json) {
    lead = json['lead'] != null ? Lead.fromJson(json['lead']) : null;
    criteria = json['criteria'] != null ? Criteria.fromJson(json['criteria']) : null;
    followUp = json['followUp'] != null ? FollowUp.fromJson(json['followUp']) : null;
  }
  Lead? lead;
  Criteria? criteria;
  FollowUp? followUp;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (lead != null) {
      map['lead'] = lead?.toJson();
    }
    if (criteria != null) {
      map['criteria'] = criteria?.toJson();
    }
    if (followUp != null) {
      map['followUp'] = followUp?.toJson();
    }
    return map;
  }

}

class Criteria {
  Criteria({
      String? id,
      String? lId,
      String? sId,
      String? lsId,
      String? lmId,
      String? remarks,
      String? categoryType,
      String? purpose, 
      String? city, 
      String? areas, 
      String? subAreas, 
      String? category, 
      String? budget, 
      String? bhk, 
      String? ssf, 
      String? csf, 
      String? furnish, 
      String? floor, 
      String? rera, 
      String? filter,
      String? description,
      String? createdAt,
      String? status,
      String? source,
      String? assignedName,}){
    id = id;
    lId = lId;
    sId = sId;
    lsId = lsId;
    lmId = lmId;
    remarks = remarks;
    categoryType = categoryType;
    purpose = purpose;
    city = city;
    areas = areas;
    subAreas = subAreas;
    category = category;
    budget = budget;
    bhk = bhk;
    ssf = ssf;
    csf = csf;
    furnish = furnish;
    floor = floor;
    rera = rera;
    filter = filter;
    description = description;
    createdAt = createdAt;
    status = status;
    source = source;
    assignedName = assignedName;
}

  Criteria.fromJson(dynamic json) {
    id = json['id'];
    lId = json['l_id'];
    sId = json['s_id'];
    lsId = json['ls_id'];
    lmId = json['lm_id'];
    remarks = json['remarks'];
    categoryType = json['category_type'];
    purpose = json['purpose'];
    city = json['city'];
    areas = json['areas'];
    subAreas = json['sub_areas'];
    category = json['category'];
    budget = json['budget'];
    bhk = json['bhk'];
    ssf = json['ssf'];
    csf = json['csf'];
    furnish = json['furnish'];
    floor = json['floor'];
    rera = json['rera'];
    filter = json['filter'];
    description = json['description'];
    createdAt = json['created_at'];
    status = json['status'];
    source = json['source'];
    assignedName = json['assigned_name'];
  }
  String? id;
  String? lId;
  String? sId;
  String? lsId;
  String? lmId;
  String? createdBy;
  String? remarks;
  String? categoryType;
  String? purpose;
  String? city;
  String? areas;
  String? subAreas;
  String? category;
  String? budget;
  String? bhk;
  String? ssf;
  String? csf;
  String? furnish;
  String? floor;
  String? rera;
  String? filter;
  String? description;
  String? createdAt;
  String? status;
  String? source;
  String? assignedName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['l_id'] = lId;
    map['s_id'] = sId;
    map['ls_id'] = lsId;
    map['lm_id'] = lmId;
    map['created_by'] = createdBy;
    map['remarks'] = remarks;
    map['category_type'] = categoryType;
    map['purpose'] = purpose;
    map['city'] = city;
    map['areas'] = areas;
    map['sub_areas'] = subAreas;
    map['category'] = category;
    map['budget'] = budget;
    map['bhk'] = bhk;
    map['ssf'] = ssf;
    map['csf'] = csf;
    map['furnish'] = furnish;
    map['floor'] = floor;
    map['rera'] = rera;
    map['filter'] = filter;
    map['description'] = description;
    map['created_at'] = createdAt;
    map['status'] = status;
    map['source'] = source;
    map['assigned_name'] = assignedName;
    return map;
  }

}

class Lead {
  Lead({
      String? id, 
      String? name, 
      String? email, 
      String? mobile1, 
      String? mobile2, 
      String? address,
      String? createdBy,
      String? createdAt, }){
    id = id;
    name = name;
    email = email;
    mobile1 = mobile1;
    mobile2 = mobile2;
    address = address;
    createdBy = createdBy;
    createdAt = createdAt;
}

  Lead.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobile1 = json['mobile1'];
    mobile2 = json['mobile2'];
    address = json['address'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
  }
  String? id;
  String? name;
  String? email;
  String? mobile1;
  String? mobile2;
  String? address;
  String? createdBy;
  String? createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['mobile1'] = mobile1;
    map['mobile2'] = mobile2;
    map['address'] = address;
    map['created_by'] = createdBy;
    map['created_at'] = createdAt;
    return map;
  }

}