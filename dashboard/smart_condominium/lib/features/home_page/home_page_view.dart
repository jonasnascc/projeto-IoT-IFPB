import 'package:flutter/material.dart';

import 'home_page_view_model.dart';

class HomePageView extends HomePageViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: Column(
          children: [
            const Text('test'),
            TextButton(onPressed: () {}, child: const Text('21'))
          ],
        ));
  }
}
