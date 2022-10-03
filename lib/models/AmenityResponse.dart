/// amenity : [{"id":"4","amenity":"FLAT","icon":"NON COMMERCIAL","ssqft":"1","csqft":"0","Rate":"1","bhk":"1","Var":"0","Vigha":"0","Area":"1","SubArea":"1","City":"1","Size":"0","Number":"1","BlockNumber":"0","TPSurveyNo":"0","Village":"0","FurnishedOrNot":"0","Floor":"1","Condition":"1","Remarks":"1","Project":"1"},{"id":"5","amenity":"SHOP","icon":"COMMERCIAL","ssqft":"1","csqft":"0","Rate":"1","bhk":"0","Var":"0","Vigha":"0","Area":"1","SubArea":"1","City":"1","Size":"1","Number":"1","BlockNumber":"0","TPSurveyNo":"0","Village":"0","FurnishedOrNot":"0","Floor":"1","Condition":"1","Remarks":"1","Project":"1"},{"id":"6","amenity":"RESI PLOT","icon":"NON COMMERCIAL","ssqft":"0","csqft":"0","Rate":"1","bhk":"0","Var":"1","Vigha":"0","Area":"1","SubArea":"1","City":"1","Size":"1","Number":"1","BlockNumber":"0","TPSurveyNo":"0","Village":"0","FurnishedOrNot":"0","Floor":"0","Condition":"0","Remarks":"1","Project":"1"},{"id":"7","amenity":"OFFICE","icon":"COMMERCIAL","ssqft":"1","csqft":"0","Rate":"1","bhk":"0","Var":"0","Vigha":"0","Area":"1","SubArea":"1","City":"1","Size":"1","Number":"1","BlockNumber":"0","TPSurveyNo":"0","Village":"0","FurnishedOrNot":"1","Floor":"1","Condition":"1","Remarks":"1","Project":"1"},{"id":"8","amenity":"INDUSTRIAL PLOT ","icon":"COMMERCIAL","ssqft":"0","csqft":"0","Rate":"0","bhk":"0","Var":"1","Vigha":"0","Area":"1","SubArea":"1","City":"1","Size":"1","Number":"1","BlockNumber":"1","TPSurveyNo":"0","Village":"0","FurnishedOrNot":"0","Floor":"0","Condition":"1","Remarks":"1","Project":"1"},{"id":"9","amenity":"BUNGLOW ","icon":"NON COMMERCIAL","ssqft":"1","csqft":"0","Rate":"1","bhk":"1","Var":"1","Vigha":"0","Area":"1","SubArea":"1","City":"1","Size":"1","Number":"1","BlockNumber":"1","TPSurveyNo":"0","Village":"0","FurnishedOrNot":"1","Floor":"0","Condition":"1","Remarks":"1","Project":"1"},{"id":"10","amenity":"FARM HOUSE ","icon":"NON COMMERCIAL","ssqft":"1","csqft":"0","Rate":"1","bhk":"1","Var":"1","Vigha":"0","Area":"1","SubArea":"1","City":"1","Size":"1","Number":"1","BlockNumber":"1","TPSurveyNo":"0","Village":"0","FurnishedOrNot":"1","Floor":"0","Condition":"1","Remarks":"1","Project":"1"},{"id":"13","amenity":"New amenity","icon":"NON COMMERCIAL","ssqft":"1","csqft":"1","Rate":"1","bhk":"1","Var":"1","Vigha":"1","Area":"1","SubArea":"1","City":"1","Size":"1","Number":"1","BlockNumber":"1","TPSurveyNo":"1","Village":"1","FurnishedOrNot":"1","Floor":"1","Condition":"1","Remarks":"1","Project":"1"}]

class AmenityResponse {
  AmenityResponse({
      List<Amenity>? amenity,}){
    amenity = amenity;
}

  AmenityResponse.fromJson(dynamic json) {
    if (json['amenity'] != null) {
      amenity = [];
      json['amenity'].forEach((v) {
        amenity?.add(Amenity.fromJson(v));
      });
    }
  }
  List<Amenity>? amenity;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (amenity != null) {
      map['amenity'] = amenity?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Amenity {
  Amenity({
      String? id, 
      String? amenity, 
      String? icon, }){
    id = id;
    amenity = amenity;
    icon = icon;
}

  Amenity.fromJson(dynamic json) {
    id = json['id'];
    amenity = json['amenity'];
    icon = json['icon'];
  }
  String? id;
  String? amenity;
  String? icon;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['amenity'] = amenity;
    map['icon'] = icon;
    return map;
  }

}