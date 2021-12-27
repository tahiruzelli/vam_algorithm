import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vam_algorithm/core/vam_controller.dart';

class EnterNumbersPage extends StatefulWidget {
  @override
  _EnterNumbersPage createState() => _EnterNumbersPage();
}

class _EnterNumbersPage extends State<EnterNumbersPage> {
  VamController vamController = Get.put(VamController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          vamController.onCalculateButtonPressed();
        },
        label: const Text(
          'Calculate!',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text(
          'Enter Matrix',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            row('Column Size', vamController.colDropdownValue),
            row('Row Size', vamController.rowDropdownValue),
            matrixWidget,
            askSupply('Supply  '),
            askDemand('Demand'),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget askDemand(title) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SizedBox(
          height: 50,
          width: Get.width - 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Expanded(
                child: SizedBox(
                  child: ListView.builder(
                    itemCount: 10,
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SizedBox(
                          height: 50,
                          width: (Get.width - 80) /
                              vamController.colDropdownValue.value,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6.0),
                            child: TextField(
                              maxLength: 2,
                              textAlign: TextAlign.center,
                              textAlignVertical: TextAlignVertical.top,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                if (!value.isNum) {
                                  Get.snackbar(
                                      'Error', 'You must enter numbers!');
                                } else {
                                  vamController.tmpDemand[index] =
                                      int.parse(value);
                                }
                              },
                              decoration: const InputDecoration(
                                counterText: '',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.teal),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget askSupply(title) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SizedBox(
          height: 50,
          width: Get.width - 32,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Expanded(
                child: SizedBox(
                  child: ListView.builder(
                    itemCount: 10,
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SizedBox(
                          height: 50,
                          width: (Get.width - 100) /
                              vamController.rowDropdownValue.value,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextField(
                              maxLength: 2,
                              textAlign: TextAlign.center,
                              textAlignVertical: TextAlignVertical.top,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                if (!value.isNum) {
                                  Get.snackbar(
                                      'Error', 'You must enter numbers!');
                                } else {
                                  vamController.tmpSupply[index] =
                                      int.parse(value);
                                }
                              },
                              decoration: const InputDecoration(
                                counterText: '',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.teal),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded get matrixWidget {
    return Expanded(
      child: SizedBox(
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: vamController.rowDropdownValue.value,
          itemBuilder: (context, x) {
            return SizedBox(
              height: 50,
              width: Get.width,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: vamController.colDropdownValue.value,
                itemBuilder: (context, y) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: SizedBox(
                      height: 50,
                      width: Get.width / vamController.colDropdownValue.value,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextField(
                          maxLength: 2,
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.top,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            if (!value.isNum) {
                              Get.snackbar('Error', 'You must enter numbers!');
                            } else {
                              vamController.tmpCosts[x][y] = int.parse(value);
                            }
                          },
                          decoration: const InputDecoration(
                            counterText: '',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.teal),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Card row(String title, RxInt value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            askRowDropDown(value),
          ],
        ),
      ),
    );
  }

  DropdownButton askRowDropDown(RxInt value) {
    return DropdownButton<int>(
      value: value.value,
      icon: const Icon(
        Icons.arrow_downward,
        size: 15,
      ),
      elevation: 16,
      style: const TextStyle(color: Colors.cyan),
      underline: Container(
        height: 2,
        color: Colors.cyan,
      ),
      onChanged: (newValue) {
        value.value = newValue;
      },
      items: <int>[3, 4, 5].map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(value.toString()),
          ),
        );
      }).toList(),
    );
  }
}
