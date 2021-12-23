import 'package:get/get.dart';
import 'package:vam_algorithm/views/enter_numbers_page.dart';
import 'package:vam_algorithm/views/see_result_page.dart';

class VamController extends GetxController {
  var calculateLoading = false.obs;
  var rowDropdownValue = 3.obs;
  var colDropdownValue = 3.obs;
  int total_cost = 0;
  int NRows = 4;
  int NCols = 5;
  int intMax = 2147483647;
  int intMin = -2147483648;
  List<int> supply = [50, 60, 50, 50];
  List<int> demand = [30, 20, 70, 30, 60];
  List costs = [
    [16, 16, 13, 22, 17],
    [14, 14, 13, 19, 15],
    [19, 19, 20, 23, 50],
    [50, 12, 50, 15, 11],
  ];
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

  void maxPenalty(int len1, int len2, bool is_row, List res) {
    int i, pc = -1, pm = -1, mc = -1, md = intMin;
    List res2 = List<int>(3);

    for (i = 0; i < len1; ++i) {
      if ((is_row) ? rowDone[i] : colDone[i]) continue;
      diff(i, len2, is_row, res2);
      if (res2[0] > md) {
        md = res2[0]; /* max diff */
        pm = i; /* pos of max diff */
        mc = res2[1]; /* min cost */
        pc = res2[2]; /* pos of min cost */
      }
    }

    if (is_row) {
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
    List res1 = List<int>(NRows);
    List res2 = List<int>(NRows);
    maxPenalty(NRows, NCols, true, res1);
    maxPenalty(NCols, NRows, false, res2);

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
    int i, j, r, c, q, supply_left = 0;
    List cell = List<int>(4);
    List results = [
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
    ];

    for (i = 0; i < NRows; ++i) {
      supply_left += supply[i];
    }
    while (supply_left > 0) {
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
      supply_left -= q;
      total_cost += q * costs[r][c];
    }

    print("    A   B   C   D   E\n");
    for (i = 0; i < NRows; ++i) {
      print('W $i');
      for (j = 0; j < NCols; ++j) {
        print("  ${results[i][j]}");
      }
      print("\n");
    }
    print("\nTotal cost = $total_cost\n");
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

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    rowDone = List.filled(NRows, false);
    colDone = List.filled(NCols, false);
  }
}
