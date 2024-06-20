import 'package:flutter/material.dart';

class InstructionWidgetController {
  final instructionController = TextEditingController();

  String getInstruction() => instructionController.text;
}

class DynamicInstructionWidget extends StatefulWidget {
  final InstructionWidgetController controller;

  const DynamicInstructionWidget({super.key, required this.controller});

  @override
  State<DynamicInstructionWidget> createState() => _DynamicInstructionWidgetState();
}

class _DynamicInstructionWidgetState extends State<DynamicInstructionWidget> {

  @override
  Widget build(BuildContext build) {
    return Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            controller: widget.controller.instructionController,
          ),
          const SizedBox(height: 8.0),
        ],
    );
  }
}

