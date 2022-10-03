
import 'package:real_estate_brokers/models/FollowUpResponse.dart';
import 'package:real_estate_brokers/models/LeadResponse.dart';

class DashboardResponse {
  DashboardResponse({
      List<LeadDetails>? leadDetails,}){
    leadDetails = leadDetails;
}

  DashboardResponse.fromJson(dynamic json) {
    if (json['lead_details'] != null) {
      leadDetails = [];
      json['lead_details'].forEach((v) {
        leadDetails?.add(LeadDetails.fromJson(v));
      });
    }
  }
  List<LeadDetails>? leadDetails;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (leadDetails != null) {
      map['lead_details'] = leadDetails?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}