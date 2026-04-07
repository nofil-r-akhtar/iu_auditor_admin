import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/app_theme/colors.dart';
import 'package:iu_auditor_admin/apis/new_faculty/new_faculty_apis.dart';
import 'package:iu_auditor_admin/components/app_container.dart';
import 'package:iu_auditor_admin/components/app_dialog.dart';
import 'package:iu_auditor_admin/components/app_icon_button.dart';
import 'package:iu_auditor_admin/components/app_text.dart';
import 'package:iu_auditor_admin/const/enums.dart';
import 'package:iu_auditor_admin/modal_class/new_faculty/fetch_new_faculty.dart';
import 'package:iu_auditor_admin/modal_class/table/table_model.dart';
import 'package:iu_auditor_admin/screens/home/home_screens/new_faculties/edit_faculties/edit_faculties.dart';
import 'package:iu_auditor_admin/screens/home/home_screens/new_faculties/edit_faculties/edit_faculties_controller.dart';

class NewFacultiesController extends GetxController {
  final NewFacultyApis api = NewFacultyApis();
  final TextEditingController searchControler = TextEditingController();

  RxList<TableColumnModel> col       = <TableColumnModel>[].obs;
  RxList<NewFaculty>       faculties = <NewFaculty>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeColumns();
    fetchTeachers();
  }

  // ── FETCH ──────────────────────────────────────────────────
  Future<void> fetchTeachers() async {
    try {
      isLoading.value = true;
      final response = await api.getAllTeachers();
      if (!response.success) {
        Get.snackbar('Error', response.message);
        return;
      }
      faculties.assignAll(response.data);
    } catch (e) {
      debugPrint('Fetch teachers error: $e');
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ── EDIT ───────────────────────────────────────────────────
  void openEditDialog(NewFaculty teacher) {
    // Register with tag so EditFaculties can find it via Get.find(tag: teacher.id)
    final editCtrl = Get.put(
      EditFacultiesController(),
      tag: teacher.id,
    );
    editCtrl.initFromTeacher(teacher);

    AppDialog.show(
      title: 'Edit Teacher',
      content: EditFaculties(tag: teacher.id), // pass tag to view
      confirmText: 'Save Changes',
      onConfirm: () async {
        await Get.find<EditFacultiesController>(tag: teacher.id).updateTeacher();
        await fetchTeachers();
        Get.delete<EditFacultiesController>(tag: teacher.id);
      },
      onCancel: () {
        Get.back();
        Get.delete<EditFacultiesController>(tag: teacher.id);
      },
    );
  }

  // ── DELETE ─────────────────────────────────────────────────
  void confirmDelete(NewFaculty teacher) {
    AppDialog.showDeleteConfirm(
      teacherName: teacher.name,
      onConfirm: () => _performDelete(teacher.id),
    );
  }

  Future<void> _performDelete(String id) async {
    try {
      final res = await api.deleteTeacher(id: id);
      if (res['success'] == true) {
        Get.snackbar('Success', 'Teacher deleted successfully');
        await fetchTeachers();
      } else {
        Get.snackbar('Error', res['message'] ?? 'Delete failed');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  // ── STATUS UPDATE ──────────────────────────────────────────
  Future<void> updateStatus(String id, TeacherStatus newStatus) async {
    try {
      final res = await api.updateTeacherStatus(
        id: id,
        params: {'status': newStatus.apiValue},
      );
      if (res['success'] == true) {
        Get.snackbar('Success', 'Status updated to ${newStatus.displayLabel}');
        await fetchTeachers();
      } else {
        Get.snackbar('Error', res['message'] ?? 'Status update failed');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  // ── STATUS BADGE COLORS ────────────────────────────────────
  Color _statusBg(TeacherStatus s) {
    switch (s) {
      case TeacherStatus.completed:  return const Color(0xFFE8F5E9);
      case TeacherStatus.scheduled:  return const Color(0xFFE3F2FD);
      case TeacherStatus.cancelled:  return const Color(0xFFFFEBEE);
      case TeacherStatus.pending:    return const Color(0xFFFFF3E0);
    }
  }

  Color _statusText(TeacherStatus s) {
    switch (s) {
      case TeacherStatus.completed:  return const Color(0xFF2E7D32);
      case TeacherStatus.scheduled:  return const Color(0xFF1565C0);
      case TeacherStatus.cancelled:  return const Color(0xFFC62828);
      case TeacherStatus.pending:    return const Color(0xFFE65100);
    }
  }

  // ── TABLE COLUMNS ──────────────────────────────────────────
  void _initializeColumns() {
    col.assignAll([
      TableColumnModel(
        title: 'Name / Email',
        cellBuilder: (row) {
          final teacher = row as NewFaculty;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppTextSemiBold(text: teacher.name, color: navyBlueColor, fontSize: 13),
              const SizedBox(height: 2),
              AppTextRegular(text: teacher.email, color: descriptiveColor, fontSize: 11),
            ],
          );
        },
      ),
      TableColumnModel(
        title: 'Department',
        cellBuilder: (row) {
          final teacher = row as NewFaculty;
          return AppTextRegular(text: teacher.department, color: descriptiveColor, fontSize: 13);
        },
      ),
      TableColumnModel(
        title: 'Specialization',
        cellBuilder: (row) {
          final teacher = row as NewFaculty;
          return AppTextRegular(text: teacher.specialization, color: descriptiveColor, fontSize: 13);
        },
      ),
      TableColumnModel(
        title: 'Joining Date',
        cellBuilder: (row) {
          final teacher = row as NewFaculty;
          return AppTextRegular(
            text: teacher.createdAt.split('T')[0],
            color: descriptiveColor,
            fontSize: 13,
          );
        },
      ),

      // ── Status — inline dropdown ───────────────────────────
      TableColumnModel(
        title: 'Status',
        cellBuilder: (row) {
          final teacher = row as NewFaculty;
          final current = TeacherStatus.fromApiValue(teacher.status);
          final bg      = _statusBg(current);
          final text    = _statusText(current);

          return AppContainer(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            borderRadius: BorderRadius.circular(20),
            bgColor: bg,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<TeacherStatus>(
                value: current,
                isDense: true,
                icon: Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: text),
                style: TextStyle(
                  color: text,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                dropdownColor: whiteColor,
                borderRadius: BorderRadius.circular(12),
                items: TeacherStatus.values.map((s) {
                  return DropdownMenuItem<TeacherStatus>(
                    value: s,
                    child: Text(
                      s.displayLabel,
                      style: TextStyle(
                        color: _statusText(s),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (TeacherStatus? selected) {
                  if (selected != null && selected != current) {
                    updateStatus(teacher.id, selected);
                  }
                },
              ),
            ),
          );
        },
      ),

      // ── Actions ───────────────────────────────────────────
      TableColumnModel(
        title: 'Actions',
        cellBuilder: (row) {
          final teacher = row as NewFaculty;
          return Row(
            children: [
              AppIconButton(
                icon: Icons.edit_outlined,
                iconColor: iconColor,
                onPressed: () => openEditDialog(teacher),
              ),
              AppIconButton(
                icon: Icons.delete_outline,
                iconColor: redColor,
                onPressed: () => confirmDelete(teacher),
              ),
            ],
          );
        },
      ),
    ]);
  }

  @override
  void onClose() {
    searchControler.dispose();
    super.onClose();
  }
}