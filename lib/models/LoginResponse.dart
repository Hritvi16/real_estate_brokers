/// status : "Success"
/// message : "Logged In"
/// broker : {"id":"1","username":"Admin","password":"143143","status":"1","company_name":null,"logo":"","color":"","gstin":null,"address":null,"mobile":"9999999999","email":null,"office_number_1":"\u0001","office_number_2":null,"city":null,"state":null,"area":null,"pincode":null,"rate":null,"created_at":null}

class LoginResponse {
  LoginResponse({
      String? status, 
      String? message, 
      Broker? broker,});

  LoginResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    broker = json['broker'] != null ? Broker.fromJson(json['broker']) : null;
  }
  String? status;
  String? message;
  Broker? broker;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (broker != null) {
      map['broker'] = broker?.toJson();
    }
    return map;
  }

}


class Broker {
  Broker({
      String? id, 
      String? name,
      String? username,
      String? password,
      String? status, 
      String? companyName, 
      String? logo, 
      String? color, 
      String? gstin, 
      String? address, 
      String? mobile, 
      String? email, 
      String? website1,
      String? website2,
      String? officeNumber1,
      String? officeNumber2, 
      String? cityID,
      String? state, 
      String? areaID,
      String? pincode, 
      String? rate, 
      String? createdAt,});

  Broker.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    password = json['password'];
    status = json['status'];
    companyName = json['company_name'];
    logo = json['logo'];
    color = json['color'];
    gstin = json['gstin'];
    address = json['address'];
    mobile = json['mobile'];
    email = json['email'];
    website1 = json['website1'];
    website2 = json['website2'];
    officeNumber1 = json['office_number_1'];
    officeNumber2 = json['office_number_2'];
    cityID = json['CityID'];
    state = json['state'];
    areaID = json['AreaID'];
    pincode = json['pincode'];
    rate = json['rate'];
    createdAt = json['created_at'];
  }
  String? id;
  String? name;
  String? username;
  String? password;
  String? status;
  String? companyName;
  String? logo;
  String? color;
  String? gstin;
  String? address;
  String? mobile;
  String? email;
  String? website1;
  String? website2;
  String? officeNumber1;
  String? officeNumber2;
  String? cityID;
  String? state;
  String? areaID;
  String? pincode;
  String? rate;
  String? createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['username'] = username;
    map['password'] = password;
    map['status'] = status;
    map['company_name'] = companyName;
    map['logo'] = logo;
    map['color'] = color;
    map['gstin'] = gstin;
    map['address'] = address;
    map['mobile'] = mobile;
    map['email'] = email;
    map['website1'] = website1;
    map['website2'] = website2;
    map['office_number_1'] = officeNumber1;
    map['office_number_2'] = officeNumber2;
    map['CityID'] = cityID;
    map['state'] = state;
    map['AreaID'] = areaID;
    map['pincode'] = pincode;
    map['rate'] = rate;
    map['created_at'] = createdAt;
    return map;
  }

}