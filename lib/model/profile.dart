class Profile {
  String code;
  String engName;
  String orgCode;
  String orgName;
  String sSID;
  String thaiName;
  String workPlace;
  String password;

  Profile(
      {this.code,
      this.engName,
      this.orgCode,
      this.orgName,
      this.sSID,
      this.thaiName,
      this.workPlace,
      this.password});

  Profile.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    engName = json['EngName'];
    orgCode = json['OrgCode'];
    orgName = json['OrgName'];
    sSID = json['SSID'];
    thaiName = json['ThaiName'];
    workPlace = json['WorkPlace'];
    password = json['Password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['EngName'] = this.engName;
    data['OrgCode'] = this.orgCode;
    data['OrgName'] = this.orgName;
    data['SSID'] = this.sSID;
    data['ThaiName'] = this.thaiName;
    data['WorkPlace'] = this.workPlace;
    data['Password'] = this.password;
    return data;
  }
}

class Year50tv {
  String createDate;
  String createYear;
  String empImport;
  String item;
  String address;
  String bahtText;
  String cardID;
  String dept;
  String empID;
  String fName;
  String lName;
  String location;
  String pFYTD;
  String pay1;
  String pay2;
  String payTotal;
  String prefix;
  String proFund;
  String reason;
  String sSID;
  String section;
  String tax1;
  String tax2;
  String taxTotal;
  String taxYear;
  String taxID;
  Year50tv(
      {this.createDate,
      this.createYear,
      this.empImport,
      this.item,
      this.address,
      this.bahtText,
      this.cardID,
      this.dept,
      this.empID,
      this.fName,
      this.lName,
      this.location,
      this.pFYTD,
      this.pay1,
      this.pay2,
      this.payTotal,
      this.prefix,
      this.proFund,
      this.reason,
      this.sSID,
      this.section,
      this.tax1,
      this.tax2,
      this.taxTotal,
      this.taxYear,
      this.taxID});

  Year50tv.fromJson(Map<String, dynamic> json) {
    createDate = json['CreateDate'];
    createYear = json['CreateYear'];
    empImport = json['EmpImport'];
    item = json['Item'];
    address = json['Address'];
    bahtText = json['BahtText'];
    cardID = json['CardID'];
    dept = json['Dept'];
    empID = json['EmpID'];
    fName = json['FName'];
    lName = json['LName'];
    location = json['Location'];
    pFYTD = json['PFYTD'];
    pay1 = json['Pay1'];
    pay2 = json['Pay2'];
    payTotal = json['PayTotal'];
    prefix = json['Prefix'];
    proFund = json['ProFund'];
    reason = json['Reason'];
    sSID = json['SSID'];
    section = json['Section'];
    tax1 = json['Tax1'];
    tax2 = json['Tax2'];
    taxTotal = json['TaxTotal'];
    taxYear = json['TaxYear'];
    taxID = json['TaxID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CreateDate'] = this.createDate;
    data['CreateYear'] = this.createYear;
    data['EmpImport'] = this.empImport;
    data['Item'] = this.item;
    data['Address'] = this.address;
    data['BahtText'] = this.bahtText;
    data['CardID'] = this.cardID;
    data['Dept'] = this.dept;
    data['EmpID'] = this.empID;
    data['FName'] = this.fName;
    data['LName'] = this.lName;
    data['Location'] = this.location;
    data['PFYTD'] = this.pFYTD;
    data['Pay1'] = this.pay1;
    data['Pay2'] = this.pay2;
    data['PayTotal'] = this.payTotal;
    data['Prefix'] = this.prefix;
    data['ProFund'] = this.proFund;
    data['Reason'] = this.reason;
    data['SSID'] = this.sSID;
    data['Section'] = this.section;
    data['Tax1'] = this.tax1;
    data['Tax2'] = this.tax2;
    data['TaxTotal'] = this.taxTotal;
    data['TaxYear'] = this.taxYear;
    data['TaxID'] = this.taxID;
    return data;
  }
}

class HistoryDataList {
  String offmonth;
  String offmonthName;
  String monthinis;
  String offyear;
  String dateOff;
  String code;
  String netIncome;

  HistoryDataList(
      {this.offmonth,
      this.offmonthName,
      this.monthinis,
      this.offyear,
      this.dateOff,
      this.code,
      this.netIncome});

  HistoryDataList.fromJson(Map<String, dynamic> json) {
    offmonth = json['offmonth'];
    offmonthName = json['offmonthName'];
    monthinis = json['monthinis'];
    offyear = json['offyear'];
    dateOff = json['DateOff'];
    code = json['code'];
    netIncome = json['NetIncome'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['offmonth'] = this.offmonth;
    data['offmonthName'] = this.offmonthName;
    data['monthinis'] = this.monthinis;
    data['offyear'] = this.offyear;
    data['DateOff'] = this.dateOff;
    data['code'] = this.code;
    data['NetIncome'] = this.netIncome;
    return data;
  }
}
