import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransaction;

  Chart(this.recentTransaction);

  List<Map<String, Object>> get groupedTransactions {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));

      double totalSum = 0.0;

      for (var i = 0; i < recentTransaction.length; i++) {
        bool someDay = recentTransaction[i].date.day == weekDay.day;
        bool someMonth = recentTransaction[i].date.month == weekDay.month;
        bool someYear = recentTransaction[i].date.year == weekDay.year;

        if (someDay && someMonth && someYear) {
          totalSum += recentTransaction[i].value;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay)[0],
        'value': totalSum,
      };
    }).reversed.toList();
  }

  double get weekTotalValue {
    return groupedTransactions.fold(0.0, (acc, item) => acc + item['value']);
  }

  @override
  Widget build(BuildContext context) {
    groupedTransactions;
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ...groupedTransactions.map((transaction) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                  label: transaction['day'],
                  value: transaction['value'],
                  percentage: (transaction['value'] as double) / weekTotalValue,
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
