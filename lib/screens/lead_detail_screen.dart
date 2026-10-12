import 'package:flutter/material.dart';
import '../models/lead.dart';
import '../models/lead_activity.dart';
import '../services/api_client.dart';
import '../services/lead_service.dart';

class LeadDetailScreen extends StatefulWidget {
  final int leadId;

  const LeadDetailScreen({
    super.key,
    required this.leadId,
  });

  @override
  State<LeadDetailScreen> createState() => _LeadDetailScreenState();
}

class _LeadDetailScreenState extends State<LeadDetailScreen> {
  final LeadService _leads = LeadService();

  Lead? _lead;
  List<LeadActivity> _activities = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final lead = await _leads.getLeadById(widget.leadId);
      final activities = await _leads.getLeadActivities(widget.leadId);

      if (!mounted) return;
      setState(() {
        _lead = lead;
        _activities = activities;
        _loading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = ApiClient.errorMessage(e);
      });
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<String?> _askText(
    String title, {
    String? initial,
    TextInputType? keyboardType,
  }) async {
    final controller = TextEditingController(text: initial);

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: keyboardType,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    controller.dispose();

    return (result == null || result.isEmpty) ? null : result;
  }

  Future<void> _changeStatus() async {
    final status = await _askText(
      'Update status',
      initial: _lead?.status,
    );
    if (status == null) return;

    try {
      final userId = await ApiClient.instance.getCurrentUserId();
      await _leads.updateLeadStatus(
        widget.leadId,
        status,
        actingUserId: userId,
      );
      await _load();
    } catch (e) {
      _showMessage('Could not update status: ${ApiClient.errorMessage(e)}');
    }
  }

  Future<void> _assign() async {
    final value = await _askText(
      'Assign to employee ID',
      initial: _lead?.assignedTo?.toString(),
      keyboardType: TextInputType.number,
    );
    if (value == null) return;

    final employeeId = int.tryParse(value);
    if (employeeId == null) {
      _showMessage('Employee ID must be a number');
      return;
    }

    try {
      final userId = await ApiClient.instance.getCurrentUserId();
      await _leads.assignLead(
        widget.leadId,
        employeeId,
        actingUserId: userId,
      );
      await _load();
    } catch (e) {
      _showMessage('Could not assign lead: ${ApiClient.errorMessage(e)}');
    }
  }

  Widget _row(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value ?? '-')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lead = _lead;

    return Scaffold(
      appBar: AppBar(
        title: Text('Lead #${widget.leadId}'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : lead == null
              ? Center(child: Text(_error ?? 'Lead not found'))
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _row('Status', lead.status),
                      _row('Property', '#${lead.propertyId ?? '-'}'),
                      _row('Customer', '#${lead.customerId ?? '-'}'),
                      _row(
                        'Assigned to',
                        lead.assignedTo == null
                            ? 'Unassigned'
                            : '#${lead.assignedTo}',
                      ),
                      _row('Source', lead.source),
                      _row('Message', lead.message),
                      _row('Created', lead.createdAt),
                      _row('Updated', lead.updatedAt),

                      const SizedBox(height: 12),

                      Wrap(
                        spacing: 12,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _changeStatus,
                            icon: const Icon(Icons.flag),
                            label: const Text('Update status'),
                          ),
                          ElevatedButton.icon(
                            onPressed: _assign,
                            icon: const Icon(Icons.person_add),
                            label: const Text('Assign'),
                          ),
                        ],
                      ),

                      const Divider(height: 32),

                      const Text(
                        'Activity',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      if (_activities.isEmpty)
                        const Text('No activity yet.')
                      else
                        ..._activities.map(
                          (a) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.history),
                            title: Text(a.activityType ?? 'Activity'),
                            subtitle: Text(
                              [
                                if (a.description != null) a.description!,
                                if (a.userId != null) 'By user #${a.userId}',
                                if (a.createdAt != null) a.createdAt!,
                              ].join('\n'),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
    );
  }
}
