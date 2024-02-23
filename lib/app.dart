import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tweet/core/api_services/local_db/shared_prefs_manager.dart';
import 'package:flutter_tweet/features/onboarding/ui/onboarding_screen.dart';
import 'package:flutter_tweet/features/tweet/ui/tweets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DecidePage extends StatefulWidget {
  static StreamController<String> authStream = StreamController.broadcast();

  const DecidePage({super.key});

  @override
  State<DecidePage> createState() => _DecidePageState();
}

class _DecidePageState extends State<DecidePage> {
  @override
  void initState() {
    super.initState();
  }

  getUid() async {
    String uid = SharedPrefrencesManager.getUid();
    if (uid.isEmpty) {
      DecidePage.authStream.add("");
    } else {
      DecidePage.authStream.add(uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
        stream: DecidePage.authStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data == null || (snapshot.data?.isEmpty ?? true)) {
            return OnboardinScreen();
          } else {
            return TweetsPage();
          }
        });
  }
}
