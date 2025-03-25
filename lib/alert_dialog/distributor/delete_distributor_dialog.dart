import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../screens/pages/distributor_page/distributor_provider.dart';

class DeleteDistributorDialog extends ConsumerStatefulWidget {
  final String distributorId;
  const DeleteDistributorDialog({super.key, required this.distributorId});

  @override
  ConsumerState<DeleteDistributorDialog> createState() => _DeleteDistributorDialogState();
}

class _DeleteDistributorDialogState extends ConsumerState<DeleteDistributorDialog> {
  bool _isLoading = false;

  Future<void> _deleteDistributor() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(distributorProvider.notifier).deleteDistributor(widget.distributorId);
      if (mounted) {
        Navigator.popUntil(context, (route) => route.isFirst);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Distributor deleted successfully!')),
        );
      }
    } catch (e) {
      debugPrint("Delete request error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete distributor: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Konfirmasi Penghapusan"),
      content: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : const Text("Apakah Anda yakin ingin menghapus distributor?"),
      actions: _isLoading
          ? []
          : [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: _deleteDistributor,
                child: const Text("Hapus"),
              ),
            ],
    );
  }
}
