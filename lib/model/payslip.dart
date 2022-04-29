class Payslipinfo {
  String offmonth;
  String offmonthName;
  String monthinis;
  String offyear;
  String dateOff;
  String userIM;
  String code;
  String thaiName;
  String engName;
  String bankAccount;
  String advance;
  String allowance;
  String appCrem;
  String appCoopSAMCO;
  String backPay;
  String blank01;
  String blank02;
  String blank03;
  String blank04;
  String blank05;
  String blank06;
  String blank07;
  String blank08;
  String blank09;
  String blank10;
  String card;
  String childEdu;
  String childNotEdu;
  String cola;
  String compenTax;
  String coop1SAMCO;
  String coop1SCB;
  String coop2SAMCO;
  String coop2SCB;
  String coopDebtAdd;
  String coopSamco;
  String crem;
  String cremSAMCO;
  String damageFee;
  String diligent;
  String donate;
  String empPF;
  String empSS;
  String extra1;
  String extra2;
  String form;
  String incOther1;
  String incOther2;
  String incOther3;
  String incomeYTD;
  String insurance;
  String insuranceDeves;
  String jLDesc;
  String lawComp;
  String legalDpt;
  String netIncome;
  String noDays;
  String oT1;
  String oT2;
  String oT3;
  String oT15;
  String oT15S;
  String oTDF;
  String oTHD;
  String orgCode;
  String orgName;
  String other3;
  String other4;
  String outtime;
  String pFYTD;
  String payDate;
  String returnReward;
  String returnWage;
  String reward;
  String risk;
  String sLF;
  String sSYTD;
  String sSID;
  String sUN;
  String salary;
  String salaryDeduc;
  String tax;
  String taxYTD;
  String taxPayType;
  String taxN;
  String telephone;
  String totalDed;
  String totalInc;
  String training;
  String wage;
  String wageOther;
  String welfare;
  String workPlace;
  String depart;

  Payslipinfo(
      {this.offmonth,
      this.offmonthName,
      this.monthinis,
      this.offyear,
      this.dateOff,
      this.userIM,
      this.code,
      this.thaiName,
      this.engName,
      this.bankAccount,
      this.advance,
      this.allowance,
      this.appCrem,
      this.appCoopSAMCO,
      this.backPay,
      this.blank01,
      this.blank02,
      this.blank03,
      this.blank04,
      this.blank05,
      this.blank06,
      this.blank07,
      this.blank08,
      this.blank09,
      this.blank10,
      this.card,
      this.childEdu,
      this.childNotEdu,
      this.cola,
      this.compenTax,
      this.coop1SAMCO,
      this.coop1SCB,
      this.coop2SAMCO,
      this.coop2SCB,
      this.coopDebtAdd,
      this.coopSamco,
      this.crem,
      this.cremSAMCO,
      this.damageFee,
      this.diligent,
      this.donate,
      this.empPF,
      this.empSS,
      this.extra1,
      this.extra2,
      this.form,
      this.incOther1,
      this.incOther2,
      this.incOther3,
      this.incomeYTD,
      this.insurance,
      this.insuranceDeves,
      this.jLDesc,
      this.lawComp,
      this.legalDpt,
      this.netIncome,
      this.noDays,
      this.oT1,
      this.oT2,
      this.oT3,
      this.oT15,
      this.oT15S,
      this.oTDF,
      this.oTHD,
      this.orgCode,
      this.orgName,
      this.other3,
      this.other4,
      this.outtime,
      this.pFYTD,
      this.payDate,
      this.returnReward,
      this.returnWage,
      this.reward,
      this.risk,
      this.sLF,
      this.sSYTD,
      this.sSID,
      this.sUN,
      this.salary,
      this.salaryDeduc,
      this.tax,
      this.taxYTD,
      this.taxPayType,
      this.taxN,
      this.telephone,
      this.totalDed,
      this.totalInc,
      this.training,
      this.wage,
      this.wageOther,
      this.welfare,
      this.workPlace,
      this.depart});

  Payslipinfo.fromJson(Map<String, dynamic> json) {
    offmonth = json['offmonth'];
    offmonthName = json['offmonthName'];
    monthinis = json['monthinis'];
    offyear = json['offyear'];
    dateOff = json['DateOff'];
    userIM = json['userIM'];
    code = json['code'];
    thaiName = json['ThaiName'];
    engName = json['EngName'];
    bankAccount = json['BankAccount'];
    advance = json['Advance'];
    allowance = json['Allowance'];
    appCrem = json['AppCrem'];
    appCoopSAMCO = json['App_Coop_SAMCO'];
    backPay = json['BackPay'];
    blank01 = json['Blank01'];
    blank02 = json['Blank02'];
    blank03 = json['Blank03'];
    blank04 = json['Blank04'];
    blank05 = json['Blank05'];
    blank06 = json['Blank06'];
    blank07 = json['Blank07'];
    blank08 = json['Blank08'];
    blank09 = json['Blank09'];
    blank10 = json['Blank10'];
    card = json['Card'];
    childEdu = json['ChildEdu'];
    childNotEdu = json['ChildNotEdu'];
    cola = json['Cola'];
    compenTax = json['CompenTax'];
    coop1SAMCO = json['Coop1_SAMCO'];
    coop1SCB = json['Coop1_SCB'];
    coop2SAMCO = json['Coop2_SAMCO'];
    coop2SCB = json['Coop2_SCB'];
    coopDebtAdd = json['CoopDebtAdd'];
    coopSamco = json['CoopSamco'];
    crem = json['Crem'];
    cremSAMCO = json['Crem_SAMCO'];
    damageFee = json['DamageFee'];
    diligent = json['Diligent'];
    donate = json['Donate'];
    empPF = json['Emp_PF'];
    empSS = json['Emp_SS'];
    extra1 = json['Extra1'];
    extra2 = json['Extra2'];
    form = json['Form'];
    incOther1 = json['IncOther1'];
    incOther2 = json['IncOther2'];
    incOther3 = json['IncOther3'];
    incomeYTD = json['IncomeYTD'];
    insurance = json['Insurance'];
    insuranceDeves = json['InsuranceDeves'];
    jLDesc = json['JLDesc'];
    lawComp = json['Law_Comp'];
    legalDpt = json['LegalDpt'];
    netIncome = json['NetIncome'];
    noDays = json['NoDays'];
    oT1 = json['OT1'];
    oT2 = json['OT2'];
    oT3 = json['OT3'];
    oT15 = json['OT15'];
    oT15S = json['OT15S'];
    oTDF = json['OT_DF'];
    oTHD = json['OT_HD'];
    orgCode = json['OrgCode'];
    orgName = json['OrgName'];
    other3 = json['Other3'];
    other4 = json['Other4'];
    outtime = json['Outtime'];
    pFYTD = json['PFYTD'];
    payDate = json['PayDate'];
    returnReward = json['Return_Reward'];
    returnWage = json['Return_Wage'];
    reward = json['Reward'];
    risk = json['Risk'];
    sLF = json['SLF'];
    sSYTD = json['SSYTD'];
    sSID = json['SSID'];
    sUN = json['SUN'];
    salary = json['Salary'];
    salaryDeduc = json['SalaryDeduc'];
    tax = json['Tax'];
    taxYTD = json['TaxYTD'];
    taxPayType = json['TaxPayType'];
    taxN = json['Tax_N'];
    telephone = json['Telephone'];
    totalDed = json['TotalDed'];
    totalInc = json['TotalInc'];
    training = json['Training'];
    wage = json['Wage'];
    wageOther = json['Wage_other'];
    welfare = json['Welfare'];
    workPlace = json['WorkPlace'];
    depart = json['Depart'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['offmonth'] = this.offmonth;
    data['offmonthName'] = this.offmonthName;
    data['monthinis'] = this.monthinis;
    data['offyear'] = this.offyear;
    data['DateOff'] = this.dateOff;
    data['userIM'] = this.userIM;
    data['code'] = this.code;
    data['ThaiName'] = this.thaiName;
    data['EngName'] = this.engName;
    data['BankAccount'] = this.bankAccount;
    data['Advance'] = this.advance;
    data['Allowance'] = this.allowance;
    data['AppCrem'] = this.appCrem;
    data['App_Coop_SAMCO'] = this.appCoopSAMCO;
    data['BackPay'] = this.backPay;
    data['Blank01'] = this.blank01;
    data['Blank02'] = this.blank02;
    data['Blank03'] = this.blank03;
    data['Blank04'] = this.blank04;
    data['Blank05'] = this.blank05;
    data['Blank06'] = this.blank06;
    data['Blank07'] = this.blank07;
    data['Blank08'] = this.blank08;
    data['Blank09'] = this.blank09;
    data['Blank10'] = this.blank10;
    data['Card'] = this.card;
    data['ChildEdu'] = this.childEdu;
    data['ChildNotEdu'] = this.childNotEdu;
    data['Cola'] = this.cola;
    data['CompenTax'] = this.compenTax;
    data['Coop1_SAMCO'] = this.coop1SAMCO;
    data['Coop1_SCB'] = this.coop1SCB;
    data['Coop2_SAMCO'] = this.coop2SAMCO;
    data['Coop2_SCB'] = this.coop2SCB;
    data['CoopDebtAdd'] = this.coopDebtAdd;
    data['CoopSamco'] = this.coopSamco;
    data['Crem'] = this.crem;
    data['Crem_SAMCO'] = this.cremSAMCO;
    data['DamageFee'] = this.damageFee;
    data['Diligent'] = this.diligent;
    data['Donate'] = this.donate;
    data['Emp_PF'] = this.empPF;
    data['Emp_SS'] = this.empSS;
    data['Extra1'] = this.extra1;
    data['Extra2'] = this.extra2;
    data['Form'] = this.form;
    data['IncOther1'] = this.incOther1;
    data['IncOther2'] = this.incOther2;
    data['IncOther3'] = this.incOther3;
    data['IncomeYTD'] = this.incomeYTD;
    data['Insurance'] = this.insurance;
    data['InsuranceDeves'] = this.insuranceDeves;
    data['JLDesc'] = this.jLDesc;
    data['Law_Comp'] = this.lawComp;
    data['LegalDpt'] = this.legalDpt;
    data['NetIncome'] = this.netIncome;
    data['NoDays'] = this.noDays;
    data['OT1'] = this.oT1;
    data['OT2'] = this.oT2;
    data['OT3'] = this.oT3;
    data['OT15'] = this.oT15;
    data['OT15S'] = this.oT15S;
    data['OT_DF'] = this.oTDF;
    data['OT_HD'] = this.oTHD;
    data['OrgCode'] = this.orgCode;
    data['OrgName'] = this.orgName;
    data['Other3'] = this.other3;
    data['Other4'] = this.other4;
    data['Outtime'] = this.outtime;
    data['PFYTD'] = this.pFYTD;
    data['PayDate'] = this.payDate;
    data['Return_Reward'] = this.returnReward;
    data['Return_Wage'] = this.returnWage;
    data['Reward'] = this.reward;
    data['Risk'] = this.risk;
    data['SLF'] = this.sLF;
    data['SSYTD'] = this.sSYTD;
    data['SSID'] = this.sSID;
    data['SUN'] = this.sUN;
    data['Salary'] = this.salary;
    data['SalaryDeduc'] = this.salaryDeduc;
    data['Tax'] = this.tax;
    data['TaxYTD'] = this.taxYTD;
    data['TaxPayType'] = this.taxPayType;
    data['Tax_N'] = this.taxN;
    data['Telephone'] = this.telephone;
    data['TotalDed'] = this.totalDed;
    data['TotalInc'] = this.totalInc;
    data['Training'] = this.training;
    data['Wage'] = this.wage;
    data['Wage_other'] = this.wageOther;
    data['Welfare'] = this.welfare;
    data['WorkPlace'] = this.workPlace;
    data['Depart'] = this.depart;
    return data;
  }
}
