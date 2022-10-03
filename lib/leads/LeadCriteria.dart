import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:real_estate_brokers/models/BrokerAreaResponse.dart';
import 'package:real_estate_brokers/models/BrokerCityResponse.dart';
import 'package:real_estate_brokers/models/BrokerSubAreaResponse.dart';
import 'package:real_estate_brokers/models/LeadResponse.dart';
import 'package:real_estate_brokers/models/PropertyResponse.dart';
import 'package:real_estate_brokers/models/Response.dart';
import 'package:real_estate_brokers/ranger/BedroomRanger.dart';
import 'package:real_estate_brokers/ranger/BudgetRanger.dart';
import 'package:real_estate_brokers/DropdownDialog.dart';
import 'package:real_estate_brokers/ranger/TextDialog.dart';
import 'package:real_estate_brokers/ranger/SQFTRanger.dart';
import 'package:real_estate_brokers/api/APIConstant.dart';
import 'package:real_estate_brokers/api/APIService.dart';
import 'package:real_estate_brokers/colors/MyColors.dart';
import 'package:real_estate_brokers/models/AreaResponse.dart';
import 'package:real_estate_brokers/models/CategoryResponse.dart';
import 'package:real_estate_brokers/models/CityResponse.dart';
import 'package:real_estate_brokers/models/SubAreaResponse.dart';
import 'package:real_estate_brokers/ranger/VVRanger.dart';
import 'package:real_estate_brokers/size/MySize.dart';
import 'package:real_estate_brokers/strings/Strings.dart';
import 'package:real_estate_brokers/toast/Toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeadCriteria extends StatefulWidget {
  final Color colorPrimary;
  final Map<String, String> data;
  final Criteria? criteria;
  const LeadCriteria({Key? key, required this.colorPrimary, required this.data, this.criteria}) : super(key: key);

  @override
  State<LeadCriteria> createState() => _LeadCriteriaState();
}

class _LeadCriteriaState extends State<LeadCriteria> {

  late SharedPreferences sharedPreferences;

  String selectedTab = Strings.nonCommercial;
  String selectedLooking = Strings.buy;

  List<Category> categories = [];
  List<Category> ncomcat = [];
  List<Category> comcat = [];
  List<Category> selectedProperty = [];

  List<String> saleRate = ["", "10-15L", "15-20L", "20-25L", "25-30L", "30-35L", "35-40L", "40-45L", "45-50L", "50-60L", "60-70L",
    "70-80L", "80-90L", "90L-1Cr", "1-1.25Cr", "1.25-1.5Cr", "1.5+Cr"];
  List<String> rentRate = ["", "10-15k", "15-20k", "20-25k", "25-30k", "30-35k", "35-40k", "40-50k", "50-75k", "75k-1L"];
  List<String> leaseRate = ["", "10-15k", "15-20k", "20-25k", "25-30k", "30-35k", "35-40k", "40-50k", "50-75k", "75k-1L"];
  List<String> selectedRate = [];

  List<String> BHK = ["", "1", "2", "3", "4", "5", "6"];
  List<String> selectedBHK = [];

  List<String> SSF = ["", "1000-1500", "1500-2000", "2000-2500", "2500-3000", "3000-4000", "4000-5000"];
  List<String> selectedSSF = [];

  List<String> CSF = ["", "1000-1500", "1500-2000", "2000-2500", "2500-3000", "3000-4000", "4000-5000"];
  List<String> selectedCSF = [];

  List<String> Var = ["", "10-30", "30-50", "50-70", "70-100", "100-125", "125-150", "150-175", "175-200"];
  List<String> selectedVar = [];

  List<String> Vigha = ["", "10-30", "30-50", "50-70", "70-100", "100-125", "125-150", "150-175", "175-200"];
  List<String> selectedVigha = [];

  List<City> cities = [];
  List<String> citiesString = [];
  String? city;
  String? city_id;

  List<Area> areas = [];
  List<Area> brokerAreas = [];
  List<String> areasString = [];
  List<String> brokerAreasString = [""];
  List<String> area = [];

  List<SubArea> subAreas = [];
  List<SubArea> brokerSubAreas = [];
  List<String> subAreasString = [];
  List<String> brokerSubAreasString = [""];
  List<String> subArea = [];

  bool load = false;

  List<String> selectedFurnish = [];
  List<String> selectedRera = [];

  List<String> Floor = ["", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "Ground", "Upper Ground"];
  List<String> selectedFloor = [];

  List<Property> properties = [];
  late Color colorPrimary;
  Map<String, String> data = {};

  Criteria? criteria;

  @override
  void initState() {
    colorPrimary = widget.colorPrimary;
    data = widget.data;
    criteria = widget.criteria;
    start();
    super.initState();
  }

  setData() {
    selectedLooking = Strings.buy;
    selectedProperty = [];
    selectedRate = [];
    setState(() {

    });
  }
  Future<void> start() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if(criteria!=null) {
      print(criteria?.toJson());
      selectedTab = criteria?.categoryType??"";
      selectedLooking = criteria?.purpose??"";
      city_id = criteria?.city;
      area = criteria!.areas!.isNotEmpty ? criteria!.areas!.split(",") : [];
      subArea = criteria!.subAreas!.isNotEmpty ? criteria!.subAreas!.split(",") : [];
      selectedRate = criteria!.budget!.isNotEmpty ? criteria!.budget!.split(",") : [];
      selectedBHK = criteria!.bhk!.isNotEmpty ? criteria!.bhk!.split(",") : [];
      selectedSSF = criteria!.ssf!.isNotEmpty ? criteria!.ssf!.split(",") : [];
      selectedCSF = criteria!.csf!.isNotEmpty ? criteria!.csf!.split(",") : [];
      selectedFurnish = criteria!.furnish!.isNotEmpty ? criteria!.furnish!.split(",") : [];
      selectedFloor = criteria!.floor!.isNotEmpty ? criteria!.floor!.split(",") : [];
      selectedRera = criteria!.rera!.isNotEmpty ? criteria!.rera!.split(",") : [];

      for(int i=0; i<selectedRera.length;i++) {
        print(i);
        print(selectedRera);
        print(selectedRera.length);
        selectedRera[i] = selectedRera[i].replaceFirst(selectedRera[i].substring(1), selectedRera[i].substring(1).toLowerCase());
      }
    }
    setState(() {

    });
    print("area");
    print(area);
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: MyColors.white,
        elevation: 0,
          // actions: <Widget>[
          //   GestureDetector(
          //     onTap: () {
          //       Navigator.pop(context, "clear");
          //     },
          //     child: Container(
          //       alignment: Alignment.centerRight,
          //       padding: EdgeInsets.only(right: 15),
          //       child: Text(
          //         "CLEAR",
          //       ),
          //     ),
          //   ),
          // ],
      ),
      bottomNavigationBar: Container(
        height: 45,
        width: 120,
        margin: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
        child: ElevatedButton(
            onPressed: () {
              if(load) {
                addLead();
              }
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(colorPrimary)
            ),
            child: load ?
            Text("SUBMIT", style: TextStyle(color: MyColors.white),)
            : CircularProgressIndicator(
              color: MyColors.white,
            )
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getTabs(),
              const SizedBox(
                height: 20,
              ),
              getLooking(),
              const SizedBox(
                height: 20,
              ),
              getCityDropdown(),
              const SizedBox(
                height: 20,
              ),
              getTitle("Areas"),
              const SizedBox(
                height: 15,
              ),
              getAreasDesign(),
              const SizedBox(
                height: 20,
              ),
              getTitle("Sub Areas"),
              const SizedBox(
                height: 15,
              ),
              getSubAreasDesign(),
              const SizedBox(
                height: 20,
              ),
              getTitle("Budget"),
              const SizedBox(
                height: 15,
              ),
              getBudgetList(),
              const SizedBox(
                height: 20,
              ),
              getTitle("Type of Property"),
              const SizedBox(
                height: 15,
              ),
              selectedTab==Strings.nonCommercial ? getPropertyDesign(ncomcat)
                  : getPropertyDesign(comcat),
              if(selectedTab==Strings.nonCommercial && getBHKStatus())
                getBHKDesign(),
              if(getSSFStatus())
                getSSFDesign(),
              if(getSSFStatus())
                getCSFDesign(),
              if(getVarStatus())
                getVarDesign(),
              if(getVighaStatus())
                getVighaDesign(),
              const SizedBox(
                height: 20,
              ),
              getFurnished(),
              const SizedBox(
                height: 20,
              ),
              getTitle("Floor"),
              const SizedBox(
                height: 15,
              ),
              getFloorList(),
              const SizedBox(
                height: 20,
              ),
              getRera(),
              const SizedBox(
                height: 20,
              ),
              // getNCCategoryDesign()
              // ListView.separated(
              //   itemCount: selectedTab==Strings.nonCommercial ? ncomcat.length : comcat.length,
              //   itemBuilder: (BuildContext buildContext, int index) {
              //     return selectedTab==Strings.nonCommercial ? getNCCategoryDesign(ncomcat[index])
              //     : getCCategoryDesign(comcat[index]);
              //   },
              //   separatorBuilder: (BuildContext buildContext, int index) {
              //     return const SizedBox(
              //       height: 20,
              //     );
              //   },
              // )
            ],
          ),
        ),
      ),
    );
  }

  getTabs() {
    return Container(
      width: MySize.size100(context),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: MyColors.grey1))
      ),
      child: Row(
        children: [
          getTab(Strings.nonCommercial),
          const SizedBox(
            width: 20,
          ),
          getTab(Strings.commercial),
        ],
      ),
    );
  }

  getTab(String title) {
    bool select = title==selectedTab;
    return GestureDetector(
      onTap: () {
        if(!select) {
          selectedTab = title;
          setData();

          set(true);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: select ? Border(bottom: BorderSide(color: colorPrimary, width: 1.5)) : null
        ),
        child: Text(
          title==Strings.nonCommercial ? "RESIDENTIAL" : title,
          style: TextStyle(
            fontWeight: select ? FontWeight.w500 : FontWeight.w400
          ),
        ),
      ),
    );
  }

  getLooking() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getTitle("Looking to"),
        const SizedBox(
          height: 15,
        ),
        Row(
          children: [
            getLookingTab(Strings.buy),
            const SizedBox(
              width: 15,
            ),
            getLookingTab(selectedTab==Strings.nonCommercial ? Strings.rent : Strings.lease)
          ],
        )
      ],
    );
  }

  getTitle(String title) {
    return Text(
      title,
      style: TextStyle(
          color: colorPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w500
      ),
    );
  }
  getLookingTab(String looking) {
    bool select = looking==selectedLooking;
    return GestureDetector(
      onTap: () {
        if(!select) {
          selectedLooking = looking;
          selectedRate = [];


          set(true);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 14),
        decoration: BoxDecoration(
          color: select ? colorPrimary.withOpacity(0.2) : MyColors.white,
          border: Border.all(
            color: select ? colorPrimary : MyColors.grey10
          ),
          borderRadius: BorderRadius.circular(30)
        ),
        child: Text(
          looking,
          style: TextStyle(
            color: MyColors.generateMaterialColor(colorPrimary).shade700
          ),
        ),
      ),
    );
  }

  getCityDropdown() {
    return DropdownSearch<String>(
      popupProps: const PopupProps.menu(
        showSelectedItems: true,
        showSearchBox: true,
      ),
      items: citiesString,
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Search In City",
          prefixIcon: Icon(
            Icons.search
          )
        ),
      ),
      onChanged: (value) {
        city = value;
        city_id = cities[citiesString.indexOf(city??"")].id??"";
        areas = [];
        areasString = [];
        brokerAreas = [];
        brokerAreasString = [""];
        area = [];
        subArea = [];
        subAreasString = [];
        brokerSubAreas = [];
        brokerSubAreasString = [""];
        subArea = ["+"];
        setState(() {});

        getBrokerAreas(sharedPreferences.getString("id")??"", "city");
        // getPlanType();
      },
      selectedItem: city,
    );
  }

  getAreasDesign() {
    return Container(
      height: 35,
      alignment: Alignment.centerLeft,
      child: ListView.separated(
        itemCount: brokerAreasString.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        separatorBuilder: (BuildContext buildContext, int index) {
          return const SizedBox(
            width: 10,
          );
        },
        itemBuilder: (BuildContext buildContext, int index) {
          return getAreaCard(brokerAreasString[index]);
        },
      ),
    );
  }

  getAreaCard(String area) {
    bool add = area=="";
    bool select = false;
    select = this.area.contains(area);

    return GestureDetector(
      onTap: () {
        if(add) {
          showAreas();
        }
        else {
          if(select) {
            removeArea(area);
          }
          else {
            if(this.area.isEmpty) {
              subAreas = [];
              subAreasString = [];
            }
            this.area.add(area);
            set(true);
            getSubAreas(brokerAreas[brokerAreasString.indexOf(area)-1].id??"", "area");
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: select ? colorPrimary.withOpacity(0.2) : MyColors.white,
            border: Border.all(
              color: select ? colorPrimary : MyColors.grey10
            ),
            borderRadius: BorderRadius.circular(20)
        ),
        child: Row(
          children: [
            select ? Icon(
              Icons.check,
              size: 16,
              color: colorPrimary,
            )
                : const Icon(
              Icons.add,
              size: 16,
            ),
            if(area.isNotEmpty)
              const SizedBox(
                width: 5,
              ),
            if(area.isNotEmpty)
              Text(
                area,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: select ? MyColors.generateMaterialColor(colorPrimary).shade700 : MyColors.black,
                  fontSize: add ? 18 : 14
                ),
              ),
          ],
        ),
      ),
    );
  }

  removeArea(String area) {
    this.area.remove(area);
    String id = brokerAreas[brokerAreasString.indexOf(area)-1].id??"";
    List<SubArea> temp = brokerSubAreas.sublist(0);

    for (int i=0; i<temp.length; i++) {
      if (id == (temp[i].areaID ?? "")) {
          subArea.remove(temp[i].name);
          int j = brokerSubAreasString.indexOf(temp[i].name??"");
          brokerSubAreas.removeAt(j-1);
          brokerSubAreasString.removeAt(j);
      }
    }

    temp = subAreas.sublist(0);
    print(subAreas.length);
    print(temp.length);

    for (int i=0; i<temp.length; i++) {
      print(temp[i].areaID ?? "");
      if (id == (temp[i].areaID ?? "")) {
        int j = subAreasString.indexOf(temp[i].name??"");
        subAreas.removeAt(j);
        subAreasString.removeAt(j);
      }
    }

    set(true);
  }

  getSubAreasDesign() {
    return Container(
      height: 35,
      alignment: Alignment.centerLeft,
      child: ListView.separated(
        itemCount: brokerSubAreasString.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        separatorBuilder: (BuildContext buildContext, int index) {
          return const SizedBox(
            width: 10,
          );
        },
        itemBuilder: (BuildContext buildContext, int index) {
          return getSubAreaCard(brokerSubAreasString[index]);
        },
      ),
    );
  }


  getSubAreaCard(String subArea) {
    bool add = subArea=="";
    bool select = false;
    select = this.subArea.contains(subArea);

    return GestureDetector(
      onTap: () {
        if(add) {
          showSubAreas();
        }
        else {
          if(select) {
            this.subArea.remove(subArea);
          }
          else {
            this.subArea.add(subArea);
          }
          set(true);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: select ? colorPrimary.withOpacity(0.2) : MyColors.white,
            border: Border.all(
                color: select ? colorPrimary : MyColors.grey10
            ),
            borderRadius: BorderRadius.circular(20)
        ),
        child: Row(
          children: [
            select ? Icon(
              Icons.check,
              size: 16,
              color: colorPrimary,
            )
                : const Icon(
              Icons.add,
              size: 16,
            ),
            if(subArea.isNotEmpty)
              const SizedBox(
                width: 5,
              ),
            if(subArea.isNotEmpty)
              Text(
                subArea,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: select ? MyColors.generateMaterialColor(colorPrimary).shade700 : MyColors.black,
                    fontSize: add ? 18 : 14
                ),
              ),
          ],
        ),
      ),
    );
  }


  void showAreas() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return DropdownDialog(
          items: areasString,
          ignore: area,
          title: "Area",
        );
      },
    ).then((value) {
      if((value??"").toString().isNotEmpty) {
        if(area.isEmpty) {
          subArea = [];
          subAreas = [];
          subAreasString = [];
          brokerSubAreasString = [""];
        }
        area.add(value);
        brokerAreasString.add(value);
        brokerAreas.add(areas[areasString.indexOf(value)]);
        set(true);
        getSubAreas(areas[areasString.indexOf(value)].id??"", "area");
      }
    });
  }

  void showSubAreas() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return DropdownDialog(
          items: subAreasString,
          ignore: subArea,
          title: "Sub Area",
        );
      },
    ).then((value) {
      if((value??"").toString().isNotEmpty) {
        subArea.add(value);
        brokerSubAreasString.add(value);
        brokerSubAreas.add(subAreas[subAreasString.indexOf(value)]);
        set(true);
      }
    });
  }

  getBudgetList() {
    return Container(
      height: 35,
      alignment: Alignment.centerLeft,
      child: ListView.separated(
        itemCount: selectedLooking==Strings.buy ? saleRate.length : selectedLooking==Strings.rent ? rentRate.length : leaseRate.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (BuildContext buildContext, int index) {
          return getBudgetTab(selectedLooking==Strings.buy ? saleRate[index] : selectedLooking==Strings.rent ? rentRate[index] : leaseRate[index], selectedLooking);
        },
        separatorBuilder: (BuildContext buildContext, int index) {
          return const SizedBox(
            width: 10,
          );
        },
      ),
    );
  }

  getBudgetTab(String rate, String looking) {
    bool select = false;
    select = selectedRate.contains(rate);

    return GestureDetector(
      onTap: () {

        if(rate.isNotEmpty) {
          if(select) {
            selectedRate.remove(rate);
          }
          else {
            selectedRate.add(rate);
          }
          set(true);
        }
        else {
          showCustomBudget();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: select ? colorPrimary.withOpacity(0.2) : MyColors.white,
            border: Border.all(
                color: select ? colorPrimary : MyColors.grey10
            ),
            borderRadius: BorderRadius.circular(20)
        ),
        child: Row(
          children: [
            select ? Icon(
              Icons.check,
              size: 16,
              color: colorPrimary,
            )
                : const Icon(
              Icons.add,
              size: 16,
            ),
            if(rate.isNotEmpty)
              const SizedBox(
                width: 5,
              ),
            if(rate.isNotEmpty)
              Text(
                rate,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: select ? MyColors.generateMaterialColor(colorPrimary).shade700 : MyColors.black,
                    fontSize: 14
                ),
              ),
          ],
        ),
      ),
    );
  }

  void showCustomBudget() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return BudgetRanger(
          looking: selectedLooking,
          colorPrimary: colorPrimary,
        );
      },
    ).then((value) {
      if((value??"").toString().isNotEmpty) {
        if(selectedLooking==Strings.buy && saleRate.contains(value)==false) {
          saleRate.insert(1, value);
          selectedRate.add(value);
        }
        else if(selectedLooking==Strings.rent && rentRate.contains(value)==false) {
          rentRate.insert(1, value);
          selectedRate.add(value);
        }
        else if(selectedLooking==Strings.lease && leaseRate.contains(value)==false) {
          leaseRate.insert(1, value);
          selectedRate.add(value);
        }
        set(true);
      }
    });
  }

  // getNCCategoryDesign() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //     ],
  //   );
  // }

  getPropertyDesign(List<Category> categories) {
    return ListView.separated(
      itemCount: categories.length > 3 ? 3 : categories.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext buildContext, int index) {
        return getPropertyTab(categories[index], index, categories.length-3);
      },
      separatorBuilder: (BuildContext buildContext, int index) {
        return const SizedBox(
          height: 10,
        );
      },
    );
  }

  getPropertyTab(Category category, int ind, int left) {
    bool select = false;
    select = selectedProperty.contains(category);

    return GestureDetector(
      onTap: () {
        if(selectedProperty.contains(category)) {
          selectedProperty.remove(category);
        }
        else {
          selectedProperty.add(category);
        }
        set(true);
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 14),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: select ? colorPrimary.withOpacity(0.2) : MyColors.white,
                border: Border.all(
                    color: select ? colorPrimary : MyColors.grey10
                ),
                borderRadius: BorderRadius.circular(20)
            ),
            child: Row(
              children: [
                select ? Icon(
                  Icons.check,
                  size: 16,
                  color: colorPrimary,
                )
                    : const Icon(
                  Icons.add,
                  size: 16,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  category.name??"",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: select ? MyColors.generateMaterialColor(colorPrimary).shade700 : MyColors.black,
                      fontSize: 14
                  ),
                ),
              ],
            ),
          ),
          if(ind==2)
            const SizedBox(
              width: 10,
            ),
          if(ind==2)
            GestureDetector(
              onTap: () {
                showPropertyTypes();
              },
              child: Text(
                " + $left more",
                style: TextStyle(
                  fontWeight:  FontWeight.w500,
                  color: colorPrimary
                ),
              ),
            )
        ],
      ),
    );
  }

  getBHKDesign() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        getTitle("No. of Bedrooms"),
        const SizedBox(
          height: 15,
        ),
        getBHKList()
      ],
    );
  }

  getBHKList() {
    return Container(
      height: 35,
      alignment: Alignment.centerLeft,
      child: ListView.separated(
        itemCount: BHK.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (BuildContext buildContext, int index) {
          return getBHKTab(BHK[index]);
        },
        separatorBuilder: (BuildContext buildContext, int index) {
          return const SizedBox(
            width: 10,
          );
        },
      ),
    );
  }

  getBHKTab(String bhk) {
    bool select = false;
    select = selectedBHK.contains(bhk);

    return GestureDetector(
      onTap: () {

        if(bhk.isNotEmpty) {
          if(select) {
            selectedBHK.remove(bhk);
          }
          else {
            selectedBHK.add(bhk);
          }

          set(true);
        }
        else {
          showBedrooms();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: select ? colorPrimary.withOpacity(0.2) : MyColors.white,
            border: Border.all(
                color: select ? colorPrimary : MyColors.grey10
            ),
            borderRadius: BorderRadius.circular(20)
        ),
        child: Row(
          children: [
            select ? Icon(
              Icons.check,
              size: 16,
              color: colorPrimary,
            )
                : const Icon(
              Icons.add,
              size: 16,
            ),
            if(bhk.isNotEmpty)
              const SizedBox(
                width: 5,
              ),
            if(bhk.isNotEmpty)
              Text(
                "$bhk BHK",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: select ? MyColors.generateMaterialColor(colorPrimary).shade700 : MyColors.black,
                    fontSize: 14
                ),
              ),
          ],
        ),
      ),
    );
  }

  getSSFDesign() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        getTitle("Super Build-Up Sq. Ft."),
        const SizedBox(
          height: 15,
        ),
        getSSFList(),
      ],
    );
  }

  getSSFList() {
    return Container(
      height: 35,
      alignment: Alignment.centerLeft,
      child: ListView.separated(
        itemCount: SSF.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (BuildContext buildContext, int index) {
          return getSSFTab(SSF[index]);
        },
        separatorBuilder: (BuildContext buildContext, int index) {
          return const SizedBox(
            width: 10,
          );
        },
      ),
    );
  }

  getSSFTab(String ssf) {
    bool select = false;
    select = selectedSSF.contains(ssf);

    return GestureDetector(
      onTap: () {

        if(ssf.isNotEmpty) {
          if(select) {
            selectedSSF.remove(ssf);
          }
          else {
            selectedSSF.add(ssf);
          }

          set(true);
        }
        else {
          showSSQFT();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: select ? colorPrimary.withOpacity(0.2) : MyColors.white,
            border: Border.all(
                color: select ? colorPrimary : MyColors.grey10
            ),
            borderRadius: BorderRadius.circular(20)
        ),
        child: Row(
          children: [
            select ? Icon(
              Icons.check,
              size: 16,
              color: colorPrimary,
            )
                : const Icon(
              Icons.add,
              size: 16,
            ),
            if(ssf.isNotEmpty)
              const SizedBox(
                width: 5,
              ),
            if(ssf.isNotEmpty)
              Text(
                ssf,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: select ? MyColors.generateMaterialColor(colorPrimary).shade700 : MyColors.black,
                    fontSize: 14
                ),
              ),
          ],
        ),
      ),
    );
  }

  getCSFDesign() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        getTitle("Carpet Area Sq. Ft."),
        const SizedBox(
          height: 15,
        ),
        getCSFList(),
      ],
    );
  }

  getCSFList() {
    return Container(
      height: 35,
      alignment: Alignment.centerLeft,
      child: ListView.separated(
        itemCount: CSF.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (BuildContext buildContext, int index) {
          return getCSFTab(CSF[index]);
        },
        separatorBuilder: (BuildContext buildContext, int index) {
          return const SizedBox(
            width: 10,
          );
        },
      ),
    );
  }

  getCSFTab(String csf) {
    bool select = false;
    select = selectedCSF.contains(csf);

    return GestureDetector(
      onTap: () {

        if(csf.isNotEmpty) {
          if(select) {
            selectedCSF.remove(csf);
          }
          else {
            selectedCSF.add(csf);
          }

          set(true);
        }
        else {
          showCSQFT();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: select ? colorPrimary.withOpacity(0.2) : MyColors.white,
            border: Border.all(
                color: select ? colorPrimary : MyColors.grey10
            ),
            borderRadius: BorderRadius.circular(20)
        ),
        child: Row(
          children: [
            select ? Icon(
              Icons.check,
              size: 16,
              color: colorPrimary,
            )
                : const Icon(
              Icons.add,
              size: 16,
            ),
            if(csf.isNotEmpty)
              const SizedBox(
                width: 5,
              ),
            if(csf.isNotEmpty)
              Text(
                csf,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: select ? MyColors.generateMaterialColor(colorPrimary).shade700 : MyColors.black,
                    fontSize: 14
                ),
              ),
          ],
        ),
      ),
    );
  }

  getVarDesign() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        getTitle("Var"),
        const SizedBox(
          height: 15,
        ),
        getVarList(),
      ],
    );
  }

  getVarList() {
    return Container(
      height: 35,
      alignment: Alignment.centerLeft,
      child: ListView.separated(
        itemCount: Var.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (BuildContext buildContext, int index) {
          return getVarTab(Var[index]);
        },
        separatorBuilder: (BuildContext buildContext, int index) {
          return const SizedBox(
            width: 10,
          );
        },
      ),
    );
  }

  getVarTab(String varr) {
    bool select = false;
    select = selectedVar.contains(varr);

    return GestureDetector(
      onTap: () {

        if(varr.isNotEmpty) {
          if(select) {
            selectedVar.remove(varr);
          }
          else {
            selectedVar.add(varr);
          }

          set(true);
        }
        else {
          showVar();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: select ? colorPrimary.withOpacity(0.2) : MyColors.white,
            border: Border.all(
                color: select ? colorPrimary : MyColors.grey10
            ),
            borderRadius: BorderRadius.circular(20)
        ),
        child: Row(
          children: [
            select ? Icon(
              Icons.check,
              size: 16,
              color: colorPrimary,
            )
                : const Icon(
              Icons.add,
              size: 16,
            ),
            if(varr.isNotEmpty)
              const SizedBox(
                width: 5,
              ),
            if(varr.isNotEmpty)
              Text(
                varr,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: select ? MyColors.generateMaterialColor(colorPrimary).shade700 : MyColors.black,
                    fontSize: 14
                ),
              ),
          ],
        ),
      ),
    );
  }

  getVighaDesign() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        getTitle("Vigha"),
        const SizedBox(
          height: 15,
        ),
        getVighaList(),
      ],
    );
  }

  getVighaList() {
    return Container(
      height: 35,
      alignment: Alignment.centerLeft,
      child: ListView.separated(
        itemCount: Vigha.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (BuildContext buildContext, int index) {
          return getVighaTab(Vigha[index]);
        },
        separatorBuilder: (BuildContext buildContext, int index) {
          return const SizedBox(
            width: 10,
          );
        },
      ),
    );
  }

  getVighaTab(String vigha) {
    bool select = false;
    select = selectedVigha.contains(vigha);

    return GestureDetector(
      onTap: () {

        if(vigha.isNotEmpty) {
          if(select) {
            selectedVigha.remove(vigha);
          }
          else {
            selectedVigha.add(vigha);
          }

          set(true);
        }
        else {
          showVigha();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: select ? colorPrimary.withOpacity(0.2) : MyColors.white,
            border: Border.all(
                color: select ? colorPrimary : MyColors.grey10
            ),
            borderRadius: BorderRadius.circular(20)
        ),
        child: Row(
          children: [
            select ? Icon(
              Icons.check,
              size: 16,
              color: colorPrimary,
            )
                : const Icon(
              Icons.add,
              size: 16,
            ),
            if(vigha.isNotEmpty)
              const SizedBox(
                width: 5,
              ),
            if(vigha.isNotEmpty)
              Text(
                vigha,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: select ? MyColors.generateMaterialColor(colorPrimary).shade700 : MyColors.black,
                    fontSize: 14
                ),
              ),
          ],
        ),
      ),
    );
  }
  void showSSQFT() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return SQFTRanger(
          colorPrimary: colorPrimary,
        );
      },
    ).then((value) {
      if((value??"").toString().isNotEmpty) {
        if(SSF.contains(value)==false) {
          SSF.insert(1, value);
          selectedSSF.add(value);
        }
        else if(SSF.contains(value) && selectedSSF.contains(value)==false) {
          selectedSSF.add(value);
        }


        set(true);
      }
    });
  }

  void showCSQFT() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return SQFTRanger(
          colorPrimary: colorPrimary,
        );
      },
    ).then((value) {
      if((value??"").toString().isNotEmpty) {
        if(CSF.contains(value)==false) {
          CSF.insert(1, value);
          selectedCSF.add(value);
        }
        else if(CSF.contains(value) && selectedCSF.contains(value)==false) {
          selectedCSF.add(value);
        }


        set(true);
      }
    });
  }

  void showVar() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return VVRanger(
          colorPrimary: colorPrimary,
        );
      },
    ).then((value) {
      if((value??"").toString().isNotEmpty) {
        if(Var.contains(value)==false) {
          Var.insert(1, value);
          selectedVar.add(value);
        }
        else if(Var.contains(value) && selectedVar.contains(value)==false) {
          selectedVar.add(value);
        }


        set(true);
      }
    });
  }

  void showVigha() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return VVRanger(
          colorPrimary: colorPrimary,
        );
      },
    ).then((value) {
      if((value??"").toString().isNotEmpty) {
        if(Vigha.contains(value)==false) {
          Vigha.insert(1, value);
          selectedVigha.add(value);
        }
        else if(Vigha.contains(value) && selectedVigha.contains(value)==false) {
          selectedVigha.add(value);
        }


        set(true);
      }
    });
  }

  void showBedrooms() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return BedroomRanger(
          colorPrimary: colorPrimary,
        );
      },
    ).then((value) {
      if((value??"").toString().isNotEmpty) {
        if(BHK.contains(value)==false) {
          BHK.insert(1, value);
          selectedBHK.add(value);
        }
        else if(BHK.contains(value) && selectedBHK.contains(value)==false) {
          selectedBHK.add(value);
        }

        set(true);
      }
    });
  }

  getFurnished() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getTitle("Furnishing Status"),
        const SizedBox(
          height: 15,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              getFurnishedTab(Strings.fully),
              const SizedBox(
                width: 15,
              ),
              getFurnishedTab(Strings.semi),
              const SizedBox(
                width: 15,
              ),
              getFurnishedTab(Strings.un)
            ],
          ),
        )
      ],
    );
  }

  getFurnishedTab(String furnish) {
    bool select = selectedFurnish.contains(furnish);
    return GestureDetector(
      onTap: () {
        if(select) {
          selectedFurnish.remove(furnish);
        }
        else {
          selectedFurnish.add(furnish);
        }

        set(true);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 14),
        decoration: BoxDecoration(
            color: select ? colorPrimary.withOpacity(0.2) : MyColors.white,
            border: Border.all(
                color: select ? colorPrimary : MyColors.grey10
            ),
            borderRadius: BorderRadius.circular(30)
        ),
        child: Text(
          furnish,
          style: TextStyle(
              color: MyColors.generateMaterialColor(colorPrimary).shade700
          ),
        ),
      ),
    );
  }

  getFloorList() {
    return Container(
      height: 35,
      alignment: Alignment.centerLeft,
      child: ListView.separated(
        itemCount: Floor.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (BuildContext buildContext, int index) {
          return getFloorTab(Floor[index]);
        },
        separatorBuilder: (BuildContext buildContext, int index) {
          return const SizedBox(
            width: 10,
          );
        },
      ),
    );
  }

  getFloorTab(String floor) {
    bool select = false;
    select = selectedFloor.contains(floor);

    return GestureDetector(
      onTap: () {

        if(floor.isNotEmpty) {
          if(select) {
            selectedFloor.remove(floor);
          }
          else {
            selectedFloor.add(floor);
          }

          set(true);
        }
        else {
          showFloors();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: select ? colorPrimary.withOpacity(0.2) : MyColors.white,
            border: Border.all(
                color: select ? colorPrimary : MyColors.grey10
            ),
            borderRadius: BorderRadius.circular(20)
        ),
        child: Row(
          children: [
            select ? Icon(
              Icons.check,
              size: 16,
              color: colorPrimary,
            )
                : const Icon(
              Icons.add,
              size: 16,
            ),
            if(floor.isNotEmpty)
              const SizedBox(
                width: 5,
              ),
            if(floor.isNotEmpty)
              Text(
                floor,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: select ? MyColors.generateMaterialColor(colorPrimary).shade700 : MyColors.black,
                    fontSize: 14
                ),
              ),
          ],
        ),
      ),
    );
  }

  void showFloors() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return TextDialog(
          label: "Floor",
          colorPrimary: colorPrimary,
        );
      },
    ).then((value) {
      if((value??"").toString().isNotEmpty) {
        if(Floor.contains(value)==false) {
          Floor.insert(1, value);
          selectedFloor.add(value);
        }
        else if(Floor.contains(value) && selectedFloor.contains(value)==false) {
          selectedFloor.add(value);
        }


        set(true);
      }
    });
  }

  getRera() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getTitle("Rera Status"),
        const SizedBox(
          height: 15,
        ),
        Row(
          children: [
            getReraTab(Strings.app),
            const SizedBox(
              width: 15,
            ),
            getReraTab(Strings.unapp),
          ],
        )
      ],
    );
  }

  getReraTab(String rera) {
    bool select = selectedRera.contains(rera);
    return GestureDetector(
      onTap: () {
        if(select) {
          selectedRera.remove(rera);
        }
        else {
          selectedRera.add(rera);
        }

        set(true);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 14),
        decoration: BoxDecoration(
            color: select ? colorPrimary.withOpacity(0.2) : MyColors.white,
            border: Border.all(
                color: select ? colorPrimary : MyColors.grey10
            ),
            borderRadius: BorderRadius.circular(30)
        ),
        child: Text(
          rera,
          style: TextStyle(
              color: MyColors.generateMaterialColor(colorPrimary).shade700
          ),
        ),
      ),
    );
  }
  
  getCategories() async {
    Map<String, dynamic> data = {
      APIConstant.act : APIConstant.getAll
    };

    CategoryResponse categoryResponse = await APIService().getCategories(data);
    categories = categoryResponse.category ?? [];

    List<String> cat = criteria!=null ? criteria!.category!.split(",") : [];

    for (var element in categories) {
      if(element.type=="NON COMMERCIAL") {
        ncomcat.add(element);
      }
      else {
        comcat.add(element);
      }

      if(cat.contains(element.name??"")) {
        selectedProperty.add(element);
      }
    }
    setState(() {

    });
    getBrokerCity(sharedPreferences.getString("id")??"");
  }

  getBrokerCity(String id) async {
    Map<String, dynamic> data = {
      APIConstant.act : APIConstant.getByBroker,
      'id' : id
    };

    BrokerCityResponse cityResponse = await APIService().getBrokerCities(data);
    cities = cityResponse.city ?? [];

    for (var element in cities) {
      citiesString.add(element.name!);
      if(city_id==element.id) {
        city = element.name??"";
      }
    }

    if(cityResponse.brokerCity!.id!.isNotEmpty && city_id==null) {
      city = cityResponse.brokerCity!.name??"";
      city_id = cityResponse.brokerCity!.id??"";
    }

    setState(() {

    });

    getBrokerAreas(id, city_id!.isNotEmpty ? "city" : "");
  }

  getBrokerAreas(String id, String type) async {
    Map<String, dynamic> data = {
      APIConstant.act : APIConstant.getByBroker,
      'id' : id,
      'city_id' : city_id??""
    };

    BrokerAreaResponse brokerAreaResponse = await APIService().getBrokerAreas(data);
    areas = brokerAreaResponse.area ?? [];
    brokerAreas = brokerAreaResponse.brokerArea ?? [];

    for (var element in areas) {
      areasString.add(element.name!);
    }

    for (var element in brokerAreas) {
      brokerAreasString.add(element.name!);
    }

    if(criteria!=null && area.isNotEmpty) {
      for (var element in area) {
        if(!brokerAreasString.contains(element)) {
          int index = areasString.indexOf(element);
          brokerAreas.add(areas[index]);
          brokerAreasString.add(element);
          setState(() {

          });
        }
        await getSubAreas(brokerAreas[brokerAreasString.indexOf(element)-1].id??"", "area");
      }

    }
    else {
      await getSubAreas(city_id??"", type);
    }

    if(criteria!=null && subArea.isNotEmpty) {
      for (var element in subArea) {
        if (!brokerSubAreasString.contains(element)) {
          int index = subAreasString.indexOf(element);
          brokerSubAreas.add(subAreas[index]);
          brokerSubAreasString.add(element);
          setState(() {

          });
        }
      }
    }

    load = true;
    setState(() {

    });
  }

  getSubAreas(id, type) async {
    Map<String, dynamic> data = {
      APIConstant.act : id.isNotEmpty ? type=="area" ? APIConstant.getByAID : APIConstant.getByCID : APIConstant.getAll,
      'id' : sharedPreferences.getString("id"),
      'o_id' : id
    };

    BrokerSubAreaResponse brokerSubAreaResponse = await APIService().getSubAreas(data);

    for (var element in brokerSubAreaResponse.subArea ?? []) {
      subAreas.add(element);
      subAreasString.add(element.name!);
    }

    for (var element in brokerSubAreaResponse.brokerSubArea ?? []) {
      brokerSubAreas.add(element);
      brokerSubAreasString.add(element.name!);
    }

    setState(() {

    });
  }

  addLead() async {
    Map<String, String> data = criteria==null ? {
      APIConstant.act : APIConstant.add,
      "id" : sharedPreferences.getString("id")??""
    } : {
      APIConstant.act : APIConstant.update,
      "pid" : criteria?.id??""
    };

    data["filter"] = getFilters();
    data["description"] = getDescription();
    data['type'] = selectedTab;
    data['purpose'] = selectedLooking;
    data['city'] = city_id??"";
    data['areas'] = area.isNotEmpty ? getAreas() : "";
    data['subAreas'] = subArea.isNotEmpty ? getSubArea() : "";
    data['property'] = selectedProperty.isNotEmpty ? getProperty() : "";
    data['budget'] = selectedRate.isNotEmpty ? getRate() : "";
    data['bhk'] = selectedBHK.isNotEmpty && selectedTab==Strings.nonCommercial && getBHKStatus()? getBHK() : "";
    data['var'] = selectedVar.isNotEmpty && getVarStatus() ? getVar() : "";
    data['vigha'] = selectedVigha.isNotEmpty && getVighaStatus() ? getVigha() : "";
    data['ssf'] = selectedSSF.isNotEmpty && getSSFStatus() ? getSSF() : "";
    data['csf'] = selectedCSF.isNotEmpty && getCSFStatus() ? getCSF() : "";
    data['furnish'] = selectedFurnish.isNotEmpty ? getFurnish() : "";
    data['floor'] = selectedFloor.isNotEmpty ? getFloor() : "";
    data['rera'] = selectedRera.isNotEmpty ? getReras() : "";

    data.addAll(widget.data!);

    print(data);

    Response response = await APIService().addLead(data);
    print(response.message);
    Toast.sendToast(context, response.message??"");

    if(response.status=="Success") {
      Navigator.pop(context);
      Navigator.pop(context, "reload");
    }
  }

  getFilters() {
    String purpose = "(${selectedLooking==Strings.buy ? "'SALE'" : selectedLooking==Strings.rent ? "'RENT', 'PG'" : 'selectedLooking'})";
    String areas = area.isNotEmpty ? getSelectedAreas() : "";
    String subAreas = subArea.isNotEmpty ? getSelectedSubAreas() : "";
    String property = selectedProperty.isNotEmpty ? getSelectedProperty() : "";
    String budget = selectedRate.isNotEmpty ? getSelectedRate() : "";
    String bhk = selectedBHK.isNotEmpty && selectedTab==Strings.nonCommercial && getBHKStatus() ? getSelectedBHK() : "";
    String varr = selectedVar.isNotEmpty && getVarStatus() ? getSelectedVar() : "";
    String vigha = selectedVigha.isNotEmpty && getVighaStatus() ? getSelectedVigha() : "";
    String ssf = selectedSSF.isNotEmpty && getSSFStatus() ? getSelectedSSF() : "";
    String csf = selectedCSF.isNotEmpty && getCSFStatus() ? getSelectedCSF() : "";
    String furnish = selectedFurnish.isNotEmpty ? getSelectedFurnish() : "";
    String floor = selectedFloor.isNotEmpty ? getSelectedFloor() : "";
    String rera = selectedRera.isNotEmpty ? getSelectedRera() : "";


    return " AND c.type='$selectedTab' AND sp.Purpose IN $purpose AND sp.City=$city_id$areas$subAreas$property$budget$bhk$varr$vigha$ssf$csf$furnish$floor$rera";
  }

  getDescription() {
    String type = selectedTab==Strings.nonCommercial ? "RESIDENTIAL" : selectedTab;
    String purpose = selectedLooking==Strings.buy ? "SALE" : selectedLooking==Strings.rent ? "RENT, PG" : selectedLooking;
    String areas = area.isNotEmpty ? "Areas: ${getAreas()}\n" : "";
    String subAreas = subArea.isNotEmpty ? "Sub Areas: ${getSubArea()}\n" : "";
    String property = selectedProperty.isNotEmpty ? "Category: ${getProperty()}\n" : "";
    String budget = selectedRate.isNotEmpty ? "Budget: ${getRate()}\n" : "";
    String bhk = selectedBHK.isNotEmpty && selectedTab==Strings.nonCommercial && getBHKStatus() ? "BHK: ${getBHK()}\n" : "";
    String varr = selectedVar.isNotEmpty && getVarStatus() ? "Var: ${getVar()}\n" : "";
    String vigha = selectedVigha.isNotEmpty && getVighaStatus() ? "Vigha: ${getVigha()}\n" : "";
    String ssf = selectedSSF.isNotEmpty && getSSFStatus() ? "Super Sq Ft: ${getSSF()}\n" : "";
    String csf = selectedCSF.isNotEmpty && getCSFStatus() ? "Carpet Sq Ft: ${getCSF()}\n" : "";
    String furnish = selectedFurnish.isNotEmpty ? "Furnishing Status: ${getFurnish()}\n" : "";
    String floor = selectedFloor.isNotEmpty ? "Floor: ${getFloor()}\n" : "";
    String rera = selectedRera.isNotEmpty ? "Rera: ${getReras()}\n" : "";


    return "Category Type: $type\nProperty On: $purpose\nCity: $city\n$areas$subAreas$property$budget$bhk$varr$vigha$ssf$csf$furnish$floor$rera";
  }

  String getSelectedAreas() {
    String area = " AND sp.Area IN (";
    print(brokerAreas.length);
    print(brokerAreasString.length);
    for (var element in this.area) {
      area+="${brokerAreas[brokerAreasString.indexOf(element)-1].id??""},";
    }
    return "${area.substring(0, area.length-1)})";
  }

  String getAreas() {
    String area = "";
    for (var element in this.area) {
      area+="$element,";
    }
    return area.substring(0, area.length-1);
  }

  String getSelectedSubAreas() {
    String subArea = " AND sp.SubArea IN (";
    for (var element in this.subArea) {
      subArea+="${brokerSubAreas[brokerSubAreasString.indexOf(element)-1].id??""},";
    }
    return "${subArea.substring(0, subArea.length-1)})";
  }

  String getSubArea() {
    String subArea = "";
    for (var element in this.subArea) {
      subArea+="$element,";
    }
    return subArea.substring(0, subArea.length-1);
  }

  String getSelectedProperty() {
    String property = " AND c.name IN (";
    for (var element in selectedProperty) {
      property+="'${element.name}',";
    }
    return "${property.substring(0, property.length-1)})";
  }

  String getProperty() {
    String property = "";
    for (var element in selectedProperty) {
      property+="${element.name},";
    }
    return property.substring(0, property.length-1);
  }

  String getSelectedRate() {
    String rate = " AND ( ";
    for (var element in selectedRate) {
      print(element);
      if(element.contains("+Cr")) {
        if(element.contains("-")) {
          String from = element.substring(0, element.indexOf("-"));

          if(from.contains("k")) {
            from = (double.parse(from.substring(0, from.indexOf('k'))) * 1000).toStringAsFixed(0);
          }
          else if (from.contains("L")) {
            from = (double.parse(from.substring(0, from.indexOf('L'))) * 100000).toStringAsFixed(0);
          }
          else if (from.contains("Cr")) {
            from = (double.parse(from.substring(0, from.indexOf('Cr'))) * 10000000).toStringAsFixed(0);
          }
          else {
            from = (double.parse(from) * 10000000).toStringAsFixed(0);
          }
          rate += "(sp.Amount >= $from) OR ";
        }
        else {
          String to = (double.parse(element.substring(0, element.indexOf('+Cr'))) * 10000000).toStringAsFixed(0);
          rate += "(sp.Amount >= $to) OR ";
        }
      }
      else {
        String from = element.substring(0, element.indexOf("-"));
        String to = element.substring(element.indexOf("-") + 1);
        int unit = 0;

        if (to.contains("k")) {
          unit = 1000;
          to = (double.parse(to.substring(0, to.indexOf('k'))) * 1000).toStringAsFixed(0);
        }
        else if (to.contains("L")) {
          unit = 100000;
          to = (double.parse(to.substring(0, to.indexOf('L'))) * 100000).toStringAsFixed(0);
        }
        else if (to.contains("Cr")) {
          unit = 10000000;
          to = (double.parse(to.substring(0, to.indexOf('Cr'))) * 10000000).toStringAsFixed(0);
        }


        if(from.contains("k")) {
          from = (double.parse(from.substring(0, from.indexOf('k'))) * 1000).toStringAsFixed(0);
        }
        else if (from.contains("L")) {
          from = (double.parse(from.substring(0, from.indexOf('L'))) * 100000).toStringAsFixed(0);
        }
        else if (from.contains("Cr")) {
          from = (double.parse(from.substring(0, from.indexOf('Cr'))) * 10000000).toStringAsFixed(0);
        }
        else {
          from = (double.parse(from) * unit).toStringAsFixed(0);
        }

        rate += "(sp.Amount BETWEEN $from AND $to) OR ";
      }
    }
    return "${rate.substring(0, rate.length-3)})";
  }

  String getRate() {
    String rate = "";
    for (var element in selectedRate) {
      rate+="$element,";
    }
    return rate.substring(0, rate.length-1);
  }

  String getSelectedBHK() {
    String bhk = " AND sp.bhk IN (";
    for (var element in selectedBHK) {
      bhk+="$element,";
    }
    return "${bhk.substring(0, bhk.length-1)})";
  }

  String getBHK() {
    String bhk = "";
    for (var element in selectedBHK) {
      bhk+="$element,";
    }
    return bhk.substring(0, bhk.length-1);
  }

  String getSelectedVar() {
    String varr = " AND ( ";
    for (var element in selectedVar) {
      if(element.contains("+")) {
        String value = element.substring(0, element.length-1);
        varr += "(sp.Var >= $value) OR ";
      }
      else {
        String from = element.substring(0, element.indexOf("-"));
        String to = element.substring(element.indexOf("-") + 1);

        varr += "(sp.Var BETWEEN $from AND $to) OR ";
      }
    }
    return "${varr.substring(0, varr.length-3)})";
  }

  String getVar() {
    String varr = "";
    for (var element in selectedVar) {
      varr+="$element,";
    }
    return varr.substring(0, varr.length-1);
  }


  String getSelectedVigha() {
    String vigha = " AND ( ";
    for (var element in selectedVigha) {
      if(element.contains("+")) {
        String value = element.substring(0, element.length-1);
        vigha += "(sp.Vigha >= $value) OR ";
      }
      else {
        String from = element.substring(0, element.indexOf("-"));
        String to = element.substring(element.indexOf("-") + 1);

        vigha += "(sp.Vigha BETWEEN $from AND $to) OR ";
      }
    }
    return "${vigha.substring(0, vigha.length-3)})";
  }

  String getVigha() {
    String vigha = "";
    for (var element in selectedVigha) {
      vigha+="$element,";
    }
    return vigha.substring(0, vigha.length-1);
  }

  String getSelectedSSF() {
    String ssf = " AND ( ";
    for (var element in selectedSSF) {
      String from = element.substring(0, element.indexOf("-"));
      String to = element.substring(element.indexOf("-")+1);

      ssf+="(sp.sqft_super BETWEEN $from AND $to) OR ";
    }
    return "${ssf.substring(0, ssf.length-3)})";
  }

  String getSSF() {
    String ssf = "";
    for (var element in selectedSSF) {
      ssf+="$element,";
    }
    return ssf.substring(0, ssf.length-1);
  }

  String getSelectedCSF() {
    String csf = " AND ( ";
    for (var element in selectedCSF) {
      String from = element.substring(0, element.indexOf("-"));
      String to = element.substring(element.indexOf("-")+1);

      csf+="(sp.sqft_carpet BETWEEN $from AND $to) OR ";
    }
    return "${csf.substring(0, csf.length-3)})";
  }

  String getCSF() {
    String csf = "";
    for (var element in selectedCSF) {
      csf+="$element,";
    }
    return csf.substring(0, csf.length-1);
  }

  String getSelectedFurnish() {
    String furnish = " AND sp.FurnishedOrNot IN (";
    for (var element in selectedFurnish) {
      furnish+="'$element',";
    }
    return "${furnish.substring(0, furnish.length-1)})";
  }

  String getFurnish() {
    String furnish = "";
    for (var element in selectedFurnish) {
      furnish+="$element,";
    }
    return furnish.substring(0, furnish.length-1);
  }

  String getSelectedFloor() {
    String floor = " AND UPPER(sp.Floor) IN (";
    for (var element in selectedFloor) {
      floor+="'${element.toUpperCase()}',";
    }
    return "${floor.substring(0, floor.length-1)})";
  }

  String getFloor() {
    String floor = "";
    for (var element in selectedFloor) {
      floor+="${element.toUpperCase()},";
    }
    return floor.substring(0, floor.length-1);
  }


  String getSelectedRera() {
    String rera = " AND sp.rera IN (";
    for (var element in selectedRera) {
      rera+="'${element.toUpperCase()}',";
    }
    return "${rera.substring(0, rera.length-1)})";
  }

  String getReras() {
    String rera = "";
    for (var element in selectedRera) {
      rera+="${element.toUpperCase()},";
    }
    return rera.substring(0, rera.length-1);
  }

  set(bool call) {
    setState(() {

    });
  }

  void showPropertyTypes() {
    List<Category> categories = selectedTab==Strings.nonCommercial? ncomcat : comcat;
    List<Category> select = [];
    select.addAll(selectedProperty);

    showModalBottomSheet<dynamic>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Padding(
                padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListView.separated(
                            itemCount: categories.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            separatorBuilder: (BuildContext buildContext, int index) {
                              return const SizedBox(
                                height: 10,
                              );
                            },
                            itemBuilder: (BuildContext buildContext, int index) {
                              print(select);
                              print(categories[index]);
                              return CheckboxListTile(
                                value: select.contains(categories[index]),
                                onChanged: (value) {
                                  if(value==true) {
                                    select.add(categories[index]);
                                  }
                                  else {
                                    select.remove(categories[index]);
                                  }
                                  setState(() {

                                  });
                                },
                                title: Text(
                                  categories[index].name??""
                                ),
                              );
                            },
                          ),
                          Container(
                            height: 45,
                            width: MySize.size100(context),
                            margin: const EdgeInsets.only(
                                bottom: 15, left: 15, right: 15),
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context, "apply");
                                },
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        colorPrimary)
                                ),
                                child: Text("APPLY",
                                  style: TextStyle(color: MyColors.white),)
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              );
            }
        );
      },
    ).then((value) {
      if(value=="apply") {
        selectedProperty = select;
      }
      setState(() {

      });
    });
  }

  bool getBHKStatus() {
    bool status = false;
    for (var element in selectedProperty) {
      if(element.bhk=="1") {
        status = true;
      }
    }
    return status;
  }

  bool getSSFStatus() {
    bool status = false;
    for (var element in selectedProperty) {
      if(element.ssqft=="1") {
        status = true;
      }
    }
    return status;
  }

  bool getCSFStatus() {
    bool status = false;
    for (var element in selectedProperty) {
      if(element.csqft=="1") {
        status = true;
      }
    }
    return status;
  }

  bool getVarStatus() {
    bool status = false;
    for (var element in selectedProperty) {
      if(element.varr=="1") {
        status = true;
      }
    }
    return status;
  }

  bool getVighaStatus() {
    bool status = false;
    for (var element in selectedProperty) {
      if(element.vigha=="1") {
        status = true;
      }
    }
    return status;
  }

}
