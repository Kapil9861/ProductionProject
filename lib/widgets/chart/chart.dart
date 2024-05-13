import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:sajilo_hisab/widgets/chart/chart_bar.dart';

class Chart extends StatelessWidget {
  const Chart({
    super.key,
    required this.playerNames,
    required this.individualWinPoints,
  });

  final List<String> playerNames;
  final LinkedHashMap<String, num> individualWinPoints;

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    // Calculate max total expense
    num maxTotalExpense =
        individualWinPoints.values.reduce((a, b) => a > b ? a : b);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.3),
            Theme.of(context).colorScheme.primary.withOpacity(0.0)
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final playerName in playerNames)
                  ChartBar(
                    fill: individualWinPoints[playerName] == null
                        ? 0
                        : individualWinPoints[playerName]! / maxTotalExpense,
                  )
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: playerNames
                .map(
                  (playerName) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        playerName.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isDarkMode
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.7),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}
