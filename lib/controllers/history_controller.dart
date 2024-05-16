import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HistoryController extends GetxController {
  RxList<Map<String, dynamic>> history = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  fetchHistory() {
    final historyBox = GetStorage('history');
    history.value =
        List<Map<String, dynamic>>.from(historyBox.getValues() ?? []);
  }

  Future<void> clearHistory() async {
    final historyBox = GetStorage('history');
    await historyBox.erase();
    fetchHistory();
  }
}
