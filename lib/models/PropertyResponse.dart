import 'package:real_estate_brokers/models/AmenityResponse.dart';
import 'package:real_estate_brokers/models/CategoryResponse.dart' as c;

class PropertyListResponse {
  PropertyListResponse({
      List<Property>? property,
      List<c.Category>? category,
  });

  PropertyListResponse.fromJson(dynamic json) {
    if (json['property'] != null) {
      property = [];
      json['property'].forEach((v) {
        property?.add(Property.fromJson(v));
      });
    }
    if (json['category'] != null) {
      category = [];
      json['category'].forEach((v) {
        category?.add(c.Category.fromJson(v));
      });
    }
  }
  List<Property>? property;
  List<c.Category>? category;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (property != null) {
      map['property'] = property?.map((v) => v.toJson()).toList();
    }
    if (category != null) {
      map['category'] = category?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class PropertyResponse {
  PropertyResponse({
      Property? property,
      c.Category? category,
  });

  PropertyResponse.fromJson(dynamic json) {
    property = json['property'] != null ? Property.fromJson(json['property']) : Property();
    category = json['category'] != null ? c.Category.fromJson(json['category']) : c.Category();
  }
  Property? property;
  c.Category? category;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['property'] = property?.toJson();
    map['category'] = category?.toJson();
    return map;
  }

}

class Property {
  Property({
    Details? details,
    List<Images>? images,
    List<Amenity>? amenities,});

  Property.fromJson(dynamic json) {
    print(json['details']);
    print(json['amenity']);
    details = json['details']!=null ? Details.fromJson(json['details']) : Details();
    if (json['images'] != null) {
      images = [];
      json['images'].forEach((v) {
        images?.add(Images.fromJson(v));
      });
    }
    if (json['amenities'] != null) {
      amenities = [];
      json['amenities'].forEach((v) {
        amenities?.add(Amenity.fromJson(v));
      });
    }
  }

  Details? details;
  List<Images>? images;
  List<Amenity>? amenities;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['details'] = details?.toJson();
    if (images != null) {
      map['images'] = images?.map((v) => v.toJson()).toList();
    }
    if (amenities != null) {
      map['amenities'] = amenities?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Images {
  Images({
      String? id,
      String? image,
      String? sp_id,});

  Images.fromJson(dynamic json) {
    id = json['id'];
    image = json['image'];
    sp_id = json['sp_id'];
  }

  String? id;
  String? image;
  String? sp_id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['image'] = image;
    map['sp_id'] = sp_id;
    return map;
  }

}

class Details {
  Details({
    String? id,
    String? txnDate,
    String? broker,
    String? customerID,
    String? categoryID,
    String? purpose,
    String? brokerType,
    String? brokerID,
    String? sqftSuper,
    String? sqftCarpet,
    String? rate,
    String? amount,
    String? bhk,
    String? varr,
    String? vigha,
    String? area,
    String? subArea,
    String? city,
    String? size,
    String? number,
    String? blockNumber,
    String? tPSurveyNo,
    String? village,
    String? furnishedOrNot,
    String? floor,
    String? condition,
    String? remarks,
    String? project,
    String? construction,
    String? possessionDate,
    String? saleType,
    String? brochure,
    String? rera,
    String? status,
    String? projectName,
    String? areaName,
    String? categoryName,
    String? wishlist,
  }){
    id = id;
    txnDate = txnDate;
    broker = broker;
    customerID = customerID;
    categoryID = categoryID;
    purpose = purpose;
    brokerType = brokerType;
    brokerID = brokerID;
    sqftSuper = sqftSuper;
    sqftCarpet = sqftCarpet;
    rate = rate;
    amount = amount;
    bhk = bhk;
    varr = varr;
    vigha = vigha;
    area = area;
    subArea = subArea;
    city = city;
    size = size;
    number = number;
    blockNumber = blockNumber;
    tPSurveyNo = tPSurveyNo;
    village = village;
    furnishedOrNot = furnishedOrNot;
    floor = floor;
    condition = condition;
    remarks = remarks;
    project = project;
    construction = construction;
    possessionDate = possessionDate;
    saleType = saleType;
    brochure = brochure;
    rera = rera;
    status = status;
    projectName = projectName;
    areaName = areaName;
    categoryName = categoryName;
    wishlist = wishlist;
  }

  Details.fromJson(dynamic json) {
    id = json['ID'];
    txnDate = json['TxnDate'];
    broker = json['Broker'];
    customerID = json['CustomerID'];
    categoryID = json['CategoryID'];
    purpose = json['Purpose'];
    brokerType = json['BrokerType'];
    brokerID = json['BrokerID'];
    sqftSuper = json['sqft_super'];
    sqftCarpet = json['sqft_carpet'];
    rate = json['Rate'];
    amount = json['Amount'];
    bhk = json['bhk'];
    varr = json['Var'];
    vigha = json['Vigha'];
    area = json['Area'];
    subArea = json['SubArea'];
    city = json['City'];
    size = json['Size'];
    number = json['Number'];
    blockNumber = json['BlockNumber'];
    tPSurveyNo = json['TPSurveyNo'];
    village = json['Village'];
    furnishedOrNot = json['FurnishedOrNot'];
    floor = json['Floor'];
    condition = json['Condition'];
    remarks = json['Remarks'];
    project = json['Project'];
    construction = json['construction'];
    possessionDate = json['possession_date'];
    saleType = json['sale_type'];
    brochure = json['brochure'];
    rera = json['rera'];
    status = json['status'];
    projectName = json['project_name'];
    areaName = json['area_name'];
    categoryName = json['category_name'];
    wishlist = json['wishlist'];
  }
  String? id;
  String? txnDate;
  String? broker;
  String? customerID;
  String? categoryID;
  String? purpose;
  String? brokerType;
  String? brokerID;
  String? sqftSuper;
  String? sqftCarpet;
  String? rate;
  String? amount;
  String? bhk;
  String? varr;
  String? vigha;
  String? area;
  String? subArea;
  String? city;
  String? size;
  String? number;
  String? blockNumber;
  String? tPSurveyNo;
  String? village;
  String? furnishedOrNot;
  String? floor;
  String? condition;
  String? remarks;
  String? project;
  String? construction;
  String? possessionDate;
  String? saleType;
  String? brochure;
  String? rera;
  String? status;
  String? projectName;
  String? areaName;
  String? categoryName;
  String? wishlist;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ID'] = id;
    map['TxnDate'] = txnDate;
    map['Broker'] = broker;
    map['CustomerID'] = customerID;
    map['CategoryID'] = categoryID;
    map['Purpose'] = purpose;
    map['BrokerType'] = brokerType;
    map['BrokerID'] = brokerID;
    map['sqft_super'] = sqftSuper;
    map['sqft_carpet'] = sqftCarpet;
    map['Rate'] = rate;
    map['Amount'] = amount;
    map['bhk'] = bhk;
    map['Var'] = varr;
    map['Vigha'] = vigha;
    map['Area'] = area;
    map['SubArea'] = subArea;
    map['City'] = city;
    map['Size'] = size;
    map['Number'] = number;
    map['BlockNumber'] = blockNumber;
    map['TPSurveyNo'] = tPSurveyNo;
    map['Village'] = village;
    map['FurnishedOrNot'] = furnishedOrNot;
    map['Floor'] = floor;
    map['Condition'] = condition;
    map['Remarks'] = remarks;
    map['Project'] = project;
    map['construction'] = construction;
    map['possession_date'] = possessionDate;
    map['sale_type'] = saleType;
    map['brochure'] = brochure;
    map['rera'] = rera;
    map['status'] = status;
    map['project_name'] = projectName;
    map['area_name'] = areaName;
    map['category_name'] = categoryName;
    map['wishlist'] = wishlist;
    return map;
  }

}