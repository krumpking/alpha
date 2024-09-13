import 'package:alpha/core/constants/color_constants.dart';
import 'package:alpha/core/utils/routes.dart';
import 'package:alpha/custom_widgets/custom_button/general_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/providers.dart';

class AdminViewUsers extends ConsumerWidget {
  const AdminViewUsers({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(ProviderUtils.staffProvider);

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
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.symmetric(
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
                    leading:  CachedNetworkImage(
                      imageUrl: user.profilePicture ?? '',
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                        backgroundImage: imageProvider,
                      ),
                    ),

                    title: Text(
                        user.name!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14
                      ),
                    ),
                    subtitle: Text(
                        "${user.email}\n${user.phoneNumber }",
                      style:  TextStyle(
                        color: Colors.grey.shade600,
                          fontSize: 12
                      ),
                    ),

                    trailing: Text(
                      user.post!,
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
                    ref.read(ProviderUtils.staffProvider.notifier).streamUsers();
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
