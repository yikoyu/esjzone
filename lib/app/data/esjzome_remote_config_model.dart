class EsjzomeRemoteConfig {
  List<Node>? node;

  EsjzomeRemoteConfig({this.node});

  EsjzomeRemoteConfig.fromJson(Map<String, dynamic> json) {
    if (json['node'] != null) {
      node = <Node>[];
      json['node'].forEach((v) {
        node?.add(Node.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (node != null) {
      data['node'] = node?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Node {
  String? name;
  String? domain;

  Node({this.name, this.domain});

  Node.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    domain = json['domain'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['domain'] = domain;
    return data;
  }
}
