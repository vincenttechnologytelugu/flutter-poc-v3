

class ProfileResponseModel {
  ProfileResponseModel({
      this.id, 
      this.firstName, 
      this.lastName, 
      this.email, 
      this.createdAt, 
      this.lastUpdatedAt,});

  ProfileResponseModel.fromJson(dynamic json) {
    id = json['_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    createdAt = json['created_at'];
    lastUpdatedAt = json['last_updated_at'];
  }
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? createdAt;
  String? lastUpdatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['email'] = email;
    map['created_at'] = createdAt;
    map['last_updated_at'] = lastUpdatedAt;
    return map;
  }

}