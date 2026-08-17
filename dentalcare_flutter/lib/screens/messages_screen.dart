import 'package:flutter/material.dart';
import 'package:prima_dental_care/theme/app_theme.dart';
import 'package:prima_dental_care/models/message.dart';
import 'package:prima_dental_care/main.dart';
import 'package:prima_dental_care/widgets/search_header.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});
  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  List<ClinicalNote> _notes = [];
  bool _loading = true;
  String? _error;
  bool _initLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initLoaded) {
      _initLoaded = true;
      _loadNotes();
    }
  }

  Future<void> _loadNotes() async {
    setState(() { _loading = true; _error = null; });
    try {
      final api = AppServices.of(context).api;
      final result = await api.searchNotes(pageSize: 30);
      final searchResult = NoteSearchResult.fromJson(result);
      setState(() { _notes = searchResult.notes; _loading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SearchHeader(hint: 'Search notes...'),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Clinical Notes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                if (!_loading)
                  Text('${_notes.length} notes', style: const TextStyle(fontSize: 13, color: AppColors.textMuted)),
              ]),
            ),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
                      : _notes.isEmpty
                          ? const Center(child: Text('No clinical notes', style: TextStyle(color: AppColors.textMuted)))
                          : ListView.builder(
                              itemCount: _notes.length,
                              itemBuilder: (_, i) {
                                final n = _notes[i];
                                return Card(
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.teal,
                                      child: Text(n.initials,
                                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                                    ),
                                    title: Text(n.userName ?? n.provName ?? 'Unknown',
                                        style: const TextStyle(fontWeight: FontWeight.w600)),
                                    subtitle: Text(n.note ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
                                    trailing: Text(n.commDateTime ?? '',
                                        style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                                  ),
                                );
                              },
                            ),
            ),
          ]),
        ),
      ),
    );
  }
}
