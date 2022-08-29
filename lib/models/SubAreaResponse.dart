/// subArea : [{"ID":"4","Name":"GD GOYENKA CANAL ROAD","AreaID":"3"},{"ID":"5","Name":"PAL PALANPOR CANAL ROAD","AreaID":"7"},{"ID":"6","Name":"BHIMRAD VESU ","AreaID":"3"},{"ID":"7","Name":"DINDOLI MAIN ROAD","AreaID":"17"},{"ID":"8","Name":"NEAR RAJ WORLD","AreaID":"7"},{"ID":"9","Name":"ALTHAN CANAL ROAD","AreaID":"5"},{"ID":"10","Name":"VIP ROAD ","AreaID":"3"},{"ID":"11","Name":"AKHAND ANAND COLLAGE OPPOSIT","AreaID":"18"},{"ID":"12","Name":"CITY LIGHT MAIN ROAD","AreaID":"4"},{"ID":"13","Name":"TGB CIRCLE ","AreaID":"8"},{"ID":"14","Name":"GAURAV PATH ROAD","AreaID":"8"},{"ID":"15","Name":"SURAT BARDOLI ROAD","AreaID":"20"},{"ID":"16","Name":"NR PRATHAM CIRCLE","AreaID":"21"},{"ID":"17","Name":"PALANPUR CANAL ROAD","AreaID":"8"},{"ID":"18","Name":"PAL TADAV WALK WAY","AreaID":"21"},{"ID":"19","Name":"OPPOSITE AIRPORT","AreaID":"13"},{"ID":"20","Name":"NEAR OFFIRA ","AreaID":"3"},{"ID":"21","Name":"NEAR VESU CHOKDI","AreaID":"3"},{"ID":"22","Name":"VESU CHOKDI","AreaID":"3"},{"ID":"23","Name":"NEAR SHYAM BABA MANDIR","AreaID":"3"},{"ID":"24","Name":"SECOND VIP ROAD","AreaID":"3"},{"ID":"25","Name":"DUMAS ROAD","AreaID":"3"},{"ID":"26","Name":"UMA BHAVAN","AreaID":"11"}]

class SubAreaResponse {
  SubAreaResponse({
      List<SubArea>? subArea,}){
    subArea = subArea;
}

  SubAreaResponse.fromJson(dynamic json) {
    if (json['subArea'] != null) {
      subArea = [];
      json['subArea'].forEach((v) {
        subArea?.add(SubArea.fromJson(v));
      });
    }
  }
  List<SubArea>? subArea;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (subArea != null) {
      map['subArea'] = subArea?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// ID : "4"
/// Name : "GD GOYENKA CANAL ROAD"
/// AreaID : "3"

class SubArea {
  SubArea({
      String? id, 
      String? name, 
      String? areaID,}){
    id = id;
    name = name;
    areaID = areaID;
}

  SubArea.fromJson(dynamic json) {
    id = json['ID'];
    name = json['Name'];
    areaID = json['AreaID'];
  }
  String? id;
  String? name;
  String? areaID;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ID'] = id;
    map['Name'] = name;
    map['AreaID'] = areaID;
    return map;
  }

}