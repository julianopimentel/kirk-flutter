import 'dart:convert';

import 'package:flutter/material.dart';

class AppTheme {
  final String themeName;
  final Color primaryColor;
  final Color accentColor;
  final Color iconColor;
  final Color statusBarColor;
  final String logo;
  final String logoMenu;

  AppTheme({
    required this.themeName,
    required this.primaryColor,
    required this.accentColor,
    required this.iconColor,
    required this.statusBarColor,
    required this.logo,
    required this.logoMenu,
  });
}

class SkinData {
  final String cor;
  final int integrador;
  final String logo;
  final String logoMenu;

  SkinData({
    required this.cor,
    required this.integrador,
    required this.logo,
    required this.logoMenu,
  });

  factory SkinData.fromJson(String str) => SkinData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SkinData.fromMap(Map<String, dynamic> json) => SkinData(
    cor: json["cor"],
    integrador: json["integrador"],
    logo: json["logo"],
    logoMenu: json["logoMenu"],
  );

  Map<String, dynamic> toMap() => {
    "cor": cor,
    "integrador": integrador,
    "logo": logo,
    "logoMenu": logoMenu,
  };
}