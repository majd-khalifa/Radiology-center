// lib/views/admin_dashboard/tabs/manage_accounts_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controller/admin_cubit.dart';
import '../controller/admin_state.dart';
import '../widgets/user_account_tile.dart';

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
                    onEdit: () {},
                    onDelete: () => context.read<AdminCubit>().deleteUser(
                      user.id!,
                      state.users,
                    ),
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
}
