
class Chapter{ 
  final String? id; 
  final String title;
  final String content;
  final List image; 
  final String productId ;

  
  Chapter({
    required this.productId,
    this.id,
    required this.title, 
    required this.content, 
    required this.image,
  });

  // ignore: non_constant_identifier_names
  copyWith({
    String? id,
    String? title, 
    String? content,
    List? image,
    String? productId,
  }) {
    return Chapter(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content, 
      image: image ?? this.image,
      productId: productId ?? this.productId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'image': image,
      'productId': productId,
    };
  }

  static Chapter fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      image: json['image'],
      productId: json['productId'],
    );
  }
}