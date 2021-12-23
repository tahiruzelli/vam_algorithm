import 'package:get/get.dart';
import 'package:vam_algorithm/views/enter_numbers_page.dart';
import 'package:vam_algorithm/views/see_result_page.dart';

class VamController extends GetxController {
  var calculateLoading = false.obs;
  var rowDropdownValue = 3.obs;
  var colDropdownValue = 3.obs;
  int totalCost = 0;
  int intMax = 2147483647;
  int intMin = -2147483648;
  List<int> supply = [100, 10, 50, 50];
  List<int> demand = [30, 20, 70, 30, 60];
  List costs = [
    [16, 16, 13, 22, 17],
    [14, 14, 13, 19, 15],
    [19, 19, 20, 23, 50],
    [50, 12, 50, 15, 11],
  ];
  List tmpCosts = [
    [16, 16, 13, 22, 17],
    [14, 14, 13, 19, 15],
    [19, 19, 20, 23, 50],
    [50, 12, 50, 15, 11],
  ];
  List<int> tmpSupply = [20, 40, 10, 70];
  List<int> tmpDemand = [10, 50, 30, 30, 20];
  List<bool> rowDone;
  List<bool> colDone;
  void diff(int j, int len, bool isRow, List res) {
    int i, c, min1 = intMax, min2 = min1, minP = -1;
    for (i = 0; i < len; ++i) {
      if ((isRow) ? colDone[i] : rowDone[i]) continue;
      c = (isRow) ? costs[j][i] : costs[i][j];
      if (c < min1) {
        min2 = min1;
        min1 = c;
        minP = i;
      } else if (c < min2) {
        min2 = c;
      }
    }
    res[0] = min2 - min1;
    res[1] = min1;
    res[2] = minP;
  }

  void maxPenalty(int len1, int len2, bool isRow, List res) {
    int i, pc = -1, pm = -1, mc = -1, md = intMin;
    List res2 = List<int>(3);

    for (i = 0; i < len1; ++i) {
      if ((isRow) ? rowDone[i] : colDone[i]) continue;
      diff(i, len2, isRow, res2);
      if (res2[0] > md) {
        md = res2[0]; /* max diff */
        pm = i; /* pos of max diff */
        mc = res2[1]; /* min cost */
        pc = res2[2]; /* pos of min cost */
      }
    }

    if (isRow) {
      res[0] = pm;
      res[1] = pc;
    } else {
      res[0] = pc;
      res[1] = pm;
    }
    res[2] = mc;
    res[3] = md;
  }

  void nextCell(List res) {
    int i;
    List res1 = List<int>(rowDropdownValue.value);
    List res2 = List<int>(rowDropdownValue.value);
    maxPenalty(rowDropdownValue.value, colDropdownValue.value, true, res1);
    maxPenalty(colDropdownValue.value, rowDropdownValue.value, false, res2);

    if (res1[3] == res2[3]) {
      if (res1[2] < res2[2]) {
        for (i = 0; i < 4; ++i) {
          res[i] = res1[i];
        }
      } else {
        for (i = 0; i < 4; ++i) {
          res[i] = res2[i];
        }
      }
      return;
    }
    if (res1[3] > res2[3]) {
      for (i = 0; i < 4; ++i) {
        res[i] = res2[i];
      }
    } else {
      for (i = 0; i < 4; ++i) {
        res[i] = res1[i];
      }
    }
  }

  void calculate() {
    costs = tmpCosts;
    supply = tmpSupply;
    demand = tmpDemand;
    rowDone = List.filled(rowDropdownValue.value, false);
    colDone = List.filled(colDropdownValue.value, false);
    int i, r, c, q, supplyLeft = 0;
    List cell = List<int>(rowDropdownValue.value);
    List results = [];
    for (var i = 0; i < rowDropdownValue.value; i++) {
      List<int> list = new List<int>();

      for (var j = 0; j < colDropdownValue.value; j++) {
        list.add(j);
      }

      results.add(list);
    }

    for (i = 0; i < rowDropdownValue.value; ++i) {
      supplyLeft += supply[i];
    }
    while (supplyLeft > 0) {
      nextCell(cell);
      r = cell[0];
      c = cell[1];
      q = (demand[c] <= supply[r]) ? demand[c] : supply[r];
      demand[c] -= q;
      if (demand[c] == 0) {
        colDone[c] = true;
      }
      supply[r] -= q;
      if (supply[r] == 0) {
        rowDone[r] = true;
      }
      results[r][c] = q;
      supplyLeft -= q;
      totalCost += q * costs[r][c];
    }
    print("Total cost = $totalCost");
  }

  void onCalculateButtonPressed() {
    Get.off(SeeResultPage());
    calculateLoading.value = true;

    calculate();
    Future.delayed(const Duration(seconds: 2)).then((value) {
      calculateLoading.value = false;
    });
  }

  void onNewCalculateButtonPressed() {
    Get.off(EnterNumbersPage());
  }

  void fillMatrix() {}

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}
