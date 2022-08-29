import 'package:real_estate_brokers/models/AreaResponse.dart';

/// area : [{"ID":"3","Name":"VESU","CityID":"2347"},{"ID":"4","Name":"CITYLIGHT ","CityID":"2347"},{"ID":"5","Name":"ALTHAN ","CityID":"2347"},{"ID":"6","Name":"GHODDHOD ROAD","CityID":"2347"},{"ID":"7","Name":"PAL PALANPORE","CityID":"2347"},{"ID":"8","Name":"ADAJAN","CityID":"2347"},{"ID":"9","Name":"KADODARA","CityID":"2347"},{"ID":"10","Name":"ATHWALINES","CityID":"2347"},{"ID":"11","Name":"BHATAR","CityID":"2347"},{"ID":"12","Name":"PIPLOD","CityID":"2347"},{"ID":"13","Name":"DUMAS","CityID":"2347"},{"ID":"14","Name":"KATARGAM","CityID":"2347"},{"ID":"15","Name":"KIM","CityID":"2347"},{"ID":"16","Name":"PALASANA ","CityID":"2347"},{"ID":"17","Name":"DINDOLI","CityID":"2347"},{"ID":"18","Name":"VED ROAD ","CityID":"2347"},{"ID":"19","Name":"BESIDE AKHAND ANAND COLLEGE ","CityID":"2347"},{"ID":"20","Name":"HALDARU","CityID":"2347"},{"ID":"21","Name":"PAL","CityID":"2347"},{"ID":"22","Name":"DUMAS ROAD","CityID":"2347"},{"ID":"24","Name":"PANDESARA","CityID":"2347"},{"ID":"25","Name":"VIRAMGAM","CityID":"2436"},{"ID":"26","Name":"SHEKAPUR","CityID":"1221"}]
/// broker_area : [{"ID":"3","Name":"VESU","CityID":"2347"},{"ID":"11","Name":"BHATAR","CityID":"2347"},{"ID":"5","Name":"ALTHAN ","CityID":"2347"},{"ID":"4","Name":"CITYLIGHT ","CityID":"2347"}]

class BrokerAreaResponse {
  BrokerAreaResponse({
      List<Area>? area, 
      List<Area>? brokerArea,}){
    area = area;
    brokerArea = brokerArea;
}

  BrokerAreaResponse.fromJson(dynamic json) {
    if (json['area'] != null) {
      area = [];
      json['area'].forEach((v) {
        area?.add(Area.fromJson(v));
      });
    }
    if (json['broker_area'] != null) {
      brokerArea = [];
      json['broker_area'].forEach((v) {
        brokerArea?.add(Area.fromJson(v));
      });
    }
  }
  List<Area>? area;
  List<Area>? brokerArea;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (area != null) {
      map['area'] = area?.map((v) => v.toJson()).toList();
    }
    if (brokerArea != null) {
      map['broker_area'] = brokerArea?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}