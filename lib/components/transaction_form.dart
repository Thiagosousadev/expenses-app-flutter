import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionForm extends StatefulWidget {
  final void Function(String, double) onSubmit;

  TransactionForm(this.onSubmit);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _titleController = TextEditingController();
  final _valueController = TextEditingController();
  DateTime selectedDate;

  void _submitForm() {
    final title = _titleController.text;
    final value = double.parse(_valueController.text) ?? 0.0;

    if (title.isEmpty || value <= 0) {
      return;
    }

    widget.onSubmit(title, value);
  }

  void _showDatePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime.now(),
    );

    setState(() => selectedDate = pickedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              onSubmitted: (_) => _submitForm(),
              decoration: InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: _valueController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onSubmitted: (_) => _submitForm(),
              decoration: InputDecoration(labelText: 'R\$ Valor'),
            ),
            Container(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedDate == null
                        ? DateFormat('dd/MM/y').format(DateTime.now())
                        : DateFormat('dd/MM/y').format(selectedDate),
                  ),
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: Text('Selecione a data'),
                    onPressed: () => _showDatePicker(),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RaisedButton(
                    textColor: Theme.of(context).textTheme.button.color,
                    color: Theme.of(context).primaryColor,
                    child: Text('Nova Transação'),
                    onPressed: _submitForm),
              ],
            )
          ],
        ),
      ),
    );
  }
}
