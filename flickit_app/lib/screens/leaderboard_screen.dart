import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/leaderboard_provider.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final leaderboardProvider =
          Provider.of<LeaderboardProvider>(context, listen: false);
      leaderboardProvider.fetchLeaderboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final leaderboardProvider = Provider.of<LeaderboardProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Leaderboard',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: leaderboardProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : leaderboardProvider.leaderboard.isEmpty
              ? const Center(
                  child: Text('No leaderboard data available'),
                )
              : ListView.builder(
                  itemCount: leaderboardProvider.leaderboard.length,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemBuilder: (ctx, index) {
                    final user = leaderboardProvider.leaderboard[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Colors.grey.shade200,
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: index == 0
                                  ? Colors.amber
                                  : index == 1
                                      ? Colors.grey
                                      : index == 2
                                          ? Colors.brown
                                          : Colors.blueGrey,
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user['username'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Total Count: ${user['totalCount']}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.emoji_events,
                              color: Colors.orangeAccent,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
