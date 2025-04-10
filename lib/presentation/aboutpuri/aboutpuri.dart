
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../app/generalFunction.dart';
import '../resources/app_text_style.dart';
import '../resources/custom_elevated_button.dart';
import '../temples/temple_gallery.dart';


class AboutPuri extends StatefulWidget {

   String name;
  AboutPuri({super.key, required this.name});
  @override
  State<AboutPuri> createState() => _TemplesHomeState();
}

class _TemplesHomeState extends State<AboutPuri> {

  GeneralFunction generalFunction = GeneralFunction();

  @override
  void initState() {
    super.initState();
    //BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
   // BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  // bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
  //   NavigationUtils.onWillPop(context);
  //   return true;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getAppBarBack(context,"${widget.name}"),
      drawer:
      generalFunction.drawerFunction(context, 'Suaib Ali', '9871950881'),
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: Image.network('https://www.drishtiias.com/images/uploads/1698053713_image1.png', fit: BoxFit.cover),
              ),
              Positioned(
                top: 155,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 35,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      // Background color of the container
                      borderRadius: BorderRadius.circular(17.0),
                      // Circular border radius
                      border: Border.all(
                        color: Colors.yellow, // Border color
                        width: 0.5, // Border width
                      ),
                    ),
                    child: CustomElevatedButton(
                      text: 'VIEW GALLERY',
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => TempleGallery(templeName:'Puri City')));
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),

          middleHeaderPuri(context,'Puri City'),

          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
               // scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 5,right: 5,bottom: 5,top:10),
                      child: Text(
                        '''Puri has been known by several names since ancient times, and was locally known as "Sri Kshetra" and the Jagannath temple is known as "Badadeula". Puri and the Jagannath Temple were invaded 18 times by Muslim rulers, from the 7th century AD until the early 19th century with the objective of looting the treasures of the temple. Odisha, including Puri and its temple, were part of British India from 1803 until India attained independence in August 1947. Even though princely states do not exist in India today, the heirs of the House of Gajapati still perform the ritual duties of the temple. The temple town has many Hindu religious mathas or monasteries.''',
                        style: AppTextStyle.font14penSansExtraboldBlack45TextStyle,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
