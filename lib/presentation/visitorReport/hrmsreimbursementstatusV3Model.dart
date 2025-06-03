// class HrmsReimbursementStatusV3Model {
//   final String iVisitorId;
//   final String sVisitorName;
//   final String sCameFrom;
//   final String sUserName;
//   final String sPurposeVisitName;
//   final String iInTime;
//   final String sDayName;
//   final String sVisitorImage;
//
//   HrmsReimbursementStatusV3Model({
//     required this.iVisitorId,
//     required this.sVisitorName,
//     required this.sCameFrom,
//     required this.sUserName,
//     required this.sPurposeVisitName,
//     required this.iInTime,
//     required this.sDayName,
//     required this.sVisitorImage,
//   });
//
//   // Factory constructor to create an instance from JSON safely
//   factory HrmsReimbursementStatusV3Model.fromJson(Map<String, dynamic> json) {
//     return HrmsReimbursementStatusV3Model(
//       iVisitorId: json['iVisitorId']?.toString() ?? 'N/A',
//       sVisitorName: json['sVisitorName'] ?? 'Unknown',
//       sCameFrom: json['sCameFrom'] ?? 'N/A',
//       sUserName: json['sUserName'] ?? 'N/A',
//       sPurposeVisitName: json['sPurposeVisitName'] ?? 'N/A',
//       iInTime: json['iInTime'] ?? '00:00',
//       sDayName: json['sDayName'] ?? 'N/A',
//       sVisitorImage: json['sVisitorImage'] ?? 'N/A',
//     );
//   }
// }

class Hrmsreimbursementstatusv3model {
  final String iTranId;
  final String iVisitorId;
  final String sVisitorName;
  final String sCameFrom;
  final String sWhomToMeet;
  final String sUserName;
  final String sPurposeVisitName;
  final String iInTime;
  final String iOutTime;
  final String sDayName;
  final String sVisitorImage;
  final String DurationTime;
  final String iStatus;
  final String dEntryDate;


  Hrmsreimbursementstatusv3model({
    required this.iTranId,
    required this.iVisitorId,
    required this.sVisitorName,
    required this.sCameFrom,
    required this.sWhomToMeet,
    required this.sUserName,
    required this.sPurposeVisitName,
    required this.iInTime,
    required this.iOutTime,
    required this.sDayName,
    required this.sVisitorImage,
    required this.DurationTime,
    required this.iStatus,
    required this.dEntryDate,

  });
  // Factory constructor to create an instance from JSON
  factory Hrmsreimbursementstatusv3model.fromJson(Map<String,dynamic> json) {
    return Hrmsreimbursementstatusv3model(
        iTranId: json['iTranId'].toString() ?? "",
        iVisitorId: json['iVisitorId'].toString() ?? "",
        sVisitorName: json['sVisitorName'] ?? "",
        sCameFrom: json['sCameFrom'] ?? "",
        sWhomToMeet: json['sWhomToMeet'] ?? "",
        sUserName: json['sUserName'] ?? "",
        sPurposeVisitName: json['sPurposeVisitName'] ?? "",
        iInTime: json['iInTime'] ?? "",
        iOutTime: json['iOutTime'] ?? "",
        sDayName: json['sDayName'] ?? "",
        sVisitorImage: json['sVisitorImage'] ?? "",
        DurationTime: json['DurationTime'] ?? "",
        iStatus:json['iStatus'].toString() ?? "",
        dEntryDate: json['dEntryDate']?? ""

    );
  }
}
