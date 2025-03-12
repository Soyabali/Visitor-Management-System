class Hrmsreimbursementstatusv3model {
  final String iVisitorId;
  final String sVisitorName;
  final String sCameFrom;
  final String sUserName;
  final String sPurposeVisitName;
  final String iInTime;
  final String sDayName;
  final String sVisitorImage;


  Hrmsreimbursementstatusv3model({
    required this.iVisitorId,
    required this.sVisitorName,
    required this.sCameFrom,
    required this.sUserName,
    required this.sPurposeVisitName,
    required this.iInTime,
    required this.sDayName,
    required this.sVisitorImage,
  });

  // Factory constructor to create an instance from JSON
  factory Hrmsreimbursementstatusv3model.fromJson(Map<String,dynamic> json) {
    return Hrmsreimbursementstatusv3model(
        iVisitorId: json['iVisitorId'],
        sVisitorName: json['sVisitorName'],
        sCameFrom: json['sCameFrom'],
        sUserName: json['sUserName'],
        sPurposeVisitName: json['sPurposeVisitName'],
        iInTime: json['iInTime'],
        sDayName: json['sDayName'],
        sVisitorImage: json['sVisitorImage'],

    );
  }
}
