extension StringExt on String {
  String capitalize() {
    return this.split(' ').map((element) {
      return element[0].toUpperCase() + element.substring(1);
    }).join(' ');
  }
}
