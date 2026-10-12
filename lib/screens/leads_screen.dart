import 'package:flutter/material.dart';
import '../models/lead.dart';
import '../services/api_client.dart';
import '../services/lead_service.dart';
import 'lead_detail_screen.dart';

class LeadsScreen extends StatelessWidget {
  const LeadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Leads'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'My enquiries'),
              Tab(text: 'Assigned to me'),
              Tab(text: 'All leads'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _LeadList(filter: _LeadFilter.mine),
            _LeadList(filter: _LeadFilter.assigned),
            _LeadList(filter: _LeadFilter.all),
          ],
        ),
      ),
    );
  }
}

enum _LeadFilter { mine, assigned, all }

class _LeadList extends StatefulWidget {
  final _LeadFilter filter;

  const _LeadList({required this.filter});

  @override
  State<_LeadList> createState() => _LeadListState();
}

class _LeadListState extends State<_LeadList> {
  final LeadService _leads = LeadService();

  late Future<List<Lead>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<Lead>> _load() async {
    if (widget.filter == _LeadFilter.all) {
      return _leads.getAllLeads();
    }

    final userId = await ApiClient.instance.getCurrentUserId();
    if (userId == null) {
      throw Exception('Please log in to view your leads');
    }

    return widget.filter == _LeadFilter.mine
        ? _leads.getLeadsByCustomer(userId)
        : _leads.getLeadsByEmployee(userId);
  }

  Future<void> _refresh() async {
    final next = _load();
    setState(() => _future = next);

    try {
      await next;
    } catch (_) {}
  }

  Future<void> _open(Lead lead) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LeadDetailScreen(leadId: lead.id!),
      ),
    );

    if (!mounted) return;
    await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Lead>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Could not load leads\n${snapshot.error}',
                    textAlign: TextAlign.center),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _refresh,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final leads = snapshot.data ?? [];

        return RefreshIndicator(
          onRefresh: _refresh,
          child: leads.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 200),
                    Center(child: Text('No leads found')),
                  ],
                )
              : ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: leads.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final lead = leads[index];

                    return ListTile(
                      leading: const Icon(Icons.assignment),
                      title: Text(
                        'Lead #${lead.id} · Property #${lead.propertyId}',
                      ),
                      subtitle: Text(
                        lead.message ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Chip(label: Text(lead.status ?? '-')),
                      onTap: lead.id == null ? null : () => _open(lead),
                    );
                  },
                ),
        );
      },
    );
  }
}
