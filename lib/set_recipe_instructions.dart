import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'creation_model.dart';

class SetRecipeInstructions extends StatefulWidget {
  const SetRecipeInstructions({super.key});

 @override
 State<SetRecipeInstructions> createState() => _SetRecipeInstructionsState();
}

class _SetRecipeInstructionsState extends State<SetRecipeInstructions> {

  @override
  Widget build(BuildContext build) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: ListView(
        children: [
          const SizedBox(height: 24.0),
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
    );
  }
}