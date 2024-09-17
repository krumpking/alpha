import 'package:alpha/core/constants/color_constants.dart';
import 'package:alpha/core/utils/providers.dart';
import 'package:alpha/core/routes/routes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/constants/local_image_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminStaffStats extends ConsumerWidget {
  const AdminStaffStats({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final staffCounts = ref.watch(ProviderUtils.staffCountProvider);

    return Scaffold(
      backgroundColor: Pallete.primaryColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Pallete.primaryColor,
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(220),
            child: Container(
              decoration: BoxDecoration(color: Pallete.primaryColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: FirebaseAuth.instance.currentUser!.photoURL ??
                          "https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?q=80&w=2080&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                      width: MediaQuery.of(context).size.height * 0.18,
                      httpHeaders: const {
                        "Content-Type": "image/jpeg",
                      },
                      height: MediaQuery.of(context).size.height * 0.18,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Skeletonizer(
                        enabled: true,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.45,
                          child: Image.asset(LocalImageConstants.logo),
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  Text(
                    FirebaseAuth.instance.currentUser!.displayName ??
                        'Alpha Imperial',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  const Text(
                    'Our Monthly Stats',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            )),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(26),
              topRight: Radius.circular(26),
            )),
        child: staffCounts.when(
          data: (counts) => Column(
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: statWidget(
                            number:
                                counts['Care and Support Workers'].toString(),
                            title: "Total Care and Support Workers")),
                    const SizedBox(width: 16),
                    Expanded(
                        child: statWidget(
                            number: counts['Social Workers'].toString(),
                            title: "Social Workers")),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Expanded(
                        child: statWidget(
                            number: counts['Nurses'].toString(),
                            title: "Nurses")),
                    const SizedBox(width: 16),
                    Expanded(
                        child: GestureDetector(
                      onTap: () => Get.toNamed(RoutesHelper.viewUserScreen),
                      child: statWidget(number: "Staff", title: "Add/Remove"),
                    )),
                  ],
                ),
              ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text(error.toString())),
        ),
      ),
    );
  }

  Widget statWidget({required String number, required String title}) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
      decoration: BoxDecoration(
          color: Colors.grey.shade200, borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            number,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Text(
            title.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }
}
