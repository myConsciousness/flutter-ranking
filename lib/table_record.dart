import 'record.dart';

class TableRecord implements Record {
  /// Returns the new instance of [TableRecord].
  TableRecord();

  final _values = <String>[];

  /// Add record value.
  void addValue(final String value) => _values.add(value);

  @override
  String toString() => '|${_values.join('|')}|\n';
}
