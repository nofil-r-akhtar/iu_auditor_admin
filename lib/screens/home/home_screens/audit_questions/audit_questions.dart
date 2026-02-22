import 'package:flutter/material.dart';
import 'package:iu_auditor_admin/components/home_components/home_app_bar.dart';

class AuditQuestions extends StatelessWidget {
  const AuditQuestions({super.key});

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: appBar(
      context, 
      title: "Audit Questions"),
    );
  }
}