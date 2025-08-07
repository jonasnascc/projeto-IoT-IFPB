class EnergiaModel {
  int? id;
  String? topico;
  double? corrente;
  String? timestamp;

  EnergiaModel({this.id, this.topico, this.corrente, this.timestamp});

  EnergiaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    topico = json['topico'];
    corrente = (json['corrente'] as num?)?.toDouble();
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['topico'] = topico;
    data['corrente'] = corrente;
    data['timestamp'] = timestamp;
    return data;
  }
}

class EnergiaResponseModel {
  int? limit;
  int? offset;
  List<EnergiaModel>? data;
  bool? hasMore;
  int? total;

  EnergiaResponseModel({
    this.limit,
    this.offset,
    this.data,
    this.hasMore,
    this.total,
  });

  EnergiaResponseModel.fromJson(Map<String, dynamic> json) {
    limit = json['limit'];
    offset = json['offset'];
    if (json['data'] != null) {
      data = <EnergiaModel>[];
      json['data'].forEach((v) {
        data!.add(EnergiaModel.fromJson(v));
      });
    }
    hasMore = json['hasMore'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['limit'] = limit;
    data['offset'] = offset;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['hasMore'] = hasMore;
    data['total'] = total;
    return data;
  }
}
