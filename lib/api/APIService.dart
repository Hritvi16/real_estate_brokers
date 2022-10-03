import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:real_estate_brokers/api/Environment.dart';
import 'package:real_estate_brokers/models/AreaResponse.dart';
import 'package:real_estate_brokers/models/BrokerAreaResponse.dart';
import 'package:real_estate_brokers/models/BrokerCityResponse.dart';
import 'package:real_estate_brokers/models/BrokerResponse.dart';
import 'package:real_estate_brokers/models/BrokerSubAreaResponse.dart';
import 'package:real_estate_brokers/models/CategoryResponse.dart';
import 'package:real_estate_brokers/models/CityResponse.dart';
import 'package:real_estate_brokers/models/DealResponse.dart';
import 'package:real_estate_brokers/models/FilterResponse.dart';
import 'package:real_estate_brokers/models/FollowUpResponse.dart';
import 'package:real_estate_brokers/models/LeadResponse.dart';
import 'package:real_estate_brokers/models/LeadSourceResponse.dart';
import 'package:real_estate_brokers/models/LoginResponse.dart';
import 'package:real_estate_brokers/models/PropertyResponse.dart';
import 'package:real_estate_brokers/models/Response.dart';
import 'package:real_estate_brokers/models/StatusResponse.dart';
import 'package:real_estate_brokers/models/SubAreaResponse.dart';
import 'APIConstant.dart';

class APIService {
  // getHeader() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   Map<String, String> headers = {
  //     APIConstant.authorization : APIConstant.token+(sharedPreferences.getString("token")??"")+"."+base64Encode(utf8.encode(DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()))),
  //     "Accept": "application/json",
  //   };
  //   return headers;
  // }

  // getToken() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   String token = sharedPreferences.getString("token")??"";
  //   return token;
  // }


  // Future<Response> insertUserFCM(Map<String, dynamic> data) async {
  //   var url = Uri.parse(Environment.url1 + Environment.api1 +APIConstant.insertUserFCM);
  //   var result = await http.post(url, body: data);
  //
  //   Response response = Response.fromJson(json.decode(result.body));
  //   return response;
  // }


  Future<LoginResponse> login(Map<String, dynamic> data) async{
    var url = Uri.parse(Environment.url1 + Environment.api1 +APIConstant.manageBrokers);
    var result = await http.post(url, body: data);
    LoginResponse loginResponse = LoginResponse.fromJson(json.decode(result.body));
    return loginResponse;
  }

  Future<LoginResponse> getAccountDetails(Map<String, dynamic> queryParameters) async{
    var url = Uri.http(Environment.url2, Environment.api2 + APIConstant.manageBrokers, queryParameters);
    var result = await http.get(url);
    LoginResponse loginResponse = LoginResponse.fromJson(json.decode(result.body));
    return loginResponse;
  }

  Future<Response> updateProfile(Map<String, dynamic> data) async{
    var url = Uri.parse(Environment.url1 + Environment.api1 +APIConstant.manageBrokers);
    var result = await http.post(url, body: data);
    print(result.body);
    Response response = Response.fromJson(json.decode(result.body));
    return response;
  }

  Future<BrokerResponse> getBrokers(Map<String, dynamic> queryParameters) async{
    var url = Uri.http(Environment.url2, Environment.api2 + APIConstant.manageBrokers, queryParameters);
    var result = await http.get(url);
    print(result.body);
    BrokerResponse brokerResponse = BrokerResponse.fromJson(json.decode(result.body));
    return brokerResponse;
  }

  Future<PropertyListResponse> getProperties(Map<String, dynamic> queryParameters) async{
    var url = Uri.http(Environment.url2, Environment.api2 + APIConstant.manageProperties, queryParameters);
    var result = await http.get(url);
    print(result.body);
    PropertyListResponse propertyListResponse = PropertyListResponse.fromJson(json.decode(result.body));
    return propertyListResponse;
  }

  Future<PropertyResponse> getPropertyDetails(Map<String, dynamic> queryParameters) async{
    var url = Uri.http(Environment.url2, Environment.api2 + APIConstant.manageProperties, queryParameters);
    var result = await http.get(url);
    PropertyResponse propertyResponse = PropertyResponse.fromJson(json.decode(result.body));
    return propertyResponse;
  }

  Future<FilterResponse> getFilters(Map<String, dynamic> queryParameters) async{
    var url = Uri.http(Environment.url2, Environment.api2 + APIConstant.manageFilters, queryParameters);
    var result = await http.get(url);
    print(result.body);
    FilterResponse filterResponse = FilterResponse.fromJson(json.decode(result.body));
    return filterResponse;
  }

  Future<Response> deleteFilter(Map<String, dynamic> queryParameters) async{
    var url = Uri.http(Environment.url2, Environment.api2 + APIConstant.manageFilters, queryParameters);
    var result = await http.get(url);
    print(result.body);
    Response response = Response.fromJson(json.decode(result.body));
    return response;
  }

  Future<Response> saveSearch(Map<String, dynamic> data) async{
    var url = Uri.parse(Environment.url1 + Environment.api1 +APIConstant.manageFilters);
    var result = await http.post(url, body: data);
    print(result.body);
    Response response = Response.fromJson(json.decode(result.body));
    return response;
  }

  Future<CategoryResponse> getCategories(Map<String, dynamic> queryParameters) async{
    var url = Uri.http(Environment.url2, Environment.api2 + APIConstant.manageCategories, queryParameters);
    var result = await http.get(url);
    CategoryResponse categoryResponse = CategoryResponse.fromJson(json.decode(result.body));
    return categoryResponse;
  }

  Future<CityResponse> getCities(Map<String, dynamic> queryParameters) async{
    var url = Uri.http(Environment.url2, Environment.api2 + APIConstant.manageCities, queryParameters);
    var result = await http.get(url);
    CityResponse cityResponse = CityResponse.fromJson(json.decode(result.body));
    return cityResponse;
  }

  Future<BrokerCityResponse> getBrokerCities(Map<String, dynamic> queryParameters) async{
    var url = Uri.http(Environment.url2, Environment.api2 + APIConstant.manageCities, queryParameters);
    var result = await http.get(url);
    BrokerCityResponse brokerCityResponse = BrokerCityResponse.fromJson(json.decode(result.body));
    return brokerCityResponse;
  }

  Future<AreaResponse> getAreas(Map<String, dynamic> queryParameters) async{
    var url = Uri.http(Environment.url2, Environment.api2 + APIConstant.manageAreas, queryParameters);
    var result = await http.get(url);
    AreaResponse areaResponse = AreaResponse.fromJson(json.decode(result.body));
    return areaResponse;
  }

  Future<BrokerAreaResponse> getBrokerAreas(Map<String, dynamic> queryParameters) async{
    var url = Uri.http(Environment.url2, Environment.api2 + APIConstant.manageAreas, queryParameters);
    var result = await http.get(url);
    BrokerAreaResponse brokerAreaResponse = BrokerAreaResponse.fromJson(json.decode(result.body));
    return brokerAreaResponse;
  }

  Future<BrokerSubAreaResponse> getSubAreas(Map<String, dynamic> queryParameters) async{
    var url = Uri.http(Environment.url2, Environment.api2 + APIConstant.manageSubAreas, queryParameters);
    var result = await http.get(url);
    BrokerSubAreaResponse brokerSubAreaResponse = BrokerSubAreaResponse.fromJson(json.decode(result.body));
    return brokerSubAreaResponse;
  }

  Future<Response> updateWishlist(Map<String, dynamic> data) async{
    var url = Uri.parse(Environment.url1 + Environment.api1 +APIConstant.manageProperties);
    var result = await http.post(url, body: data);
    print(result.body);
    Response response = Response.fromJson(json.decode(result.body));
    return response;
  }

  Future<LeadDetailResponse> getLeadsDetails(Map<String, dynamic> queryParameters) async{
    var url = Uri.http(Environment.url2, Environment.api2 + APIConstant.manageLeads, queryParameters);
    var result = await http.get(url);
    print(result.body);
    LeadDetailResponse leadDetailResponse = LeadDetailResponse.fromJson(json.decode(result.body));
    return leadDetailResponse;
  }

  Future<LeadDetailResponse> getDashboard(Map<String, dynamic> queryParameters) async{
    var url = Uri.http(Environment.url2, Environment.api2 + APIConstant.manageDashboard, queryParameters);
    var result = await http.get(url);
    print(result.body);
    LeadDetailResponse leadDetailResponse = LeadDetailResponse.fromJson(json.decode(result.body));
    return leadDetailResponse;
  }

  Future<LeadResponse> getLeads(Map<String, dynamic> queryParameters) async{
    var url = Uri.http(Environment.url2, Environment.api2 + APIConstant.manageLeads, queryParameters);
    var result = await http.get(url);
    print(result.body);
    LeadResponse leadResponse = LeadResponse.fromJson(json.decode(result.body));
    return leadResponse;
  }

  Future<Response> deleteLead(Map<String, dynamic> data) async{
    var url = Uri.http(Environment.url2, Environment.api2 + APIConstant.manageLeads, data);
    var result = await http.get(url);
    print(result.body);
    Response response = Response.fromJson(json.decode(result.body));
    return response;
  }

  Future<Response> assignLead(Map<String, dynamic> data) async{
    var url = Uri.http(Environment.url2, Environment.api2 + APIConstant.manageLeads, data);
    var result = await http.get(url);
    print(result.body);
    Response response = Response.fromJson(json.decode(result.body));
    return response;
  }

  Future<StatusResponse> getStatus(Map<String, dynamic> queryParameters) async{
    var url = Uri.http(Environment.url2, Environment.api2 + APIConstant.manageStatus, queryParameters);
    var result = await http.get(url);
    print(result.body);
    StatusResponse statusResponse = StatusResponse.fromJson(json.decode(result.body));
    return statusResponse;
  }

  Future<Response> addStatus(Map<String, dynamic> data) async{
    var url = Uri.parse(Environment.url1 + Environment.api1 +APIConstant.manageStatus);
    var result = await http.post(url, body: data);
    print(result.body);
    Response response = Response.fromJson(json.decode(result.body));
    return response;
  }

  Future<Response> deleteStatus(Map<String, dynamic> queryParameters) async{
    var url = Uri.http(Environment.url2, Environment.api2 + APIConstant.manageStatus, queryParameters);
    var result = await http.get(url);
    print(result.body);
    Response response = Response.fromJson(json.decode(result.body));
    return response;
  }

  Future<Response> updateLeadStatus(Map<String, dynamic> data) async{
    var url = Uri.parse(Environment.url1 + Environment.api1 +APIConstant.manageLeads);
    var result = await http.post(url, body: data);
    print(result.body);
    Response response = Response.fromJson(json.decode(result.body));
    return response;
  }

  Future<LeadSourceResponse> getLeadSources(Map<String, dynamic> queryParameters) async{
    var url = Uri.http(Environment.url2, Environment.api2 + APIConstant.manageLeadSources, queryParameters);
    var result = await http.get(url);
    print(result.body);
    LeadSourceResponse leadSourceResponse = LeadSourceResponse.fromJson(json.decode(result.body));
    return leadSourceResponse;
  }

  Future<Response> addLead(Map<String, dynamic> data) async{
    var url = Uri.parse(Environment.url1 + Environment.api1 +APIConstant.manageLeads);
    var result = await http.post(url, body: data);
    print(result.body);
    Response response = Response.fromJson(json.decode(result.body));
    return response;
  }

  Future<FollowUpResponse> getFollowUps(Map<String, dynamic> queryParameters) async{
    var url = Uri.http(Environment.url2, Environment.api2 + APIConstant.manageFollowUp, queryParameters);
    var result = await http.get(url);
    print(result.body);
    FollowUpResponse followUpResponse = FollowUpResponse.fromJson(json.decode(result.body));
    return followUpResponse;
  }

  Future<FollowUpDetailResponse> followUpDetail(Map<String, dynamic> queryParameters) async{
    var url = Uri.http(Environment.url2, Environment.api2 + APIConstant.manageFollowUp, queryParameters);
    var result = await http.get(url);
    print(result.body);
    FollowUpDetailResponse followUpDetailResponse = FollowUpDetailResponse.fromJson(json.decode(result.body));
    return followUpDetailResponse;
  }

  Future<Response> addFollowUp(Map<String, dynamic> data) async{
    var url = Uri.parse(Environment.url1 + Environment.api1 +APIConstant.manageFollowUp);
    var result = await http.post(url, body: data);
    print(result.body);
    Response response = Response.fromJson(json.decode(result.body));
    return response;
  }

  Future<Response> deleteFollowUp(Map<String, dynamic> queryParameters) async{
    var url = Uri.http(Environment.url2, Environment.api2 + APIConstant.manageFollowUp, queryParameters);
    var result = await http.get(url);
    print(result.body);
    Response response = Response.fromJson(json.decode(result.body));
    return response;
  }

  Future<DealResponse> getDeals(Map<String, dynamic> queryParameters) async{
    var url = Uri.http(Environment.url2, Environment.api2 + APIConstant.manageDeal, queryParameters);
    var result = await http.get(url);
    print(result.body);
    DealResponse dealResponse = DealResponse.fromJson(json.decode(result.body));
    return dealResponse;
  }

  Future<Response> addDeal(Map<String, dynamic> data) async{
    var url = Uri.parse(Environment.url1 + Environment.api1 +APIConstant.manageDeal);
    var result = await http.post(url, body: data);
    print(result.body);
    Response response = Response.fromJson(json.decode(result.body));
    return response;
  }

  Future<Response> deleteDeal(Map<String, dynamic> queryParameters) async{
    var url = Uri.http(Environment.url2, Environment.api2 + APIConstant.manageDeal, queryParameters);
    var result = await http.get(url);
    print(result.body);
    Response response = Response.fromJson(json.decode(result.body));
    return response;
  }
}
