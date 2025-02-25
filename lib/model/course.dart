import 'package:flutter/material.dart' show Color;
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Course extends Equatable {
  final String id;
  final String title;
  final String description;
  final Color color;

  const Course({
    required this.id,
    required this.title,
    required this.description,
    this.color = Colors.blue, // Default color
  });

  // Implement Equatable props
  @override
  List<Object?> get props => [title, description, color];

  // Add copyWith method for updating fields
  Course copyWith({
    String? title,
    String? description,
    Color? color,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      color: color ?? this.color,
    );
  }
}


// final List<Course> courses = [
//   Course(
//     title: "Animations in SwiftUI",
//   ),
//   Course(
//     title: "Animations in Flutter",
//     iconSrc: "assets/icons/code.svg",
//     color: const Color(0xFF80A4FF),
//   ),
// ];

// final List<Course> recentCourses = [
//   Course(title: "State Machine"),
//   Course(
//     title: "Animated Menu",
//     color: const Color(0xFF9CC5FF),
//     iconSrc: "assets/icons/code.svg",
//   ),
//   Course(title: "Flutter with Rive"),
//   Course(
//     title: "Animated Menu",
//     color: const Color(0xFF9CC5FF),
//     iconSrc: "assets/icons/code.svg",
//   ),
// ];

// final List<Course> settingsMenu = [
//   Course(
//     title: "Ubah Port Aplikasi",
//     description: "Default port : http://localhost:3000/" 
//     )
// ];
