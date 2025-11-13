import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../screens/dashboard_screen.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  var isLoading = false.obs;

  void login() {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      Future.delayed(const Duration(seconds: 1), () async{
       await sendSms("+919307210205", "Welcome Back!");  
        
        isLoading.value = false;

        Get.off(() => const DashboardScreen());
      });
    }
  }

  Future<void> sendSms(String phone, String message) async {
    final url = Uri.parse('http://192.168.0.100:3000/send-sms');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'to': phone, 'message': message}),
    );

    if (response.statusCode == 200) {
      print('SMS sent successfully!');
    } else {
      print('Failed to send SMS: ${response.body}');
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
