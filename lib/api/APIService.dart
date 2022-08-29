import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:real_estate_brokers/api/Environment.dart';
import 'package:real_estate_brokers/models/AreaResponse.dart';
import 'package:real_estate_brokers/models/BrokerAreaResponse.dart';
import 'package:real_estate_brokers/models/BrokerCityResponse.dart';
import 'package:real_estate_brokers/models/BrokerSubAreaResponse.dart';
import 'package:real_estate_brokers/models/CategoryResponse.dart';
import 'package:real_estate_brokers/models/CityResponse.dart';
import 'package:real_estate_brokers/models/LoginResponse.dart';
import 'package:real_estate_brokers/models/PropertyResponse.dart';
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

  Future<PropertyListResponse> getProperties(Map<String, dynamic> queryParameters) async{
    var url = Uri.http(Environment.url2, Environment.api2 + APIConstant.manageProperties, queryParameters);
    var result = await http.get(url);
    PropertyListResponse propertyListResponse = PropertyListResponse.fromJson(json.decode(result.body));
    return propertyListResponse;
  }


  Future<PropertyResponse> getPropertyDetails(Map<String, dynamic> queryParameters) async{
    var url = Uri.http(Environment.url2, Environment.api2 + APIConstant.manageProperties, queryParameters);
    var result = await http.get(url);
    PropertyResponse propertyResponse = PropertyResponse.fromJson(json.decode(result.body));
    return propertyResponse;
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
}
