
import 'package:real_estate_brokers/models/SubAreaResponse.dart';

class BrokerSubAreaResponse {
  BrokerSubAreaResponse({
      List<SubArea>? subArea, 
      List<SubArea>? brokerSubArea,}){
    subArea = subArea;
    brokerSubArea = brokerSubArea;
}

  BrokerSubAreaResponse.fromJson(dynamic json) {
    if (json['subArea'] != null) {
      subArea = [];
      json['subArea'].forEach((v) {
        subArea?.add(SubArea.fromJson(v));
      });
    }
    if (json['broker_subArea'] != null) {
      brokerSubArea = [];
      json['broker_subArea'].forEach((v) {
        brokerSubArea?.add(SubArea.fromJson(v));
      });
    }
  }
  List<SubArea>? subArea;
  List<SubArea>? brokerSubArea;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (subArea != null) {
      map['subArea'] = subArea?.map((v) => v.toJson()).toList();
    }
    if (brokerSubArea != null) {
      map['broker_subArea'] = brokerSubArea?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}
