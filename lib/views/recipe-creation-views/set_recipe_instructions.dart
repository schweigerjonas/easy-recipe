import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/creation_model.dart';
import '../../widgets/dynamic_instruction_widget.dart';

class SetRecipeInstructions extends StatefulWidget {
  const SetRecipeInstructions({super.key});

  @override
  State<SetRecipeInstructions> createState() => _SetRecipeInstructionsState();
}

class _SetRecipeInstructionsState extends State<SetRecipeInstructions> {
  late List<DynamicInstructionWidget> container;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String instructions = "";

  String setInstructions() {
    final buffer = StringBuffer();

    buffer.write("<p><ol>");
    for(DynamicInstructionWidget e in container) {
      String inst = e.controller.instructionController.text;
      if (inst.replaceAll(" ", "") != "") buffer.write("<li>$inst</li>");
    }
    buffer.write("</ol></p>");

    return buffer.toString();
  }

  bool checkEmptyInstructions(String inst) {
    final checkBuffer = StringBuffer();
    bool approved = false;


    checkBuffer.write(inst.replaceAll("<p><ol>", "").replaceAll("</ol></p>", "")
        .replaceAll("<li>", "").replaceAll("</li>", "")
        .replaceAll(" ", ""));

    approved = checkBuffer.toString() == "" ? true : false;

    return approved;
  }

  @override
  void initState() {
    super.initState();
    final instructionProvider = Provider.of<CreationModel>(context, listen: false);
    final instructionContainer = instructionProvider.getInstructionWidgets();

    container = instructionContainer;
    if (container.isEmpty) {
      container = [
        DynamicInstructionWidget(controller: InstructionWidgetController()),
        DynamicInstructionWidget(controller: InstructionWidgetController()),
        DynamicInstructionWidget(controller: InstructionWidgetController()),
      ];
    }
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
                  padding: const EdgeInsets.all(8.0),
                  children: List.generate(
                    creation.getIngredients().length,
                    (index) => Text(creation.getIngredients().elementAt(index),
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
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
                            container.insert(
                                container.length,
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
                              container.removeAt(container.length - 1);
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Provider.of<CreationModel>(context, listen: false)
                        .setPageIndex(1);
                  },
                  child: const Text('Back'),
                ),
                Consumer<CreationModel>(
                  builder: (context, creation, _) => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: () {
                      creation.saveInstructionWidgets(container);
                      instructions = setInstructions();
                      creation.setInstructions(instructions);
                      checkEmptyInstructions(instructions) ? ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Input at least one instruction.'),
                          action: SnackBarAction(
                            label: 'Got it!',
                            onPressed: () {
                            },
                          ),
                        ),
                      ) : creation.setPageIndex(3);
                    },
                    child: const Text('Next Step'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
