import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive_animation/alert_dialog/profile/edit_email_dialog.dart';
import 'package:rive_animation/alert_dialog/profile/edit_name_dialog.dart';
import 'package:rive_animation/alert_dialog/profile/edit_phone_dialog.dart';
import 'package:rive_animation/alert_dialog/profile/logout_alert_dialog.dart';
import 'package:rive_animation/model/course.dart';
import 'package:rive_animation/screens/pages/components/secondary_course_card.dart';
import 'package:rive_animation/screens/pages/profile_page/profile_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  /// Function to Show Edit Dialog
  void _showEditDialog(BuildContext context, WidgetRef ref, Course course) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (course.title == "Nama") {
          return EditNameDialog(
            initialName: course.description,
            onUpdated: (newName) => ref.read(profileProvider.notifier).updateProfile("Nama", newName),
          );
        } else if (course.title == "Nomor Telepon") {
          return EditPhoneDialog(
            initialPhone: course.description,
            onUpdated: (newPhone) => ref.read(profileProvider.notifier).updateProfile("Nomor Telepon", newPhone),
          );
        } else if (course.title == "Email") {
          return EditEmailDialog(
            initialEmail: course.description,
            onUpdated: (newEmail) => ref.read(profileProvider.notifier).updateProfile("Email", newEmail),
          );
        }
        return const SizedBox();
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => const LogoutAlertDialog(),
          );
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.logout, color: Colors.white),
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Profil",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              if (profile.isEmpty)
                const Center(child: CircularProgressIndicator())
              else
                ...profile.map((course) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: GestureDetector(
                      onTap: () => _showEditDialog(context, ref, course),
                      child: SecondaryCourseCard(
                        description: course.description,
                        title: course.title,
                        // iconsSrc: course.iconSrc,
                        colorl: course.color,
                      ),
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}
