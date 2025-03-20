class GetVisitorListModel {
  final String iTranId;
  final String iVisitorId;
  final String sVisitorName;
  final String sCameFrom;
  final String sWhomToMeet;
  final String sPurposeVisitName;
  final String iInTime;
  final String sDayName;
  final String sVisitorImage;
  final String dEntryDate;

  GetVisitorListModel({
    required this.iTranId,
    required this.iVisitorId,
    required this.sVisitorName,
    required this.sCameFrom,
    required this.sWhomToMeet,
    required this.sPurposeVisitName,
    required this.iInTime,
    required this.sDayName,
    required this.sVisitorImage,
    required this.dEntryDate

  });

  // Factory constructor to create an instance from JSON
  factory GetVisitorListModel.fromJson(Map<String,dynamic> json) {
    return GetVisitorListModel(
        iTranId: json['iTranId'].toString() ?? "",
        iVisitorId: json['iVisitorId'].toString() ?? "",
        sVisitorName: json['sVisitorName'] ?? "",
        sCameFrom: json['sCameFrom'] ?? "",
        sWhomToMeet: json['sWhomToMeet'] ?? "",
        sPurposeVisitName: json['sPurposeVisitName'] ?? "",
        iInTime: json['iInTime'] ?? "",
        sDayName: json['sDayName'] ?? "",
        sVisitorImage: json['sVisitorImage'] ?? "",
        dEntryDate: json['dEntryDate'] ?? "",

    );
  }
}
