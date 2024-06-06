
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:puri/complaints/raiseGrievance/onlineComplaint.dart';
import '../app/generalFunction.dart';
import '../presentation/aboutpuri/aboutpuri.dart';
import '../presentation/birth_death/birthanddeath.dart';
import '../presentation/bookAdvertisement/bookAdvertisement.dart';
import '../presentation/emergencyContact/emergencyContact.dart';
import '../presentation/eventsAndNewsletter/eventsAndNewsletter.dart';
import '../presentation/knowyourward/KnowYourWard.dart';
import '../presentation/marriageCertificate/marriageCertificate.dart';
import '../presentation/parklocator/parklocator.dart';
import '../resources/app_text_style.dart';
import 'grievanceStatus/grievanceStatus.dart';


class ComplaintHomePage extends StatefulWidget {
  const ComplaintHomePage({super.key});

  @override
  State<ComplaintHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ComplaintHomePage> {
  GeneralFunction generalFunction = GeneralFunction();

  Future<bool> _onWillPop() async {
    // Show a confirmation dialog
    final shouldPop = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('Do you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Yes'),
          ),
        ],
      ),
    );
    return shouldPop ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getAppBarBack("Complaints"),
      drawer:
          generalFunction.drawerFunction(context, 'Suaib Ali', '9871950881'),
      body: Stack(
        fit: StackFit.expand, // Make the stack fill the entire screen
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(Icons.invert_colors_on_sharp, size: 20),
              SizedBox(width: 5),
              Text('Functional Activities',
                  style: AppTextStyle.font16penSansExtraboldBlack45TextStyle)
            ],
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 25, left: 10, right: 10, bottom: 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          // Add your onTap functionality here
                          print('-----52------');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    OnlineComplaint(name: "Raise Grievance")),
                          );
                        },
                        child: Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width / 2 - 14,
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Colors.green,
                                // Specify your desired border color here
                                width: 5.0, // Adjust the width of the border
                              ),
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              // Adjust the radius for the top-left corner
                              bottomLeft: Radius.circular(
                                  10.0), // Adjust the radius for the bottom-left corner
                            ),
                          ),
                          // color: Colors.black,
                          child: Card(
                              elevation: 10,
                              margin: EdgeInsets.all(5.0),
                              shadowColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                side:
                                    BorderSide(color: Colors.green, width: 0.5),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        // half of width and height for a circle
                                        //color: Colors.green
                                        color: Color(0xFFD3D3D3),
                                      ),
                                      child: Center(
                                          child: Image(
                                        image: AssetImage(
                                            'assets/images/complaint_status.png'),
                                        width: 30,
                                        height: 30,
                                      )),
                                    ),
                                    Text(
                                      'Raise Grievance',
                                      style: AppTextStyle
                                          .font14penSansExtraboldGreenTextStyle,
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ),
                      SizedBox(width: 5),
                      InkWell(
                        onTap: () {
                          // Add your onTap functionality here
                          print('-----109------');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    GrievanceStatus(name: "Grievance Status")),
                          );
                        },
                        child: Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width / 2 - 14,
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: Colors.orange,
                                // Specify your desired border color here
                                width: 5.0, // Adjust the width of the border
                              ),
                            ),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              // Adjust the radius for the top-left corner
                              bottomRight: Radius.circular(
                                  10.0), // Adjust the radius for the bottom-left corner
                            ),
                          ),
                          // color: Colors.black,
                          child: Card(
                              elevation: 10,
                              shadowColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.orange, width: 0.5),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        // half of width and height for a circle
                                        //color: Colors.green
                                        color: Color(0xFFD3D3D3),
                                      ),
                                      child: const Center(
                                          child: Image(
                                        image: AssetImage(
                                            'assets/images/complaint_status.png'),
                                        width: 30,
                                        height: 30,
                                      )),
                                    ),
                                    Text(
                                      'Grievance Status',
                                      style: AppTextStyle
                                          .font14penSansExtraboldOrangeTextStyle,
                                      // style: GoogleFonts.lato(
                                      //     textStyle: Theme.of(context).textTheme.titleSmall,
                                      //     fontSize: 14,
                                      //     fontWeight: FontWeight.w700,
                                      //     fontStyle: FontStyle.italic,
                                      //     color:Colors.orange
                                      // ),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          // BookAdvertisement
                          // Add your onTap functionality here
                          print('-----177------');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BookAdvertisement(
                                    complaintName: "Book Advertisement")),
                          );
                        },
                        child: Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width / 2 - 14,
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Colors.orange,
                                // Specify your desired border color here
                                width: 5.0, // Adjust the width of the border
                              ),
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              // Adjust the radius for the top-left corner
                              bottomLeft: Radius.circular(
                                  10.0), // Adjust the radius for the bottom-left corner
                            ),
                          ),
                          // color: Colors.black,
                          child: Card(
                              elevation: 10,
                              margin: EdgeInsets.all(5.0),
                              shadowColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.orange, width: 0.5),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        // half of width and height for a circle
                                        //color: Colors.green
                                        color: Color(0xFFD3D3D3),
                                      ),
                                      child: const Center(
                                          child: Image(
                                        image: AssetImage(
                                            'assets/images/complaint_status.png'),
                                        width: 30,
                                        height: 30,
                                      )),
                                    ),
                                    Text(
                                      'Book Advertisement',
                                      style: AppTextStyle
                                          .font14penSansExtraboldOrangeTextStyle,
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ),
                      SizedBox(width: 5),
                      InkWell(
                        onTap: () {
                          // Add your onTap functionality here
                          print('-----235------');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => KnowYourWard(
                                    name: "Know Your Ward")),
                          );
                        },
                        child: Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width / 2 - 14,
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: Colors.green,
                                // Specify your desired border color here
                                width: 5.0, // Adjust the width of the border
                              ),
                            ),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              // Adjust the radius for the top-left corner
                              bottomRight: Radius.circular(
                                  10.0), // Adjust the radius for the bottom-left corner
                            ),
                          ),
                          // color: Colors.black,
                          child: Card(
                              elevation: 10,
                              shadowColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                side:
                                    BorderSide(color: Colors.green, width: 0.5),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        // half of width and height for a circle
                                        //color: Colors.green
                                        color: Color(0xFFD3D3D3),
                                      ),
                                      child: const Center(
                                          child: Image(
                                        image: AssetImage(
                                            'assets/images/complaint_status.png'),
                                        width: 30,
                                        height: 30,
                                      )),
                                    ),
                                    Text(
                                      'Know Your Ward',
                                      style: AppTextStyle
                                          .font14penSansExtraboldGreenTextStyle,
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MarriageCertificate(
                                    name: "Marriage Certificate")),
                          );
                        },
                        child: Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width / 2 - 14,
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Colors.green,
                                // Specify your desired border color here
                                width: 5.0, // Adjust the width of the border
                              ),
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              // Adjust the radius for the top-left corner
                              bottomLeft: Radius.circular(
                                  10.0), // Adjust the radius for the bottom-left corner
                            ),
                          ),
                          // color: Colors.black,
                          child: Card(
                              elevation: 10,
                              margin: EdgeInsets.all(5.0),
                              shadowColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                side:
                                    BorderSide(color: Colors.green, width: 0.5),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        // half of width and height for a circle
                                        //color: Colors.green
                                        color: Color(0xFFD3D3D3),
                                      ),
                                      child: Center(
                                          child: Image(
                                        image: AssetImage(
                                            'assets/images/complaint_status.png'),
                                        width: 30,
                                        height: 30,
                                      )),
                                    ),
                                    Text(
                                      'Marriage Certificate',
                                      style: AppTextStyle
                                          .font14penSansExtraboldGreenTextStyle,
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ),
                      SizedBox(width: 5),
                      InkWell(
                        onTap: () {
                          // Add your onTap functionality here
                          //print('-----353------');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BirthAndDeathCertificate(
                                    name: "Birth & Death Cert")),
                          );

                        },
                        child: Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width / 2 - 14,
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: Colors.orange,
                                // Specify your desired border color here
                                width: 5.0, // Adjust the width of the border
                              ),
                            ),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              // Adjust the radius for the top-left corner
                              bottomRight: Radius.circular(
                                  10.0), // Adjust the radius for the bottom-left corner
                            ),
                          ),
                          // color: Colors.black,
                          child: Card(
                              elevation: 10,
                              shadowColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.orange, width: 0.5),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        // half of width and height for a circle
                                        //color: Colors.green
                                        color: Color(0xFFD3D3D3),
                                      ),
                                      child: Center(
                                          child: Image(
                                        image: AssetImage(
                                            'assets/images/complaint_status.png'),
                                        width: 30,
                                        height: 30,
                                      )),
                                    ),
                                    Text(
                                      'Birth & Death Cert',
                                      style: AppTextStyle
                                          .font14penSansExtraboldOrangeTextStyle,
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          // Add your onTap functionality here
                          // ParkLocator
                          print('-----414------');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ParkLocator(
                                    name: "Park Locator'")),
                          );
                        },
                        child: Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width / 2 - 14,
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Colors.orange,
                                // Specify your desired border color here
                                width: 5.0, // Adjust the width of the border
                              ),
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              // Adjust the radius for the top-left corner
                              bottomLeft: Radius.circular(
                                  10.0), // Adjust the radius for the bottom-left corner
                            ),
                          ),
                          // color: Colors.black,
                          child: Card(
                              elevation: 10,
                              margin: EdgeInsets.all(5.0),
                              shadowColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.orange, width: 0.5),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        // half of width and height for a circle
                                        //color: Colors.green
                                        color: Color(0xFFD3D3D3),
                                      ),
                                      child: const Center(
                                          child: Image(
                                        image: AssetImage(
                                            'assets/images/complaint_status.png'),
                                        width: 30,
                                        height: 30,
                                      )),
                                    ),
                                    Text('Park Locator',
                                        style: AppTextStyle
                                            .font14penSansExtraboldOrangeTextStyle),
                                  ],
                                ),
                              )),
                        ),
                      ),
                      SizedBox(width: 5),
                      InkWell(
                        onTap: () {
                          // Add your onTap functionality here
                          print('-----470------');
                          // EmergencyContacts
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EmergencyContacts(
                                    name: "Emergency Contacts")),
                          );

                        },
                        child: Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width / 2 - 14,
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: Colors.green,
                                // Specify your desired border color here
                                width: 5.0, // Adjust the width of the border
                              ),
                            ),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              // Adjust the radius for the top-left corner
                              bottomRight: Radius.circular(
                                  10.0), // Adjust the radius for the bottom-left corner
                            ),
                          ),
                          // color: Colors.black,
                          child: Card(
                              elevation: 10,
                              shadowColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                side:
                                    BorderSide(color: Colors.green, width: 0.5),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        // half of width and height for a circle
                                        //color: Colors.green
                                        color: Color(0xFFD3D3D3),
                                      ),
                                      child: const Center(
                                          child: Image(
                                        image: AssetImage(
                                            'assets/images/complaint_status.png'),
                                        width: 30,
                                        height: 30,
                                      )),
                                    ),
                                    Text('Emergency Contacts',
                                        style: AppTextStyle
                                            .font14penSansExtraboldGreenTextStyle),
                                  ],
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          // Add your onTap functionality here
                          print('-----530------');

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EventsAndNewSletter(
                                    name: "Events / Newsletter")),
                          );

                        },
                        child: Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width / 2 - 14,
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Colors.green,
                                // Specify your desired border color here
                                width: 5.0, // Adjust the width of the border
                              ),
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              // Adjust the radius for the top-left corner
                              bottomLeft: Radius.circular(
                                  10.0), // Adjust the radius for the bottom-left corner
                            ),
                          ),
                          // color: Colors.black,
                          child: Card(
                              elevation: 10,
                              margin: EdgeInsets.all(5.0),
                              shadowColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                side:
                                    BorderSide(color: Colors.green, width: 0.5),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        // half of width and height for a circle
                                        //color: Colors.green
                                        color: Color(0xFFD3D3D3),
                                      ),
                                      child: const Center(
                                          child: Image(
                                        image: AssetImage(
                                            'assets/images/complaint_status.png'),
                                        width: 30,
                                        height: 30,
                                      )),
                                    ),
                                    Text('Events / Newsletter',
                                        style: AppTextStyle
                                            .font14penSansExtraboldGreenTextStyle),
                                  ],
                                ),
                              )),
                        ),
                      ),
                      SizedBox(width: 5),
                      InkWell(
                        onTap: () {
                          // Add your onTap functionality here
                          //print('-----586------');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AboutPuri()),
                          );
                        },
                        child: Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width / 2 - 14,
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: Colors.orange,
                                // Specify your desired border color here
                                width: 5.0, // Adjust the width of the border
                              ),
                            ),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              // Adjust the radius for the top-left corner
                              bottomRight: Radius.circular(
                                  10.0), // Adjust the radius for the bottom-left corner
                            ),
                          ),
                          // color: Colors.black,
                          child: Card(
                              elevation: 10,
                              shadowColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: Colors.orange, width: 0.5),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        // half of width and height for a circle
                                        //color: Colors.green
                                        color: Color(0xFFD3D3D3),
                                      ),
                                      child: const Center(
                                          child: Image(
                                        image: AssetImage(
                                            'assets/images/complaint_status.png'),
                                        width: 30,
                                        height: 30,
                                      )),
                                    ),
                                    Text('About Puri',
                                        style: AppTextStyle
                                            .font14penSansExtraboldOrangeTextStyle),
                                  ],
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
