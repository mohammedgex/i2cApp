class CartResponseModel {
  final String status;
  final CartData data;

  CartResponseModel({required this.status, required this.data});

  factory CartResponseModel.fromJson(Map<String, dynamic> json) {
    return CartResponseModel(
      status: json['status'],
      data: CartData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toJson(),
    };
  }
}

class CartData {
  final int totalQty;
  final String totalAmount;
  final List<CartCourse> cartCourses;

  CartData({
    required this.totalQty,
    required this.totalAmount,
    required this.cartCourses,
  });

  factory CartData.fromJson(Map<String, dynamic> json) {
    return CartData(
      totalQty: json['total_qty'],
      totalAmount: json['total_amount'],
      cartCourses: List<CartCourse>.from(
        json['cart_courses'].map((course) => CartCourse.fromJson(course)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_qty': totalQty,
      'total_amount': totalAmount,
      'cart_courses': cartCourses.map((course) => course.toJson()).toList(),
    };
  }
}

class CartCourse {
  final int? courseId;
  final String slug;
  final String title;
  final String thumbnail;
  final String price;
  var discount;
  final Instructor instructor;
  final int students;
  final double averageRating;

  CartCourse({
    required this.courseId,
    required this.slug,
    required this.title,
    required this.thumbnail,
    required this.price,
    required this.discount,
    required this.instructor,
    required this.students,
    required this.averageRating,
  });

  factory CartCourse.fromJson(Map<String, dynamic> json) {
    final Object? nestedCourse = json['course'] ?? json['course_data'];
    final Object? nestedCourseId =
        nestedCourse is Map ? nestedCourse['id'] : null;
    final Object? courseId = json['course_id'] ?? nestedCourseId;
    final Object? instructorData = json['instructor'];
    return CartCourse(
      courseId: int.tryParse(courseId?.toString() ?? ''),
      slug: json['slug']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      thumbnail: json['thumbnail']?.toString() ?? '',
      price: json['price']?.toString() ?? '',
      discount: json['discount'],
      instructor: Instructor.fromJson(
        instructorData is Map
            ? Map<String, dynamic>.from(instructorData)
            : {
                'id': json['instructor_id'],
                'name': json['instructor_name'],
                'image': json['instructor_image'],
              },
      ),
      students: int.tryParse(json['students']?.toString() ?? '') ?? 0,
      averageRating:
          double.tryParse(json['average_rating']?.toString() ?? '') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'course_id': courseId,
      'slug': slug,
      'title': title,
      'thumbnail': thumbnail,
      'price': price,
      'discount': discount,
      'instructor': instructor.toJson(),
      'students': students,
      'average_rating': averageRating,
    };
  }
}

class Instructor {
  final int id;
  final String name;
  final String image;

  Instructor({required this.id, required this.name, required this.image});

  factory Instructor.fromJson(Map<String, dynamic> json) {
    return Instructor(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }
}
