import 'package:freezed_annotation/freezed_annotation.dart';

part 'data_graph.freezed.dart';
part 'data_graph.g.dart';

@freezed
class DataGraph with _$DataGraph{
  const factory DataGraph({
    required int count,
    required double sum
}) = _DataGraph;

  const DataGraph._();

  factory DataGraph.fromJson(Map<String, dynamic> json) =>
      _$DataGraphFromJson(json);
}