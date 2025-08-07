class CaixaModel {
  int? id;
  String? topico;
  double? distancia;
  double? volume;
  String? timestamp;

  CaixaModel({
    this.id,
    this.topico,
    this.distancia,
    this.volume,
    this.timestamp,
  });

  CaixaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    topico = json['topico'];
    distancia = (json['distancia'] as num?)?.toDouble();
    volume = (json['volume'] as num?)?.toDouble();
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['topico'] = topico;
    data['distancia'] = distancia;
    data['volume'] = volume;
    data['timestamp'] = timestamp;
    return data;
  }
}

class CaixaResponseModel {
  int? limit;
  int? offset;
  List<CaixaModel>? data;
  bool? hasMore;
  int? total;

  CaixaResponseModel({
    this.limit,
    this.offset,
    this.data,
    this.hasMore,
    this.total,
  });

  CaixaResponseModel.fromJson(Map<String, dynamic> json) {
    limit = json['limit'];
    offset = json['offset'];
    if (json['data'] != null) {
      data = <CaixaModel>[];
      json['data'].forEach((v) {
        data!.add(CaixaModel.fromJson(v));
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
