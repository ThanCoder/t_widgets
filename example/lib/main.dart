// ignore_for_file: unused_import, avoid_print, unused_local_variable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

final appDarkThemeNotifier = ValueNotifier<bool>(false);

void main() async {
  runApp(MaterialApp(home: Scaffold(body: const MyApp())));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final url =
      'https://help.imgur.com/hc/article_attachments/26512175039515?utm_source=chatgpt.com';

  @override
  Widget build(BuildContext context) {
    return TMaterialThemeProvider(
      getTheme: () => .system,
      onChanged: (type) {
        print('changed : $type');
      },
      child: body(),
    );
  }

  Scaffold body() {
    return Scaffold(
      appBar: AppBar(title: const Text('Plugin example app')),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            TMaterialThemeProviderChooser(),
            TSortProviderButton(
              value: .dateTSortItem,
              list: [.nameTSortItem, .dateTSortItem],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async {}),
    );
  }
}
