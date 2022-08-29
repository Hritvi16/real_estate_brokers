
import 'package:real_estate_brokers/models/CityResponse.dart';

class BrokerCityResponse {
  BrokerCityResponse({
      List<City>? city, 
      City? brokerCity,}){
    city = city;
    brokerCity = brokerCity;
}

  BrokerCityResponse.fromJson(dynamic json) {
    if (json['city'] != null) {
      city = [];
      json['city'].forEach((v) {
        city?.add(City.fromJson(v));
      });
    }
    brokerCity = json['broker_city'] != null ? City.fromJson(json['broker_city']) : null;
  }
  List<City>? city;
  City? brokerCity;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (city != null) {
      map['city'] = city?.map((v) => v.toJson()).toList();
    }
    if (brokerCity != null) {
      map['broker_city'] = brokerCity?.toJson();
    }
    return map;
  }

}
