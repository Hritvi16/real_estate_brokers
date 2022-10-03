import 'package:real_estate_brokers/models/LoginResponse.dart';

class BrokerResponse {
  brokerResponse({
    List<Broker>? broker,}){
    broker = broker;
  }

  BrokerResponse.fromJson(dynamic json) {
    if (json['broker'] != null) {
      broker = [];
      json['broker'].forEach((v) {
        broker?.add(Broker.fromJson(v));
      });
    }
  }
  List<Broker>? broker;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (broker != null) {
      map['broker'] = broker?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}