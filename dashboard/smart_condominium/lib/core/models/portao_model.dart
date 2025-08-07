class PortaoModel {
  int? id;
  String? topico;
  bool? gateOpen;
  String? timestamp;

  PortaoModel({this.id, this.topico, this.gateOpen, this.timestamp});

  PortaoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    topico = json['topico'];
    gateOpen = json['gate_open'] as bool?;
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['topico'] = topico;
    data['gate_open'] = gateOpen;
    data['timestamp'] = timestamp;
    return data;
  }
}

class PortaoResponseModel {
  int? limit;
  int? offset;
  List<PortaoModel>? data;
  bool? hasMore;
  int? total;

  PortaoResponseModel({
    this.limit,
    this.offset,
    this.data,
    this.hasMore,
    this.total,
  });

  PortaoResponseModel.fromJson(Map<String, dynamic> json) {
    limit = json['limit'];
    offset = json['offset'];
    if (json['data'] != null) {
      data = <PortaoModel>[];
      json['data'].forEach((v) {
        data!.add(PortaoModel.fromJson(v));
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
