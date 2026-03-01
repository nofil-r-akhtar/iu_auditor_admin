import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/modal_class/table/table_model.dart';

class NewFacultiesController extends GetxController{
  final TextEditingController searchControler = TextEditingController();

  List<TableColumnModel> col = [
    TableColumnModel(title: "Name / Email"),
    TableColumnModel(title: "Department"),
    TableColumnModel(title: "Audit Date"),
    TableColumnModel(title: "Status"),
    TableColumnModel(title: "Action")
  ];
}