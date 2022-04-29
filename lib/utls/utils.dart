import 'package:intl/intl.dart';

class Utils {
  static formatPrice(double price) => '\${price.toStringAsFixed(2)}';
  static formatDate(DateTime date) => DateFormat.yMd().format(date);

  static var month = [
    'ม.ค.',
    'ก.พ.',
    'มี.ค.',
    'เม.ย.',
    'พ.ค.',
    'มิ.ย.',
    'ก.ค.',
    'ส.ค.',
    'ก.ย.',
    'ต.ค.',
    'พ.ย.',
    'ธ.ค.'
  ];
  static newPayDate(String date) {
    var spdate = date.split("/");
    var mon = int.parse(spdate[1]);
    var year = int.parse(spdate[2]);
    var newyear = year + 543;
    return '${spdate[0]} ${Utils.month[mon - 1]} $newyear';
  }

  static setformat(ssID) {
    return ssID.replaceAllMapped(RegExp(r'(\d{1})(\d{4})(\d{5})(\d{2})(\d+)'),
        (Match m) => "${m[1]}-${m[2]}-${m[3]}-${m[4]}-${m[5]}");
  }

  static setformatbankAcc(bankacc) {
    return bankacc.replaceAllMapped(RegExp(r'(\d{3})(\d{1})(\d{5})(\d+)'),
        (Match m) => "${m[1]}-${m[2]}-${m[3]}-${m[4]}");
  }
}
