import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:real_estate_brokers/models/BrokerAreaResponse.dart';
import 'package:real_estate_brokers/models/BrokerCityResponse.dart';
import 'package:real_estate_brokers/models/BrokerSubAreaResponse.dart';
import 'package:real_estate_brokers/models/PropertyResponse.dart';
import 'package:real_estate_brokers/ranger/BedroomRanger.dart';
import 'package:real_estate_brokers/ranger/BudgetRanger.dart';
import 'package:real_estate_brokers/DropdownDialog.dart';
import 'package:real_estate_brokers/ranger/FloorDialog.dart';
import 'package:real_estate_brokers/ranger/SQFTRanger.dart';
import 'package:real_estate_brokers/api/APIConstant.dart';
import 'package:real_estate_brokers/api/APIService.dart';
import 'package:real_estate_brokers/colors/MyColors.dart';
import 'package:real_estate_brokers/models/AreaResponse.dart';
import 'package:real_estate_brokers/models/CategoryResponse.dart';
import 'package:real_estate_brokers/models/CityResponse.dart';
import 'package:real_estate_brokers/models/SubAreaResponse.dart';
import 'package:real_estate_brokers/size/MySize.dart';
import 'package:real_estate_brokers/strings/Strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

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

  @override
  void initState() {
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
    setState(() {

    });
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
      ),
      bottomNavigationBar: Container(
        height: 45,
        width: 120,
        margin: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
        child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context, properties);
            },
            child: load ?
            Text("See all ${properties.isNotEmpty ? "${properties.length} " : ""}Properties")
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
             if(selectedTab==Strings.nonCommercial)
               getBHKDesign(),
              const SizedBox(
                height: 20,
              ),
              getTitle("Super Build-Up Sq. Ft."),
              const SizedBox(
                height: 15,
              ),
              getSSFList(),
              const SizedBox(
                height: 20,
              ),
              getTitle("Carpet Area Sq. Ft."),
              const SizedBox(
                height: 15,
              ),
              getCSFList(),
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
          border: select ? Border(bottom: BorderSide(color: MyColors.colorPrimary, width: 1.5)) : null
        ),
        child: Text(
          title,
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
          color: MyColors.colorPrimary,
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
          color: select ? MyColors.colorPrimary.withOpacity(0.2) : MyColors.white,
          border: Border.all(
            color: select ? MyColors.colorPrimary : MyColors.grey10
          ),
          borderRadius: BorderRadius.circular(30)
        ),
        child: Text(
          looking,
          style: TextStyle(
            color: MyColors.colorDarkPrimary
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
        areas = [];
        areasString = [];
        area = [];
        subArea = [];
        subAreasString = [];
        subArea = ["+"];
        setState(() {});

        getBrokerAreas(cities[citiesString.indexOf(city??"")].id??"", "city");
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
            color: select ? MyColors.colorPrimary.withOpacity(0.2) : MyColors.white,
            border: Border.all(
              color: select ? MyColors.colorPrimary : MyColors.grey10
            ),
            borderRadius: BorderRadius.circular(20)
        ),
        child: Row(
          children: [
            select ? Icon(
              Icons.check,
              size: 16,
              color: MyColors.colorPrimary,
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
                  color: select ? MyColors.colorDarkPrimary : MyColors.black,
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
            color: select ? MyColors.colorPrimary.withOpacity(0.2) : MyColors.white,
            border: Border.all(
                color: select ? MyColors.colorPrimary : MyColors.grey10
            ),
            borderRadius: BorderRadius.circular(20)
        ),
        child: Row(
          children: [
            select ? Icon(
              Icons.check,
              size: 16,
              color: MyColors.colorPrimary,
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
                    color: select ? MyColors.colorDarkPrimary : MyColors.black,
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
            color: select ? MyColors.colorPrimary.withOpacity(0.2) : MyColors.white,
            border: Border.all(
                color: select ? MyColors.colorPrimary : MyColors.grey10
            ),
            borderRadius: BorderRadius.circular(20)
        ),
        child: Row(
          children: [
            select ? Icon(
              Icons.check,
              size: 16,
              color: MyColors.colorPrimary,
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
                    color: select ? MyColors.colorDarkPrimary : MyColors.black,
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
          looking: selectedLooking
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
        return getPropertyTab(categories[index], index);
      },
      separatorBuilder: (BuildContext buildContext, int index) {
        return const SizedBox(
          height: 10,
        );
      },
    );
  }

  getPropertyTab(Category category, int ind) {
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
                color: select ? MyColors.colorPrimary.withOpacity(0.2) : MyColors.white,
                border: Border.all(
                    color: select ? MyColors.colorPrimary : MyColors.grey10
                ),
                borderRadius: BorderRadius.circular(20)
            ),
            child: Row(
              children: [
                select ? Icon(
                  Icons.check,
                  size: 16,
                  color: MyColors.colorPrimary,
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
                      color: select ? MyColors.colorDarkPrimary : MyColors.black,
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
            Text(
              " + ${categories.length - 3} more",
              style: TextStyle(
                fontWeight:  FontWeight.w500,
                color: MyColors.colorPrimary
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
            color: select ? MyColors.colorPrimary.withOpacity(0.2) : MyColors.white,
            border: Border.all(
                color: select ? MyColors.colorPrimary : MyColors.grey10
            ),
            borderRadius: BorderRadius.circular(20)
        ),
        child: Row(
          children: [
            select ? Icon(
              Icons.check,
              size: 16,
              color: MyColors.colorPrimary,
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
                    color: select ? MyColors.colorDarkPrimary : MyColors.black,
                    fontSize: 14
                ),
              ),
          ],
        ),
      ),
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
            color: select ? MyColors.colorPrimary.withOpacity(0.2) : MyColors.white,
            border: Border.all(
                color: select ? MyColors.colorPrimary : MyColors.grey10
            ),
            borderRadius: BorderRadius.circular(20)
        ),
        child: Row(
          children: [
            select ? Icon(
              Icons.check,
              size: 16,
              color: MyColors.colorPrimary,
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
                    color: select ? MyColors.colorDarkPrimary : MyColors.black,
                    fontSize: 14
                ),
              ),
          ],
        ),
      ),
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
            color: select ? MyColors.colorPrimary.withOpacity(0.2) : MyColors.white,
            border: Border.all(
                color: select ? MyColors.colorPrimary : MyColors.grey10
            ),
            borderRadius: BorderRadius.circular(20)
        ),
        child: Row(
          children: [
            select ? Icon(
              Icons.check,
              size: 16,
              color: MyColors.colorPrimary,
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
                    color: select ? MyColors.colorDarkPrimary : MyColors.black,
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
        return const SQFTRanger(
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
        return const SQFTRanger(
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

  void showBedrooms() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return const BedroomRanger(
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
            color: select ? MyColors.colorPrimary.withOpacity(0.2) : MyColors.white,
            border: Border.all(
                color: select ? MyColors.colorPrimary : MyColors.grey10
            ),
            borderRadius: BorderRadius.circular(30)
        ),
        child: Text(
          furnish,
          style: TextStyle(
              color: MyColors.colorDarkPrimary
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
            color: select ? MyColors.colorPrimary.withOpacity(0.2) : MyColors.white,
            border: Border.all(
                color: select ? MyColors.colorPrimary : MyColors.grey10
            ),
            borderRadius: BorderRadius.circular(20)
        ),
        child: Row(
          children: [
            select ? Icon(
              Icons.check,
              size: 16,
              color: MyColors.colorPrimary,
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
                    color: select ? MyColors.colorDarkPrimary : MyColors.black,
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
        return const FloorDialog(
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
            color: select ? MyColors.colorPrimary.withOpacity(0.2) : MyColors.white,
            border: Border.all(
                color: select ? MyColors.colorPrimary : MyColors.grey10
            ),
            borderRadius: BorderRadius.circular(30)
        ),
        child: Text(
          rera,
          style: TextStyle(
              color: MyColors.colorDarkPrimary
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

    for (var element in categories) {
      if(element.type=="NON COMMERCIAL") {
        ncomcat.add(element);
      }
      else {
        comcat.add(element);
      }
    }

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
    }

    if(cityResponse.brokerCity!.name!.isNotEmpty) {
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

    getSubAreas(city_id??"", type);
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

    searchProperties();
  }

  Future<void> searchProperties() async {
    Map<String, String> data = {
      APIConstant.act : APIConstant.getByFilter,
      "filter" : getFilters(),
      "id" : sharedPreferences.getString("id")??""
    };

    print(data);

    PropertyListResponse propertyListResponse = await APIService().getProperties(data);
    properties = propertyListResponse.property ?? [];


    load = true;
    setState(() {

    });
  }

  getFilters() {
    String purpose = "(${selectedLooking==Strings.buy ? "'SALE'" : selectedLooking==Strings.rent ? "'RENT', 'PG'" : 'selectedLooking'})";
    String areas = area.isNotEmpty ? getSelectedAreas() : "";
    String subAreas = subArea.isNotEmpty ? getSelectedSubAreas() : "";
    String property = selectedProperty.isNotEmpty ? getSelectedProperty() : "";
    String budget = selectedRate.isNotEmpty ? getSelectedRate() : "";
    String bhk = selectedBHK.isNotEmpty && selectedTab==Strings.nonCommercial ? getSelectedBHK() : "";
    String ssf = selectedSSF.isNotEmpty ? getSelectedSSF() : "";
    String csf = selectedCSF.isNotEmpty ? getSelectedCSF() : "";
    String furnish = selectedFurnish.isNotEmpty ? getSelectedFurnish() : "";
    String floor = selectedFloor.isNotEmpty ? getSelectedFloor() : "";
    String rera = selectedRera.isNotEmpty ? getSelectedRera() : "";


    return " AND c.type='$selectedTab' AND sp.Purpose IN $purpose AND sp.City=$city_id$areas$subAreas$property$budget$bhk$ssf$csf$furnish$floor$rera";
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

  String getSelectedSubAreas() {
    String subArea = " AND sp.SubArea IN (";
    for (var element in this.subArea) {
      subArea+="${brokerSubAreas[brokerSubAreasString.indexOf(element)-1].id??""},";
    }
    return "${subArea.substring(0, subArea.length-1)})";
  }

  String getSelectedProperty() {
    String property = " AND c.name IN (";
    for (var element in selectedProperty) {
      property+="'${element.name}',";
    }
    return "${property.substring(0, property.length-1)})";
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
          rate += "(sp.Rate >= $from) OR ";
        }
        else {
          String to = (double.parse(element.substring(0, element.indexOf('+Cr'))) * 10000000).toStringAsFixed(0);
          rate += "(sp.Rate >= $to) OR ";
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

        rate += "(sp.Rate BETWEEN $from AND $to) OR ";
      }
    }
    return "${rate.substring(0, rate.length-3)})";
  }

  String getSelectedBHK() {
    String bhk = " AND sp.bhk IN (";
    for (var element in selectedBHK) {
      bhk+="${element},";
    }
    return "${bhk.substring(0, bhk.length-1)})";
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

  String getSelectedCSF() {
    String csf = " AND ( ";
    for (var element in selectedCSF) {
      String from = element.substring(0, element.indexOf("-"));
      String to = element.substring(element.indexOf("-")+1);

      csf+="(sp.sqft_carpet BETWEEN $from AND $to) OR ";
    }
    return "${csf.substring(0, csf.length-3)})";
  }

  String getSelectedFurnish() {
    String furnish = " AND sp.FurnishedOrNot IN (";
    for (var element in selectedFurnish) {
      furnish+="'${element}',";
    }
    return "${furnish.substring(0, furnish.length-1)})";
  }

  String getSelectedFloor() {
    String floor = " AND UPPER(sp.Floor) IN (";
    for (var element in selectedFloor) {
      floor+="'${element.toUpperCase()}',";
    }
    return "${floor.substring(0, floor.length-1)})";
  }

  String getSelectedRera() {
    String rera = " AND sp.rera IN (";
    for (var element in selectedRera) {
      rera+="'${element.toUpperCase()}',";
    }
    return "${rera.substring(0, rera.length-1)})";
  }

  set(bool call) {
    if(call) {
      load = false;
      searchProperties();
    }
    setState(() {

    });
  }
}
