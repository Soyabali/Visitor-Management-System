import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:puri/app/generalFunction.dart';
import '../../../resources/app_text_style.dart';


class FireEmergency extends StatefulWidget {

  final name;
  const FireEmergency({super.key, required this.name});

  @override
  State<FireEmergency> createState() => _TemplesHomeState();
}

class _TemplesHomeState extends State<FireEmergency> {
  // GeneralFunction? generalFunction;
  GeneralFunction generalFunction = GeneralFunction();

  final List<Map<String, String>> itemList = [
    {'image': 'https://www.drishtiias.com/images/uploads/1698053713_image1.png','temple': 'Fire Helpline'},
    {'image': 'https://s3.ap-southeast-1.amazonaws.com/images.deccanchronicle.com/dc-Cover-hinohp2v89f6sovfrqk7d6bfj7-20231002122234.Medi.jpeg','temple': 'Control Room'},
    {'image': 'https://images.indianexpress.com/2021/08/Puri-temple-1.jpeg','temple': 'Shri Debendra Kumar Swin'},
    {'image': 'https://t4.ftcdn.net/jpg/03/57/53/11/360_F_357531159_cumH01clbXOo32Ytvkb7qGYspCJjj4gB.jpg','temple': 'Dy. Fire Officr'},
    {'image': 'https://w0.peakpx.com/wallpaper/672/441/HD-wallpaper-puri-jagannath-temple-cloud.jpg','temple': 'Shri Parthasarathi Sahoo'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: getAppBarBack("${widget.name}'"),
        drawer:
        generalFunction.drawerFunction(context, 'Suaib Ali', '9871950881'),
        // appBar
        body: ListView(
            children: <Widget>[
              middleHeader(context,'${widget.name}'),
              // Image.asset('assets/images/templelement2.png',
              //     // Replace with your first image path
              //     height: 30.0,
              //     width: MediaQuery.of(context).size.width),
             // SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 5,right: 5,bottom: 10),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                    itemCount: itemList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        // padding: EdgeInsets.only(left: 5,right: 5),
                        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                        child: Container(
                          decoration: BoxDecoration(
                            //color: Colors.red,
                            border: Border.all(
                              color: Colors.orange, // Set the golden border color
                              width: 1.0, // Set the width of the border
                            ),
                          ),
                          child: InkWell(
                            onTap: (){
                              var templeName = "${itemList[index]['temple']}";
                              var image  =  "${itemList[index]['image']}";
                              print('-----165---$templeName');
                              print('-----166---$image');
                              // navigator
                              // Navigator.of(context).push(MaterialPageRoute(builder: (_) => TemplesDetail(
                              //     templeName:templeName,image:image)));
                            },

                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Container(
                                    height: 90,
                                    width: 90,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5.0),
                                        child: Image.network('${itemList[index]['image']}',height: 90,width: 90, fit: BoxFit.cover,)),

                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 110,
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 20),
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('${itemList[index]['temple']}',style: AppTextStyle.font14penSansExtraboldRedTextStyle),
                                            SizedBox(height: 5),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text('Designation :',style: AppTextStyle.font14penSansExtraboldRedTextStyle),
                                                SizedBox(width: 5),
                                                Text('Fire Helpline',
                                                    style:AppTextStyle.font10penSansExtraboldBlack45TextStyle),
                                              ],
                                            ),
                                            SizedBox(height: 5),
                                            Text('05652565565',style: AppTextStyle.font14penSansExtraboldBlack45TextStyle),



                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),

                                      ),
                                      child: Image.asset('assets/images/callicon.png',
                                        height: 12,
                                        width: 12,
                                      )

                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Image.asset(
                                          "assets/images/listelementtop.png",
                                          height: 25,
                                          width: 25,
                                        ),
                                      ),
                                      SizedBox(height: 35),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Image.asset(
                                          "assets/images/listelementbottom.png",
                                          height: 25,
                                          width: 25,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            ]
        )
      // ],
    );
  }
}
