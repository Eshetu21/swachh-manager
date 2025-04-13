class Admin {
  final String id;
  final String userId;

  Admin({required this.id, required this.userId});

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(id: json["id"], userId: json["user_id"]);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "user_id": userId};
  }
}

