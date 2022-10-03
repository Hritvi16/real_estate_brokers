import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:real_estate_brokers/Essential.dart';
import 'package:real_estate_brokers/models/AmenityResponse.dart';
import 'package:real_estate_brokers/models/LoginResponse.dart';
import 'package:real_estate_brokers/models/PropertyResponse.dart';
import 'package:real_estate_brokers/models/CategoryResponse.dart' as c;

class PDFDesign {
  static getFirstPage(netImage, Broker broker) {
    return pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            padding: pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(
                color: PdfColor.fromHex("#"+(broker.color??"263238")),
                width: 2
              )
            ),
            child: pw.Container(
              padding: pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(
                  color: PdfColor.fromHex("#"+(broker.color??"263238")),
                  width: 1
                )
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Container(
                      height: 350,
                      width: 350,
                      alignment: pw.Alignment.center,
                      child: pw.Image(netImage),
                    ),
                    pw.SizedBox(
                        height: 10
                    ),
                    pw.Text(
                        broker.companyName??"",
                        style: pw.TextStyle(
                            fontSize: 25,
                            font: pw.Font.helveticaBold()
                        )
                    ),
                    pw.SizedBox(
                        height: 10
                    ),
                    pw.Center(
                      child: pw.Text(
                          broker.address??"",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontSize: 20,
                              font: pw.Font.helveticaBold()
                          )
                      ),
                    ),
                    pw.SizedBox(
                        height: 5
                    ),
                    pw.Text(
                        broker.officeNumber1??"",
                        style: pw.TextStyle(
                            fontSize: 20,
                            font: pw.Font.helveticaBold()
                        )
                    ),
                    pw.SizedBox(
                        height: 5
                    ),
                    pw.Text(
                        broker.officeNumber2??"",
                        style: pw.TextStyle(
                            fontSize: 20,
                            font: pw.Font.helveticaBold()
                        )
                    ),
                    pw.SizedBox(
                        height: 10
                    ),
                    pw.Text(
                        broker.email??"",
                        style: pw.TextStyle(
                            fontSize: 20,
                            font: pw.Font.helveticaBold()
                        )
                    ),
                    pw.SizedBox(
                        height: 10
                    ),
                    pw.Text(
                        broker.website1??"",
                        style: pw.TextStyle(
                            fontSize: 20,
                            font: pw.Font.helveticaBold()
                        )
                    ),
                    pw.SizedBox(
                        height: 10
                    ),
                    pw.Text(
                        broker.website2??"",
                        style: pw.TextStyle(
                            fontSize: 20,
                            font: pw.Font.helveticaBold()
                        )
                    ),
                  ]
              )
            )
          );
        }
    );
  }

  static getPropertyPage(Property property, c.Category category, Broker broker) {
    print(category.toJson());
    return pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
              padding: pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(
                  border: pw.Border.all(
                      color: PdfColor.fromHex("#"+(broker.color??"263238")),
                      width: 2
                  )
              ),
              child: pw.Container(
                  padding: pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                      border: pw.Border.all(
                          color: PdfColor.fromHex("#"+(broker.color??"263238")),
                          width: 1
                      )
                  ),
              child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text(
                        property.details?.projectName??"",
                        style: pw.TextStyle(
                            fontSize: 35,
                            font: pw.Font.helveticaBold()
                        )
                    ),
                    pw.SizedBox(
                        height: 30
                    ),
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          getLeftDetails(property, category, "#"+(broker.color??"263238")),
                          pw.SizedBox(
                              width: 10
                          ),
                          getRightDetails(property.amenities??[])
                        ]
                    )
                  ]
              )
            )
          ); // Center
        }
    );
  }

  static getLeftDetails(Property property, c.Category category, String color) {
    return pw.Flexible(
      flex: 1,
      fit: pw.FlexFit.tight,
      child: pw.Padding(
        padding: pw.EdgeInsets.only(right: 10),
        child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              getPDFText("Rate", (property.details?.rate??"")+"/-", color),
              pw.SizedBox(
                  height: 10
              ),
              getPDFText("Amount", Essential().getWrittenValue(double.parse(property.details?.amount??"0")), color),
              pw.SizedBox(
                  height: 10
              ),
              getPDFText("Area", property.details?.areaName??"", color),
              pw.SizedBox(
                  height: 10
              ),
              getPDFText("Property On", property.details?.purpose??"", color),
              pw.SizedBox(
                  height: 10
              ),
              getPDFText("Category", property.details?.categoryName??"", color),
              pw.SizedBox(
                  height: 10
              ),
              getPDFText("Super SqFt", property.details?.sqftSuper??"", color),
              pw.SizedBox(
                  height: 10
              ),
              getPDFText("Carpet SqFt", property.details?.sqftCarpet??"", color),
              pw.SizedBox(
                  height: 10
              ),
              getPDFText("Construction", property.details?.construction??"", color),
              pw.SizedBox(
                  height: 10
              ),
              getPDFText("Property Type", property.details?.saleType??"", color),
              pw.SizedBox(
                  height: 10
              ),
              getPDFText("Rera", property.details?.rera??"", color),
              pw.SizedBox(
                  height: 10
              ),
              if(category.bhk=="1")
                getRightInfo("BHK", property.details?.bhk??"", color),
              if(category.varr=="1")
                getRightInfo("Varr", property.details?.varr??"", color),
              if(category.vigha=="1")
                getRightInfo("Vigha", property.details?.vigha??"", color),
              if(category.size=="1")
                getRightInfo("Size", property.details?.size??"", color),
              if(category.floor=="1")
                getRightInfo("Floor", property.details?.floor??"", color),
              if(category.number=="1")
                getRightInfo("Number", property.details?.number??"", color),
              if(category.blockNumber=="1")
                getRightInfo("Block Number", property.details?.blockNumber??"", color),
              if(category.tPSurveyNo=="1")
                getRightInfo("TP Survey No", property.details?.tPSurveyNo??"", color),
              if(category.village=="1")
                getRightInfo("Village", property.details?.village??"", color),
              if(category.furnishedOrNot=="1")
                getRightInfo("Furnishing Status", property.details?.furnishedOrNot??"", color),
              if(category.condition=="1")
                getRightInfo("Condition", property.details?.condition??"", color),
              if(category.remarks=="1")
                getRightInfo("Remarks", property.details?.remarks??"", color),
            ]
        )
      )
    );
  }

  static getRightDetails(List<Amenity> amenities) {
    return pw.Flexible(
      flex: 1,
      fit: pw.FlexFit.tight,
      child: pw.Padding(
        padding: pw.EdgeInsets.only(right: 10),
        child: pw.ListView.builder(
          itemCount: amenities.length > 12 ? 12 : amenities.length,
          itemBuilder: (pw.Context context, int index) {
            return getAmenityInfo(amenities[index].amenity??"");
          },
        )
      )
    );
  }

  static getImages(netImage1, netImage2, Broker broker) {
    return pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
              padding: pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(
                  border: pw.Border.all(
                      color: PdfColor.fromHex("#"+(broker.color??"263238")),
                      width: 2
                  )
              ),
              child: pw.Container(
                  padding: pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                      border: pw.Border.all(
                          color: PdfColor.fromHex("#"+(broker.color??"263238")),
                          width: 1
                      )
                  ),
              child: pw.Column(
                  children: [
                    pw.Flexible(
                        flex: 1,
                        fit: pw.FlexFit.tight,
                        child: pw.Center(
                          child: pw.Image(netImage1),
                        )
                    ),
                    if(netImage2!=null)
                      pw.Flexible(
                          flex: 1,
                          fit: pw.FlexFit.tight,
                          child: pw.Center(
                            child: pw.Image(netImage2),
                          )
                      )

                  ]
              )
            )
          );
        }
    );
  }

  static getPDFText(String title, String info, String color) {
    return pw.RichText(
      text: pw.TextSpan(
        text: title+" : ",
        style: pw.TextStyle(
          fontSize: 16,
          font: pw.Font.helveticaBold(),
          color: PdfColor.fromHex(color)
        ),
        children: [
          pw.TextSpan(
              text: info,
              style: pw.TextStyle(
                  fontSize: 16,
                  font: pw.Font.helvetica(),
                  color: PdfColors.black
              ),
          ),
        ]
      ),
    );
  }

  static getRightInfo(String title, String info, String color) {
    return pw.Column(
      children: [
        getPDFText(title, info, color),
        pw.SizedBox(
            height: 10
        ),
      ]
    );
  }

  static getAmenityInfo(String title) {
    return pw.Column(
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 16,
            font: pw.Font.helveticaBold()
          ),
        ),
        pw.SizedBox(
            height: 10
        ),
      ]
    );
  }

  static getLastPage(Broker broker, pw.MemoryImage image, netImage) {
    return pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
              padding: pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(
                  border: pw.Border.all(
                      color: PdfColor.fromHex("#"+(broker.color??"263238")),
                      width: 2
                  )
              ),
              child: pw.Container(
                padding: pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                        color: PdfColor.fromHex("#"+(broker.color??"263238")),
                        width: 1
                    )
                ),
                child: pw.Center(
                  child: pw.Column(
                    children: [
                     pw.Flexible(
                       flex: 1,
                       fit: pw.FlexFit.tight,
                       child:  pw.Image(
                           netImage
                       ),
                     ),
                     pw.Flexible(
                       flex: 1,
                       fit: pw.FlexFit.tight,
                       child:  pw.Image(
                           image
                       ),
                     )
                    ]
                  )
                )
            )
          );
        }
    );
  }
}