class TsvRecord {
  /// Returns the new instance of [TsvRecord].
  TsvRecord();

  final _values = <String>[];

  /// Add record value.
  void addValue(final String value) => _values.add(value);

  @override
  String toString() => '${_values.join('\t')}\n';
}
