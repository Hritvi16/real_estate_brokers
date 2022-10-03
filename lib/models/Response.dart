/// status : "Success"
/// message : "Logged In"
/// broker : {"id":"1","username":"Admin","password":"143143","status":"1","company_name":null,"logo":"","color":"","gstin":null,"address":null,"mobile":"9999999999","email":null,"office_number_1":"\u0001","office_number_2":null,"city":null,"state":null,"area":null,"pincode":null,"rate":null,"created_at":null}

class Response {
  Response({
      String? status, 
      String? message,
      int? data,
  });

  Response.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'];
  }
  String? status;
  String? message;
  int? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['data'] = data;
    return map;
  }

}

