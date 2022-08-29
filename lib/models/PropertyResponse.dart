/// property : [{"ID":"2","Type":"Seller","TxnDate":"2021-05-21","Broker":"1","CustomerID":"30","CategoryID":"4","Purpose":"Sale","BrokerType":"Owner","BrokerID":"29","sqft":"1225","Rate":"35.51","bhk":"2","Var":"","Vigha":"","Area":"7","SubArea":"8","City":"2347","Size":"","Number":"","BlockNumber":"","TPSurveyNo":"","Village":"","FurnishedOrNot":"Furnished","Floor":null,"Condition":"","Remarks":"100 % EHITE PAYMENT FULLY VASTU","Project":"5","status":"1"},{"ID":"3","Type":"Seller","TxnDate":"2021-05-21","Broker":"1","CustomerID":"30","CategoryID":"7","Purpose":"Sale","BrokerType":"Reference","BrokerID":"31","sqft":"595","Rate":"20","bhk":"2","Var":"","Vigha":"","Area":"5","SubArea":"9","City":"2347","Size":"","Number":"","BlockNumber":"","TPSurveyNo":"","Village":"","FurnishedOrNot":"Non-Furnished","Floor":"1","Condition":"ATTACHED TOLIET","Remarks":"","Project":"6","status":"1"},{"ID":"4","Type":"Seller","TxnDate":"2021-05-21","Broker":"1","CustomerID":"30","CategoryID":"4","Purpose":"Rent","BrokerType":"Owner","BrokerID":"31","sqft":"2250","Rate":"","bhk":"3","Var":"","Vigha":"","Area":"3","SubArea":"10","City":"2347","Size":"","Number":"","BlockNumber":"","TPSurveyNo":"","Village":"","FurnishedOrNot":"Non-Furnished","Floor":"2","Condition":"KTLF","Remarks":"","Project":"7","status":"1"},{"ID":"5","Type":"Seller","TxnDate":"2022-01-07","Broker":"1","CustomerID":"32","CategoryID":"5","Purpose":"Sale","BrokerType":"Owner","BrokerID":null,"sqft":"190","Rate":"35","bhk":"2","Var":"","Vigha":"","Area":"18","SubArea":"11","City":"2347","Size":"9.5*20","Number":"","BlockNumber":"","TPSurveyNo":"","Village":"","FurnishedOrNot":"Furnished","Floor":"3","Condition":"","Remarks":"","Project":"8","status":"1"},{"ID":"6","Type":"Seller","TxnDate":"2022-01-07","Broker":"1","CustomerID":"30","CategoryID":"4","Purpose":"Sale","BrokerType":"Owner","BrokerID":"33","sqft":"3600","Rate":"209","bhk":"4","Var":"","Vigha":"","Area":"4","SubArea":"12","City":"2347","Size":"","Number":"","BlockNumber":"","TPSurveyNo":"","Village":"","FurnishedOrNot":"Non-Furnished","Floor":"4","Condition":"","Remarks":"","Project":"9","status":"1"},{"ID":"7","Type":"Seller","TxnDate":"2022-01-07","Broker":"1","CustomerID":"30","CategoryID":"4","Purpose":"Sale","BrokerType":"Owner","BrokerID":"34","sqft":"2155","Rate":"97","bhk":"3","Var":"","Vigha":"","Area":"8","SubArea":"13","City":"2347","Size":"","Number":"","BlockNumber":"","TPSurveyNo":"","Village":"","FurnishedOrNot":"Non-Furnished","Floor":null,"Condition":"","Remarks":"","Project":"10","status":"1"},{"ID":"8","Type":"Seller","TxnDate":"2022-01-07","Broker":"1","CustomerID":"30","CategoryID":"4","Purpose":"Sale","BrokerType":"Owner","BrokerID":"34","sqft":"1956","Rate":"90","bhk":"3","Var":"","Vigha":"","Area":"8","SubArea":"14","City":"2347","Size":"","Number":"","BlockNumber":"","TPSurveyNo":"","Village":"","FurnishedOrNot":"Non-Furnished","Floor":"5","Condition":"","Remarks":"","Project":"11","status":"1"},{"ID":"9","Type":"Seller","TxnDate":"2022-01-09","Broker":"1","CustomerID":"30","CategoryID":"6","Purpose":"Sale","BrokerType":"Owner","BrokerID":"35","sqft":"","Rate":"120","bhk":"2","Var":"","Vigha":"","Area":"20","SubArea":"15","City":"2347","Size":"","Number":"10","BlockNumber":"","TPSurveyNo":"","Village":"","FurnishedOrNot":"Furnished","Floor":null,"Condition":"","Remarks":"10 PLOTS *  12","Project":"12","status":"1"},{"ID":"10","Type":"Seller","TxnDate":"2022-01-07","Broker":"1","CustomerID":"30","CategoryID":"4","Purpose":"Rent","BrokerType":"Owner","BrokerID":"34","sqft":"","Rate":"","bhk":"3","Var":"","Vigha":"","Area":"21","SubArea":"16","City":"2347","Size":"","Number":"","BlockNumber":"","TPSurveyNo":"","Village":"","FurnishedOrNot":"Furnished","Floor":null,"Condition":"","Remarks":"","Project":"13","status":"1"},{"ID":"11","Type":"Seller","TxnDate":"2022-01-07","Broker":"1","CustomerID":"30","CategoryID":"4","Purpose":"Rent","BrokerType":"Owner","BrokerID":"34","sqft":"","Rate":"","bhk":"3","Var":"","Vigha":"","Area":"8","SubArea":"17","City":"2347","Size":"","Number":"","BlockNumber":"","TPSurveyNo":"","Village":"","FurnishedOrNot":"Furnished","Floor":null,"Condition":"","Remarks":"","Project":"14","status":"1"},{"ID":"12","Type":"Buyer","TxnDate":"2022-01-10","Broker":"1","CustomerID":"30","CategoryID":"4","Purpose":"Rent","BrokerType":"Owner","BrokerID":"37","sqft":"","Rate":"","bhk":"2","Var":"","Vigha":"","Area":"5","SubArea":null,"City":"2347","Size":"","Number":"","BlockNumber":"","TPSurveyNo":"","Village":"","FurnishedOrNot":"Furnished","Floor":null,"Condition":"","Remarks":"REQUIED FLAT ON RENT 2/3 BHK ALTHAN","Project":null,"status":"1"}]

class PropertyListResponse {
  PropertyListResponse({
      List<Property>? property,});

  PropertyListResponse.fromJson(dynamic json) {
    if (json['property'] != null) {
      property = [];
      json['property'].forEach((v) {
        property?.add(Property.fromJson(v));
      });
    }
  }
  List<Property>? property;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (property != null) {
      map['property'] = property?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class PropertyResponse {
  PropertyResponse({
      Property? property,});

  PropertyResponse.fromJson(dynamic json) {
    property = json['property'] != null ? Property.fromJson(json['property']) : Property();
  }
  Property? property;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['property'] = property?.toJson();
    return map;
  }

}

class Property {
  Property({
      Details? details,
      List<Images>? images,});

  Property.fromJson(dynamic json) {
    details = json['details']!=null ? Details.fromJson(json['details']) : Details();
    if (json['images'] != null) {
      images = [];
      json['images'].forEach((v) {
        images?.add(Images.fromJson(v));
      });
    }
  }

  Details? details;
  List<Images>? images;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['details'] = details?.toJson();
    if (images != null) {
      map['images'] = images?.map((v) => v.toJson()).toList();
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

/// ID : "2"
/// Type : "Seller"
/// TxnDate : "2021-05-21"
/// Broker : "1"
/// CustomerID : "30"
/// CategoryID : "4"
/// Purpose : "Sale"
/// BrokerType : "Owner"
/// BrokerID : "29"
/// sqft : "1225"
/// Rate : "35.51"
/// bhk : "2"
/// Var : ""
/// Vigha : ""
/// Area : "7"
/// SubArea : "8"
/// City : "2347"
/// Size : ""
/// Number : ""
/// BlockNumber : ""
/// TPSurveyNo : ""
/// Village : ""
/// FurnishedOrNot : "Furnished"
/// Floor : null
/// Condition : ""
/// Remarks : "100 % EHITE PAYMENT FULLY VASTU"
/// Project : "5"
/// status : "1"

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
    String? saleType,
    String? brochure,
    String? rera,
    String? status,
    String? projectName,
    String? areaName,
    String? categoryName,
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
    saleType = saleType;
    brochure = brochure;
    rera = rera;
    status = status;
    projectName = projectName;
    areaName = areaName;
    categoryName = categoryName;
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
    saleType = json['sale_type'];
    brochure = json['brochure'];
    rera = json['rera'];
    status = json['status'];
    projectName = json['project_name'];
    areaName = json['area_name'];
    categoryName = json['category_name'];
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
  String? saleType;
  String? brochure;
  String? rera;
  String? status;
  String? projectName;
  String? areaName;
  String? categoryName;

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
    map['sale_type'] = saleType;
    map['brochure'] = brochure;
    map['rera'] = rera;
    map['status'] = status;
    map['project_name'] = projectName;
    map['area_name'] = areaName;
    map['category_name'] = categoryName;
    return map;
  }

}