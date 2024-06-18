import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'creation_model.dart';
import 'dynamic_instruction_widget.dart';

class SetRecipeInstructions extends StatefulWidget {
  const SetRecipeInstructions({super.key});

  @override
  State<SetRecipeInstructions> createState() => _SetRecipeInstructionsState();
}

class _SetRecipeInstructionsState extends State<SetRecipeInstructions> {
  String instructions = "";
  List<DynamicInstructionWidget> container = [
    DynamicInstructionWidget(controller: InstructionWidgetController()),
    DynamicInstructionWidget(controller: InstructionWidgetController()),
    DynamicInstructionWidget(controller: InstructionWidgetController()),
  ];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String setInstructions() {
    String instructionText = "";

    // TODO

    return instructionText;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Column(
          children: [
            const SizedBox(
              height: 64.0,
              child: DrawerHeader(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Your Ingredients',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Consumer<CreationModel>(builder: (context, creation, _) {
                return ListView(
                  padding: EdgeInsets.zero,
                  children: const [
                    // TODO
                  ],
                );
              }),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: 16.0, horizontal: ((size.width / 64) * 2)),
        child: Column(
          children: [
            const Text(
              'Instructions',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            const SizedBox(width: 32.0),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Builder(
                        builder: (context) {
                          return ElevatedButton(
                            child: const Icon(Icons.shopping_basket),
                            onPressed: () {
                              _scaffoldKey.currentState?.openDrawer();
                            },
                          );
                        },
                      ),
                      const SizedBox(width: 8.0),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            container.insert(0,
                                DynamicInstructionWidget(
                                    controller: InstructionWidgetController()));
                          });
                        },
                        child: const Text('Add Instruction'),
                      ),
                      const SizedBox(width: 8.0),
                      ElevatedButton(
                        onPressed: () {
                          if (container.isNotEmpty) {
                            setState(() {
                              container.removeAt(0);
                            });
                          }
                        },
                        child: const Icon(Icons.delete),
                      )
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Column(
                    children: container,
                  ),
                  const SizedBox(height: 8.0),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Provider.of<CreationModel>(context, listen: false)
                        .setPageIndex(1);
                  },
                  child: const Text('Back'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Provider.of<CreationModel>(context, listen: false)
                        .setPageIndex(3);
                  },
                  child: const Text('Next Step'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
