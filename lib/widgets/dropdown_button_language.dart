import 'package:flutter/material.dart';
import 'package:rider_register/main.dart';
import 'package:rider_register/models/language.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Language> list = [
  Language(name: "Malagasy", code: "id"),
  Language(name: "English", code: "en"),
  Language(name: "Français", code: "fr"),
];

class DropdownButtonLanguage extends StatefulWidget {
  const DropdownButtonLanguage({super.key});

  @override
  State<DropdownButtonLanguage> createState() => _DropdownButtonLanguageState();
}

class _DropdownButtonLanguageState extends State<DropdownButtonLanguage> {
  Language _dropdownValue = list[0];

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    String locale = prefs.getString('locale') ?? "en";
    for (var i = 0; i < list.length; i++) {
      if (list[i].code == locale) {
        setState(() {
          _dropdownValue = list[i];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Language>(
      value: _dropdownValue,
      onChanged: (Language? value) {
        setState(() {
          _dropdownValue = value!;
        });
        if (value != null) MyApp.setLocale(context, Locale(value.code));
      },
      items: list.map<DropdownMenuItem<Language>>((Language value) {
        return DropdownMenuItem<Language>(
          value: value,
          child: Text(value.name),
        );
      }).toList(),
    );
  }
}
