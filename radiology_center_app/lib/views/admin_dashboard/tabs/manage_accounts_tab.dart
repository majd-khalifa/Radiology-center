// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:radiology_center_app/core/enums/user_role.dart';
import 'package:radiology_center_app/models/user_model.dart';

import '../controller/admin_cubit.dart';
import '../controller/admin_state.dart';
import '../widgets/user_account_tile.dart';
import '../../../../core/constant/app_color.dart';
import '../../../../core/constant/text_style.dart';

class ManageAccountsTab extends StatelessWidget {
  const ManageAccountsTab({super.key});

  void showAddUserDialog(BuildContext context) {
    final adminCubit = context.read<AdminCubit>();

    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final fullNameController = TextEditingController();
    UserRole selectedRole = UserRole.user;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            "Add User",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Username"),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                TextField(
                  controller: fullNameController,
                  decoration: const InputDecoration(labelText: "Full Name"),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<UserRole>(
                  value: selectedRole,
                  decoration: const InputDecoration(labelText: "Role"),
                  items: const [
                    DropdownMenuItem(
                      value: UserRole.admin,
                      child: Text("Admin"),
                    ),
                    DropdownMenuItem(value: UserRole.user, child: Text("User")),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      selectedRole = value;
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final newUser = {
                  "user_name": nameController.text,
                  "name": nameController.text,
                  "email": emailController.text,
                  "full_name": fullNameController.text,
                  "role": selectedRole == UserRole.admin ? "admin" : "user",
                };

                adminCubit.createUser(newUser);
                Navigator.pop(dialogContext);
              },
              child: const Text("Create"),
            ),
          ],
        );
      },
    );
  }

  void showEditUserDialog(BuildContext context, UserModel user) {
    final adminCubit = context.read<AdminCubit>();

    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);
    final fullNameController = TextEditingController(text: user.name);
    UserRole selectedRole = user.role;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            "Edit User",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Username"),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                TextField(
                  controller: fullNameController,
                  decoration: const InputDecoration(labelText: "Full Name"),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<UserRole>(
                  value: selectedRole,
                  decoration: const InputDecoration(labelText: "Role"),
                  items: const [
                    DropdownMenuItem(
                      value: UserRole.admin,
                      child: Text("Admin"),
                    ),
                    DropdownMenuItem(value: UserRole.user, child: Text("User")),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      selectedRole = value;
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedData = {
                  "name": nameController.text,
                  "email": emailController.text,
                  "full_name": fullNameController.text,
                  "role": selectedRole == UserRole.admin ? "admin" : "user",
                };

                adminCubit.updateUser(user.id, updatedData);
                Navigator.pop(dialogContext);
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminCubit, AdminState>(
      builder: (context, state) {
        if (state is AdminLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is AdminError) {
          return Center(
            child: Text(
              state.message,
              style: AppTextStyles.textStyle16.copyWith(color: AppColor.xIcon),
            ),
          );
        }

        if (state is AdminLoadSuccess || state is AdminOperationSuccess) {
          final users = state is AdminLoadSuccess
              ? state.users
              : (state as AdminOperationSuccess).users;

          if (users.isEmpty) {
            return Center(
              child: Text(
                "No users found",
                style: AppTextStyles.textStyle16.copyWith(color: AppColor.grey),
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Manage Accounts",
                      style: AppTextStyles.textStyle20.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColor.black,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => showAddUserDialog(context),
                      icon: const Icon(Icons.person_add),
                      label: const Text("Add User"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.buttonBackground,
                        foregroundColor: AppColor.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return UserAccountTile(
                      name: user.name,
                      email: user.email,
                      onEdit: () => showEditUserDialog(context, user),
                      onDelete: () {
                        context.read<AdminCubit>().deleteUser(user.id);
                      },
                    );
                  },
                ),
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
