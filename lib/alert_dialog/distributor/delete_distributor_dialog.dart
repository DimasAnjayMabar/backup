import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../screens/pages/distributor_page/distributor_provider.dart';

class DeleteDistributorDialog extends ConsumerStatefulWidget {
  final List<String> distributorIds; // Now accepts a list of IDs
  const DeleteDistributorDialog({super.key, required this.distributorIds});

  @override
  ConsumerState<DeleteDistributorDialog> createState() => _DeleteDistributorDialogState();
}

class _DeleteDistributorDialogState extends ConsumerState<DeleteDistributorDialog> {
  bool _isLoading = false;

  Future<void> _deleteDistributors() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(distributorProvider.notifier).deleteDistributors(widget.distributorIds);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.distributorIds.length} distributor(s) deleted successfully!')),
        );
      }
    } catch (e) {
      debugPrint("Delete request error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete distributor(s): $e')),
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
          : Text("Apakah Anda yakin ingin menghapus ${widget.distributorIds.length} distributor?"),
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
                onPressed: _deleteDistributors,
                child: const Text("Hapus"),
              ),
            ],
    );
  }
}
