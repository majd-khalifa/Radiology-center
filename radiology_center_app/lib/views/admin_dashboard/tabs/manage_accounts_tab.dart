// lib/views/admin_dashboard/tabs/manage_accounts_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controller/admin_cubit.dart';
import '../controller/admin_state.dart';
import '../widgets/user_account_tile.dart';
import '../../../../models/user_model.dart';

class ManageAccountsTab extends StatelessWidget {
  const ManageAccountsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminCubit()..fetchAllUsers(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocBuilder<AdminCubit, AdminState>(
          builder: (context, state) {
            if (state is AdminLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AdminSuccess) {
              return ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  final user = state.users[index];
                  return UserAccountTile(
                    name: user.username,
                    email: user.email,
                    onEdit: () =>
                        _showEditUserDialog(context, user, state.users),
                    onDelete: () =>
                        _showDeleteConfirm(context, user.id!, state.users),
                  );
                },
              );
            } else if (state is AdminError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _showEditUserDialog(
    BuildContext context,
    UserModel user,
    List<UserModel> currentUsers,
  ) {
    final nameController = TextEditingController(text: user.username);
    final emailController = TextEditingController(text: user.email);
    final cubit = context.read<AdminCubit>(); // حفظ الـ Cubit قبل الـ Dialog

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("تعديل الحساب"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "اسم المستخدم"),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "الإيميل"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("إلغاء"),
          ),
          ElevatedButton(
            onPressed: () {
              cubit.updateUser(user.id!, {
                "username": nameController.text,
                "email": emailController.text,
              }, currentUsers);
              Navigator.pop(context);
            },
            child: const Text("حفظ"),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context, int id, List<UserModel> users) {
    final cubit = context.read<AdminCubit>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("حذف المستخدم"),
        content: const Text("هل أنت متأكد من حذف هذا الحساب نهائياً؟"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("إلغاء"),
          ),
          TextButton(
            onPressed: () {
              cubit.deleteUser(id, users);
              Navigator.pop(context);
            },
            child: const Text("حذف", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
