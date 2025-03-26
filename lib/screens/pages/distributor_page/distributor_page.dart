import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive_animation/alert_dialog/distributor/add_distributor_alert_dialog.dart';
import 'package:rive_animation/alert_dialog/distributor/delete_distributor_dialog.dart';
import 'package:rive_animation/alert_dialog/distributor/view_distributor_dialog.dart';
import 'package:rive_animation/model/course.dart';
import 'package:rive_animation/screens/pages/components/third_course_card.dart';
import 'package:rive_animation/screens/pages/distributor_page/distributor_provider.dart';

class DistributorPage extends ConsumerStatefulWidget {
  const DistributorPage({super.key});

  @override
  ConsumerState<DistributorPage> createState() => _DistributorPageState();
}

class _DistributorPageState extends ConsumerState<DistributorPage>{
  Set<String> selectedDistributors = {};
  bool isSelectionMode = false;

  void toggleSelection(String id) {
    setState(() {
        if (selectedDistributors.contains(id)) {
          selectedDistributors.remove(id);
        } else {
          selectedDistributors.add(id);
        }
        isSelectionMode = selectedDistributors.isNotEmpty;
      });
  }

  Future<void> deleteSelected() async {
    if (selectedDistributors.isNotEmpty) {
        ref.read(loadingProvider.notifier).state = true;
        await ref.read(distributorProvider.notifier).deleteDistributors(selectedDistributors.toList());
        selectedDistributors.clear();
        isSelectionMode = false;
        ref.read(loadingProvider.notifier).state = false;
        setState(() {});
      }
  }

  @override
  Widget build(BuildContext context) {
    final distributors = ref.watch(distributorProvider);
    final isLoading = ref.watch(loadingProvider);

    Future<void> _refreshDistributors() async {
      setState(() {
        selectedDistributors.clear();
        isSelectionMode = false;
      });
      ref.read(loadingProvider.notifier).state = true;
      await ref.read(distributorProvider.notifier).fetchAllDistributors();
      ref.read(loadingProvider.notifier).state = false;
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog<Course>(
            context: context,
            builder: (BuildContext context) => const AddDistributor(),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text(
                        "Distributor",
                        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const Spacer(),
                      if (!isSelectionMode &&
                          (kIsWeb ||
                              Theme.of(context).platform == TargetPlatform.macOS ||
                              Theme.of(context).platform == TargetPlatform.windows ||
                              Theme.of(context).platform == TargetPlatform.linux))
                        IconButton(
                          onPressed: _refreshDistributors,
                          icon: const Icon(Icons.refresh),
                        ),
                    ],
                  ),

                  // Show Delete and Deselect vertically if in selection mode
                  if (isSelectionMode) ...[
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => DeleteDistributorDialog(
                            distributorIds: selectedDistributors.toList(),
                          ),
                        ).then((_) {
                          setState(() {
                            selectedDistributors.clear();
                            isSelectionMode = false;
                          });
                          ref.read(distributorProvider.notifier).fetchAllDistributors();
                        });
                      },
                      icon: const Icon(Icons.delete, color: Colors.white),
                      label: const Text("Delete Selected", style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          selectedDistributors.clear(); // ✅ Deselect All
                          isSelectionMode = false;
                        });
                      },
                      icon: const Icon(Icons.cancel, color: Colors.white),
                      label: const Text("Deselect All", style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    ),
                  ],
                ],
              ),
            ),

            // Mobile Pull to Refresh and Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshDistributors,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        child: IntrinsicHeight(
                          child: Column(
                            children: [
                              if (isLoading)
                                const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(20),
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              else if (distributors.isEmpty)
                                const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Text("No distributors found."),
                                  ),
                                )
                              else
                                Column(
                                children: distributors.map((distributor) => Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  child: GestureDetector(
                                    onLongPress: () {
                                      HapticFeedback.mediumImpact(); // ✅ Haptic feedback on long press
                                      toggleSelection(distributor.id.toString());
                                    },
                                    onTap: isSelectionMode
                                        ? () => toggleSelection(distributor.id.toString())
                                        : () async {
                                            final distributorDetails = await ref
                                                .read(distributorProvider.notifier)
                                                .fetchDistributorById(distributor.id.toString());

                                            if (distributorDetails != null) {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return DistributorDetailsDialog(
                                                    distributorId: distributorDetails['distributorId'].toString(),
                                                    distributorName: distributorDetails['distributorName'] ?? 'Unknown',
                                                    distributorEmail: distributorDetails['distributorEmail'] ?? 'No email provided',
                                                    distributorPhone: distributorDetails['distributorPhone'] ?? 'No phone provided',
                                                    ecommerceLink: distributorDetails['distributorEcommerceLink'] ?? 'No link provided',
                                                  );
                                                },
                                              );
                                            } else {
                                              debugPrint("❌ Failed to fetch distributor details");
                                            }
                                          },
                                    child: Animate(
                                      effects: selectedDistributors.contains(distributor.id.toString())
                                          ? [ShakeEffect(duration: 300.ms, hz: 4)] // ✅ Shake when selected
                                          : [],
                                      child: AnimatedScale(
                                        scale: selectedDistributors.contains(distributor.id.toString()) ? 0.95 : 1.0,
                                        duration: const Duration(milliseconds: 200),
                                        curve: Curves.easeInOut,
                                        child: Stack(
                                          children: [
                                            ThirdCourseCard(
                                              title: distributor.title,
                                              description: distributor.description,
                                              colorl: distributor.color,
                                            ),
                                            if (isSelectionMode)
                                              Positioned(
                                                right: 8,
                                                top: 8,
                                                child: Checkbox(
                                                  value: selectedDistributors.contains(distributor.id.toString()),
                                                  onChanged: (_) => toggleSelection(distributor.id.toString()),
                                                  activeColor: Colors.red,
                                                  checkColor: Colors.white,
                                                ),
                                              ),
                                            // Optional: Slight overlay when selected
                                            if (selectedDistributors.contains(distributor.id.toString()))
                                              Positioned.fill(
                                                child: Container(
                                                  color: Colors.black.withOpacity(0.05),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
