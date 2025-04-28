import 'package:json_annotation/json_annotation.dart';
part 'example.g.dart';

@JsonSerializable()
class Example {
  int userId;
  int id;
  String title;
  String body;

  Example({this.userId = 0, this.id = 0, this.title = "", this.body = ""});

  factory Example.fromJson(Map<String, dynamic> json) =>
      _$ExampleFromJson(json);
  Map<String, dynamic> toJson() => _$ExampleToJson(this);
}
