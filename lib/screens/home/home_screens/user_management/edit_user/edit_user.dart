import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/app_theme/colors.dart';
import 'package:iu_auditor_admin/components/app_text.dart';
import 'package:iu_auditor_admin/components/app_text_field.dart';
import 'package:iu_auditor_admin/const/enums.dart';
import 'package:iu_auditor_admin/screens/home/home_screens/user_management/add_user/add_user_controller.dart';
import 'edit_user_controller.dart';

class EditUser extends StatelessWidget {
  final String tag;
  const EditUser({required this.tag, super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<EditUserController>(tag: tag);

    return Obx(() => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // ── Name (EDITABLE) + Email (READONLY) ─────────────
        Row(children: [
          Expanded(child: _field(context, 'Full Name',
            AppTextField(
              textController: c.nameController,
              placeholder: 'e.g. Dr. Ahmed Hassan',
              placeholderColor: hintTextColor,
              isError: c.nameError.value.isNotEmpty,
              errorText: c.nameError.value,
            ),
          )),
          const SizedBox(width: 16),
          Expanded(child: _readonlyField(context, 'Email', c.readonlyEmail)),
        ]),
        const SizedBox(height: 16),

        // ── Role dropdown ──────────────────────────────────
        _field(context, 'Role',
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: c.roleError.value.isNotEmpty
                      ? Border.all(color: Colors.red, width: 1.2)
                      : null,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<UserRole>(
                    isExpanded: true,
                    value: c.selectedRole.value,
                    hint: AppTextRegular(
                        text: 'Select Role',
                        color: hintTextColor,
                        fontSize: 13),
                    items: kManageableRoles.map((r) => DropdownMenuItem<UserRole>(
                      value: r,
                      child: Row(children: [
                        Icon(_roleIcon(r), size: 16, color: _roleColor(r)),
                        const SizedBox(width: 10),
                        AppTextRegular(text: r.displayLabel, fontSize: 13),
                      ]),
                    )).toList(),
                    onChanged: (r) {
                      c.selectedRole.value = r;
                      c.roleError.value = '';
                      if (r != UserRole.departmentHead) {
                        c.selectedDepartment.value = null;
                        c.departmentError.value = '';
                      }
                    },
                  ),
                ),
              ),
              if (c.roleError.value.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 4),
                  child: Text(c.roleError.value,
                      style: const TextStyle(color: Colors.red, fontSize: 11)),
                ),
              // ── Role description badge (local class) ──────
              if (c.selectedRole.value != null) ...[
                const SizedBox(height: 8),
                _RoleBadge(role: c.selectedRole.value!),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),

        // ── Department — only for department_head ──────────
        if (c.requiresDepartment) ...[
          _field(context, 'Department',
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: c.departmentError.value.isNotEmpty
                      ? Border.all(color: Colors.red, width: 1.2)
                      : null,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Department>(
                    isExpanded: true,
                    value: c.selectedDepartment.value,
                    hint: AppTextRegular(
                        text: 'Select Department',
                        color: hintTextColor,
                        fontSize: 13),
                    items: Department.values.map((d) => DropdownMenuItem(
                      value: d,
                      child: AppTextRegular(text: d.label, fontSize: 13),
                    )).toList(),
                    onChanged: (d) {
                      c.selectedDepartment.value = d;
                      c.departmentError.value = '';
                    },
                  ),
                ),
              ),
              if (c.departmentError.value.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 4),
                  child: Text(c.departmentError.value,
                      style: const TextStyle(color: Colors.red, fontSize: 11)),
                ),
            ]),
          ),
          const SizedBox(height: 16),
        ],

        // ── New Password (OPTIONAL) ────────────────────────
        _field(context, 'New Password (optional)',
          AppTextField(
            textController: c.passwordController,
            placeholder: 'Leave blank to keep current password',
            placeholderColor: hintTextColor,
            obscureText: true,
            isError: c.passwordError.value.isNotEmpty,
            errorText: c.passwordError.value,
          ),
        ),
        const SizedBox(height: 6),
        Row(children: [
          const Icon(Icons.info_outline, size: 13, color: Colors.grey),
          const SizedBox(width: 6),
          Flexible(
            child: AppTextRegular(
              text: 'Only fill this in if you want to reset the password.',
              color: descriptiveColor,
              fontSize: 11,
            ),
          ),
        ]),
      ],
    ));
  }

  Widget _readonlyField(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          AppTextSemiBold(
              text: label,
              color: Theme.of(context).primaryColor,
              fontSize: 13),
          const SizedBox(width: 4),
          const Icon(Icons.lock_outline, size: 12, color: Colors.grey),
        ]),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFEEEEEE),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFCCCCCC), width: 0.8),
          ),
          child: AppTextRegular(
              text: value, color: const Color(0xFF999999), fontSize: 13),
        ),
      ],
    );
  }

  Widget _field(BuildContext context, String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextSemiBold(
            text: label,
            color: Theme.of(context).primaryColor,
            fontSize: 13),
        const SizedBox(height: 6),
        child,
      ],
    );
  }

  IconData _roleIcon(UserRole r) {
    switch (r) {
      case UserRole.superAdmin:     return Icons.admin_panel_settings_outlined;
      case UserRole.admin:          return Icons.manage_accounts_outlined;
      case UserRole.departmentHead: return Icons.supervised_user_circle_outlined;
      default:                      return Icons.person_outline;
    }
  }

  Color _roleColor(UserRole r) {
    switch (r) {
      case UserRole.superAdmin:     return Colors.purple;
      case UserRole.admin:          return Colors.blue;
      case UserRole.departmentHead: return Colors.teal;
      default:                      return Colors.grey;
    }
  }
}

// ── Local private widget — role description badge ────────────
class _RoleBadge extends StatelessWidget {
  final UserRole role;
  const _RoleBadge({required this.role});

  String get _description {
    switch (role) {
      case UserRole.superAdmin:
        return 'Full access to all features including user management and system settings.';
      case UserRole.admin:
        return 'Can manage teachers, lecturers, audit forms and reviews. Cannot manage users.';
      case UserRole.departmentHead:
        return 'Can view audit reports and manage faculty within their assigned department.';
      default:
        return '';
    }
  }

  Color get _color {
    switch (role) {
      case UserRole.superAdmin:     return Colors.purple;
      case UserRole.admin:          return Colors.blue;
      case UserRole.departmentHead: return Colors.teal;
      default:                      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _color.withOpacity(0.2)),
      ),
      child: Row(children: [
        Icon(Icons.info_outline, size: 14, color: _color),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            _description,
            style: TextStyle(
              fontSize: 11,
              color: _color.withOpacity(0.85),
            ),
          ),
        ),
      ]),
    );
  }
}