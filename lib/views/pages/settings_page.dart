import 'package:flutter/material.dart';
import 'package:flutter_learning/views/pages/expanded_flexiable_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<SettingsPage> createState() =>
      _SettingsPageState();
}

class _SettingsPageState
    extends State<SettingsPage> {
  TextEditingController controllertext =
      TextEditingController();
  bool? ischecked = false;
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    SnackBar(
                      duration: Duration(
                        seconds: 5,
                      ),
                      content: Text('snackbar'),
                      behavior:
                          SnackBarBehavior
                              .floating,
                    ),
                  );
                },
                child: Text('open snackbar'),
              ),
              Divider(
                color: Colors.teal,
                thickness: 2,
                endIndent: 200,
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          'alert titel',
                        ),
                        content: Text(
                          'alert Content',
                        ),
                        actions: [
                          FilledButton(
                            onPressed: () {
                              Navigator.pop(
                                context,
                              );
                            },
                            child: Text('close'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('open dialog'),
              ),
              TextField(
                controller: controllertext,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                onEditingComplete: () {
                  setState(() {});
                },
              ),
              Text(controllertext.text),
              Checkbox(
                tristate: true,
                value: ischecked,
                onChanged: (bool? value) {
                  setState(() {
                    ischecked = value;
                  });
                },
              ),
              CheckboxListTile(
                tristate: true,
                title: Text('Click me'),
                value: ischecked,
                onChanged: (bool? value) {
                  setState(() {
                    ischecked = value;
                  });
                },
              ),
              Switch(
                value: isSwitched,
                onChanged: (value) {
                  setState(() {
                    isSwitched = value;
                  });
                },
              ),
              SwitchListTile(
                title: Text('ksdfjls'),
                value: isSwitched,
                onChanged: (value) {
                  setState(() {
                    isSwitched = value;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ExpandedFlexiablePage();
                      },
                    ),
                  );
                },
                child: Text(
                  'Show Fleciable and Expanded',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
