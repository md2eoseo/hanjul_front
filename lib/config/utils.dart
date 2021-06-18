String getTodaysDate() {
  var now = DateTime.now();
  var formattedDate = "";
  formattedDate += now.year.toString().substring(2);
  formattedDate += now.month.toString().padLeft(2, '0');
  formattedDate += now.day.toString().padLeft(2, '0');
  return formattedDate;
}
