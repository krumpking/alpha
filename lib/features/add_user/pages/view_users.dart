import 'package:alpha/core/constants/color_constants.dart';
import 'package:alpha/core/utils/routes.dart';
import 'package:alpha/custom_widgets/custom_button/general_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/stuff_provider.dart';

class AdminViewUsers extends ConsumerWidget {
  const AdminViewUsers({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the stuffProvider for user state changes
    final userState = ref.watch(stuffProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.primaryColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Staff List',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: userState.when(
          data: (users) {
            if (users.isEmpty) {
              return const Center(
                child: Text('No users found.'),
              );
            }
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.symmetric(
                     vertical: 8
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Pallete.primaryColor.withOpacity(0.2)
                    )
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading:  Icon(
                      Icons.person,
                      color: Pallete.primaryColor,
                    ),
                    title: Text(
                        user['email'] ?? 'No Email',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14
                      ),
                    ),
                    subtitle: Text(
                        user['phone_number'] ?? '',
                      style:  TextStyle(
                        color: Colors.grey.shade600,
                          fontSize: 12
                      ),
                    ),

                    trailing: Text(
                      user['role'] ?? '',
                      style:  TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12
                      ),
                    ),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Failed to load users: $error'),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Add logic to retry fetching users
                    ref.read(stuffProvider.notifier).fetchUsers();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: GeneralButton(
          onTap: () {
            Get.toNamed(RoutesHelper.adminAddUserScreen);
          },
          btnColor: Pallete.primaryColor,
          borderRadius: 10,
          width: 300,
          child: const Text(
            'Add User',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
