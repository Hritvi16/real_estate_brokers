/// category : [{"id":"4","name":"FLAT","type":"NON COMMERCIAL","ssqft":"1","csqft":"0","Rate":"1","bhk":"1","Var":"0","Vigha":"0","Area":"1","SubArea":"1","City":"1","Size":"0","Number":"1","BlockNumber":"0","TPSurveyNo":"0","Village":"0","FurnishedOrNot":"0","Floor":"1","Condition":"1","Remarks":"1","Project":"1"},{"id":"5","name":"SHOP","type":"COMMERCIAL","ssqft":"1","csqft":"0","Rate":"1","bhk":"0","Var":"0","Vigha":"0","Area":"1","SubArea":"1","City":"1","Size":"1","Number":"1","BlockNumber":"0","TPSurveyNo":"0","Village":"0","FurnishedOrNot":"0","Floor":"1","Condition":"1","Remarks":"1","Project":"1"},{"id":"6","name":"RESI PLOT","type":"NON COMMERCIAL","ssqft":"0","csqft":"0","Rate":"1","bhk":"0","Var":"1","Vigha":"0","Area":"1","SubArea":"1","City":"1","Size":"1","Number":"1","BlockNumber":"0","TPSurveyNo":"0","Village":"0","FurnishedOrNot":"0","Floor":"0","Condition":"0","Remarks":"1","Project":"1"},{"id":"7","name":"OFFICE","type":"COMMERCIAL","ssqft":"1","csqft":"0","Rate":"1","bhk":"0","Var":"0","Vigha":"0","Area":"1","SubArea":"1","City":"1","Size":"1","Number":"1","BlockNumber":"0","TPSurveyNo":"0","Village":"0","FurnishedOrNot":"1","Floor":"1","Condition":"1","Remarks":"1","Project":"1"},{"id":"8","name":"INDUSTRIAL PLOT ","type":"COMMERCIAL","ssqft":"0","csqft":"0","Rate":"0","bhk":"0","Var":"1","Vigha":"0","Area":"1","SubArea":"1","City":"1","Size":"1","Number":"1","BlockNumber":"1","TPSurveyNo":"0","Village":"0","FurnishedOrNot":"0","Floor":"0","Condition":"1","Remarks":"1","Project":"1"},{"id":"9","name":"BUNGLOW ","type":"NON COMMERCIAL","ssqft":"1","csqft":"0","Rate":"1","bhk":"1","Var":"1","Vigha":"0","Area":"1","SubArea":"1","City":"1","Size":"1","Number":"1","BlockNumber":"1","TPSurveyNo":"0","Village":"0","FurnishedOrNot":"1","Floor":"0","Condition":"1","Remarks":"1","Project":"1"},{"id":"10","name":"FARM HOUSE ","type":"NON COMMERCIAL","ssqft":"1","csqft":"0","Rate":"1","bhk":"1","Var":"1","Vigha":"0","Area":"1","SubArea":"1","City":"1","Size":"1","Number":"1","BlockNumber":"1","TPSurveyNo":"0","Village":"0","FurnishedOrNot":"1","Floor":"0","Condition":"1","Remarks":"1","Project":"1"},{"id":"13","name":"New Category","type":"NON COMMERCIAL","ssqft":"1","csqft":"1","Rate":"1","bhk":"1","Var":"1","Vigha":"1","Area":"1","SubArea":"1","City":"1","Size":"1","Number":"1","BlockNumber":"1","TPSurveyNo":"1","Village":"1","FurnishedOrNot":"1","Floor":"1","Condition":"1","Remarks":"1","Project":"1"}]

class CategoryResponse {
  CategoryResponse({
      List<Category>? category,}){
    category = category;
}

  CategoryResponse.fromJson(dynamic json) {
    if (json['category'] != null) {
      category = [];
      json['category'].forEach((v) {
        category?.add(Category.fromJson(v));
      });
    }
  }
  List<Category>? category;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (category != null) {
      map['category'] = category?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Category {
  Category({
      String? id, 
      String? name, 
      String? type, 
      String? ssqft, 
      String? csqft, 
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
      String? project,}){
    id = id;
    name = name;
    type = type;
    ssqft = ssqft;
    csqft = csqft;
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
}

  Category.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    ssqft = json['ssqft'];
    csqft = json['csqft'];
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
  }
  String? id;
  String? name;
  String? type;
  String? ssqft;
  String? csqft;
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


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['type'] = type;
    map['ssqft'] = ssqft;
    map['csqft'] = csqft;
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
    return map;
  }

}