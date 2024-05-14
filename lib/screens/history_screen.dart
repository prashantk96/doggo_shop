import 'dart:developer';

import 'package:doggo_shop/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final historyBox = GetStorage('history');
    log(historyBox.getValues().toString());

    //historyBox.getValues() fetches values from historyBox and then List<Map<String, dynamic>>.from() creates new list and store it in history variable
    RxList<Map<String, dynamic>> history =
        List<Map<String, dynamic>>.from(historyBox.getValues() ?? []).obs;
    log('breeds: ${history.toString()}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: Column(
        children: [
          Obx(() {
            return SizedBox(
                height: mq.height * 0.8,
                child: ListView.builder(
                  physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final item = history[index];
                    return ListTile(
                      leading: Image.network(
                        item['imageUrl'],
                        width: 50,
                        height: 50,
                      ),
                      title: Text('Price: ₹${item['price']}'),
                    );
                  },
                ));
          }),
          Flexible(
              child: ElevatedButton(
                  onPressed: () async {
                    //removes history container and then set history value to empty list
                    historyBox.erase().then(
                      (value) {
                        history.value = [];
                      },
                    );
                  },
                  child: const Text('clear history')))
        ],
      ),
    );
  }
}
