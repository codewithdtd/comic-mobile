
class User{ 
  final String? id; 
  final String title;
  final String description;
  final String imageAvatar;
  final String imageBackground; 
  final String creatorId;
  
  User({
    this.id,
    required this.title, 
    required this.description, 
    required this.imageAvatar,
    required this.imageBackground,
    required this.creatorId,
  });

  // ignore: non_constant_identifier_titles
  copyWith({
    String? id,
    String? title, 
    String? description,
    String? imageAvatar,
    String? imageBackground,
    String? creatorId,
  }) {
    return User(
      id: id ?? this.id,
      title: title ?? this.title,
      creatorId: creatorId ?? this.creatorId,
      description: description ?? this.description, 
      imageAvatar: imageAvatar ?? this.imageAvatar,
      imageBackground: imageBackground ?? this.imageBackground,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'creatorId': creatorId,
      'imageAvatar': imageAvatar,
      'imageBackground': imageBackground,
    };
  }

  static User fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      title: json['title'],
      creatorId: json['creatorId'],
      description: json['description'],
      imageAvatar: json['imageAvatar'],
      imageBackground: json['imageBackground'],
    );
  }
}