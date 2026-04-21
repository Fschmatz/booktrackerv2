class AppParameter {
  String? _key;
  String? _value;

  AppParameter({String? key, String? value})
      : _key = key,
        _value = value;

  String? getKey() => _key;

  String? getValue() => _value;

  void setKey(String value) {
    _key = value;
  }

  void setValue(String value) {
    _value = value;
  }

  factory AppParameter.fromMap(Map<String, dynamic> map) {
    return AppParameter(
      key: map['key'],
      value: map['value'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'key': _key,
      'value': _value,
    };
  }

  @override
  String toString() {
    return 'AppParameter{_key: $_key, _value: $_value}';
  }
}
