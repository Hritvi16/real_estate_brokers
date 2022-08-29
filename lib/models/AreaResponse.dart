/// area : [{"ID":"3","Name":"VESU","CityID":"2347"},{"ID":"4","Name":"CITYLIGHT ","CityID":"2347"},{"ID":"5","Name":"ALTHAN ","CityID":"2347"},{"ID":"6","Name":"GHODDHOD ROAD","CityID":"2347"},{"ID":"7","Name":"PAL PALANPORE","CityID":"2347"},{"ID":"8","Name":"ADAJAN","CityID":"2347"},{"ID":"9","Name":"KADODARA","CityID":"2347"},{"ID":"10","Name":"ATHWALINES","CityID":"2347"},{"ID":"11","Name":"BHATAR","CityID":"2347"},{"ID":"12","Name":"PIPLOD","CityID":"2347"},{"ID":"13","Name":"DUMAS","CityID":"2347"},{"ID":"14","Name":"KATARGAM","CityID":"2347"},{"ID":"15","Name":"KIM","CityID":"2347"},{"ID":"16","Name":"PALASANA ","CityID":"2347"},{"ID":"17","Name":"DINDOLI","CityID":"2347"},{"ID":"18","Name":"VED ROAD ","CityID":"2347"},{"ID":"19","Name":"BESIDE AKHAND ANAND COLLEGE ","CityID":"2347"},{"ID":"20","Name":"HALDARU","CityID":"2347"},{"ID":"21","Name":"PAL","CityID":"2347"},{"ID":"22","Name":"DUMAS ROAD","CityID":"2347"},{"ID":"24","Name":"PANDESARA","CityID":"2347"}]

class AreaResponse {
  AreaResponse({
      List<Area>? area,}){
    area = area;
}

  AreaResponse.fromJson(dynamic json) {
    if (json['area'] != null) {
      area = [];
      json['area'].forEach((v) {
        area?.add(Area.fromJson(v));
      });
    }
  }
  List<Area>? area;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (area != null) {
      map['area'] = area?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// ID : "3"
/// Name : "VESU"
/// CityID : "2347"

class Area {
  Area({
      String? id, 
      String? name, 
      String? cityID,}){
    id = id;
    name = name;
    cityID = cityID;
}

  Area.fromJson(dynamic json) {
    id = json['ID'];
    name = json['Name'];
    cityID = json['CityID'];
  }
  String? id;
  String? name;
  String? cityID;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ID'] = id;
    map['Name'] = name;
    map['CityID'] = cityID;
    return map;
  }

}