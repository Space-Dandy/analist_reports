String formatDate(String iso) {
  try {
    final dt = DateTime.parse(iso).toLocal();
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final y = dt.year.toString();

    final hour24 = dt.hour;
    final hour12 = hour24 == 0 ? 12 : (hour24 > 12 ? hour24 - 12 : hour24);
    final h = hour12.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    final period = hour24 >= 12 ? 'PM' : 'AM';

    return '$d-$m-$y $h:$min $period';
  } catch (_) {
    return iso;
  }
}
