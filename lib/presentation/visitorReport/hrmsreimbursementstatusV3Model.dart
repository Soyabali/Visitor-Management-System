class Hrmsreimbursementstatusv3model {
  final String sTranCode;
  final String sEmpCode;
  final String sProjectName;
  final String sExpHeadName;
  final String dEntryAt;
  final String fAmount;
  final String sExpDetails;
  final String sExpBillPhoto;
  final String sExpBillPhoto2;
  final String sExpBillPhoto3;
  final String sExpBillPhoto4;
  final String sStatusName;
  final String sEmpName;
  final String sRemarks;
  final String dRemarksAt;
  final String sProjectCode;
  final String sExpHeadCode;
  final String dExpDate;
  final String iStatus;

  Hrmsreimbursementstatusv3model({
    required this.sTranCode,
    required this.sEmpCode,
    required this.sProjectName,
    required this.sExpHeadName,
    required this.dEntryAt,
    required this.fAmount,
    required this.sExpDetails,
    required this.sExpBillPhoto,
    required this.sExpBillPhoto2,
    required this.sExpBillPhoto3,
    required this.sExpBillPhoto4,
    required this.sStatusName,
    required this.sEmpName,
    required this.sRemarks,
    required this.dRemarksAt,
    required this.sProjectCode,
    required this.sExpHeadCode,
    required this.dExpDate,
    required this.iStatus,
  });

  // Factory constructor to create an instance from JSON
  factory Hrmsreimbursementstatusv3model.fromJson(Map<String,dynamic> json) {
    return Hrmsreimbursementstatusv3model(
      sTranCode: json['sTranCode'],
      sEmpCode: json['sEmpCode'],
      sProjectName: json['sProjectName'],
      sExpHeadName: json['sExpHeadName'],
      dEntryAt: json['dEntryAt'],
      fAmount: json['fAmount'],
      sExpDetails: json['sExpDetails'],
      sExpBillPhoto: json['sExpBillPhoto'],
      sExpBillPhoto2: json['sExpBillPhoto2'],
      sExpBillPhoto3: json['sExpBillPhoto3'],
      sExpBillPhoto4: json['sExpBillPhoto4'],
      sStatusName: json['sStatusName'],
      sEmpName: json['sEmpName'],
      sRemarks: json['sRemarks'],
      dRemarksAt: json['dRemarksAt'],
      sProjectCode: json['sProjectCode'],
      sExpHeadCode: json['sExpHeadCode'],
      dExpDate: json['dExpDate'],
      iStatus:json['iStatus']
    );
  }
}
