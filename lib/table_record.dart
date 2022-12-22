import 'record.dart';

class TableRecord implements Record {
  /// Returns the new instance of [TableRecord].
  TableRecord();

  final _values = <String>[];

  /// Add record value.
  void addValue(final String value) => _values.add(value);

  /// Returns the length of this record.
  int get length => _values.length;

  @override
  String toString() => '|${_values.join('|')}|\n';
}
