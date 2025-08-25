import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AIReportPage extends StatefulWidget {
  const AIReportPage({super.key});

  @override
  State<AIReportPage> createState() => _AIReportPageState();
}

class _AIReportPageState extends State<AIReportPage> {
  final TextEditingController _controller = TextEditingController();
  String? _aiReport;
  List<Map<String, dynamic>> _history = [];
  int? _expandedIndex; // track which report is expanded

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyString = prefs.getString('ai_report_history');
    if (historyString != null) {
      setState(() {
        _history = List<Map<String, dynamic>>.from(json.decode(historyString));
      });
    }
  }

  Future<void> _saveHistory(String notes, String aiSummary) async {
    final prefs = await SharedPreferences.getInstance();
    final newReport = {
      'timestamp': DateTime.now().toString(),
      'notes': notes,
      'aiSummary': aiSummary,
    };
    setState(() {
      _history.insert(0, newReport);
    });
    await prefs.setString('ai_report_history', json.encode(_history));
  }

  Future<void> _generateReport() async {
    final notes = _controller.text.trim();
    if (notes.isEmpty) return;

    setState(() {
      _aiReport = "Generating report...";
    });

    try {
      final response = await http.post(
        Uri.parse("https://openrouter.ai/api/v1/chat/completions"),
        headers: {
          "Authorization":
              "Bearer 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",
          "Content-Type": "application/json",
        },
        body: json.encode({
          "model": "openai/gpt-4o-mini",
          "messages": [
            {
              "role": "system",
              "content":
                  "You are a medical AI assistant. Generate a concise emergency report with summary and best practices.",
            },
            {"role": "user", "content": notes},
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final aiSummary =
            data['choices'][0]['message']['content'] ?? "No response";

        setState(() {
          _aiReport = aiSummary;
        });

        await _saveHistory(notes, aiSummary);
      } else {
        setState(() {
          _aiReport = "Error: ${response.body}";
        });
      }
    } catch (e) {
      setState(() {
        _aiReport = "Failed to connect to AI: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Medical Report"),
        backgroundColor: Colors.red.shade700,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.grey.shade100,
                builder: (_) => _buildHistory(),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText:
                    "Enter patient condition (e.g., blood loss, fracture)...",
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _generateReport,
              child: const Text(
                "Generate AI Report",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            if (_aiReport != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Card(
                    elevation: 5,
                    margin: const EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.red.shade300, width: 1.2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        _aiReport!,
                        style: const TextStyle(fontSize: 16, height: 1.4),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red.shade700,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          setState(() {
            _controller.clear();
            _aiReport = null;
          });
        },
      ),
    );
  }

  Widget _buildHistory() {
    return StatefulBuilder(
      builder: (context, setModalState) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.8,
          child: ListView.builder(
            itemCount: _history.length,
            itemBuilder: (context, index) {
              final report = _history[index];
              final isExpanded = _expandedIndex == index;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 3,
                color: Colors.white,
                child: ExpansionTile(
                  key: Key(index.toString()),
                  initiallyExpanded: isExpanded,
                  collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  iconColor: Colors.red.shade600,
                  collapsedIconColor: Colors.red.shade400,
                  title: Text(
                    report['aiSummary'].toString().split('\n').first,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(14),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "📝 Notes: ${report['notes']}",
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "📄 Full Report:\n${report['aiSummary']}",
                            style: const TextStyle(fontSize: 14, height: 1.4),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "⏰ Time: ${report['timestamp']}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onExpansionChanged: (expanded) {
                    setModalState(() {
                      _expandedIndex = expanded ? index : null;
                    });
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
