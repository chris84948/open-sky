extension StringExt on String {
  String capitalize() {
    return this.split(' ').map((element) {
      return element[0].toUpperCase() + element.substring(1);
    }).join(' ');
  }
}

extension JsonExt on Map<String, dynamic> {
  double getDoubleSafe(String fieldName) {
    return this[fieldName] != null ? this[fieldName].toDouble() : 0.0;
  }
}
