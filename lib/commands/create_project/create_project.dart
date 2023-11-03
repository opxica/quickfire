import 'dart:io';

import 'package:args/command_runner.dart';

class CreateProject extends Command {
  // Command details
  @override
  String get name => 'create';

  @override
  String get description => 'Create a new Flutter project.';

  CreateProject() {
    argParser.addFlag('verbose',
        abbr: 'v', help: 'Prints this usage information.', negatable: false);
  }

  // Handle Method
  @override
  Future<void> run() async {
    print('Enter the name of the project:');
    final String projectName = stdin.readLineSync() ?? '';

    if (projectName.isEmpty) {
      print('Project name cannot be empty.');
      return;
    }

    final ProcessResult result = await Process.run(
      'flutter',
      ['create', projectName],
    );

    if (result.exitCode == 0) {
      print('Flutter project $projectName created successfully');
    } else {
      print(
          'Error creating Flutter project. Check the Flutter installation and try again.');
      print(result.stderr);
    }

    // Ask for feature first approach?
    print('Do you want a feature first approach ? (Y/n)');

    // Get user choice for State management
    String stateChoice;
    do {
      stdout.write('Chose your choice "');
      final String stateInput = stdin.readLineSync() ?? '';
      stateChoice = stateInput;
    } while (stateChoice != 'y' &&
        stateChoice != 'n' &&
        stateChoice != 'Y' &&
        stateChoice != 'N');

    // Handle user choice
    switch (stateChoice) {
      case 'y':
        print('Creating a feature first architecture for $projectName ....');
        await createFeatureFirstArchitecture(projectName);
        break;
      case 'Y':
        print('Creating a feature first architecture for $projectName ....');
        await createFeatureFirstArchitecture(projectName);
        break;
      case 'n':
        print('Creating a Layer first architecture for $projectName ....');
        break;
      case 'N':
        print('Creating a Layer first architecture for $projectName ....');
        break;
    }
  }

  Future<void> createFeatureFirstArchitecture(String projectName) async {
    int numOfFeatures;
    // move to the newly created project directory
    final Directory projectDirectory = Directory(projectName);
    if (!projectDirectory.existsSync()) {
      print('Error: Project directory does not exist.');
      return;
    }

    Directory.current = projectDirectory.path;
    // Ask about number of features from user
    print('Enter the number of features required in $projectName: ');
    final String numOfFeaturesString = stdin.readLineSync() ?? '';
    numOfFeatures = int.parse(numOfFeaturesString);
    List featuresArray = [];

    for (int i = 0; i < numOfFeatures;) {
      print('Enter the name of feature $i : ');
      String nameOfFeature = stdin.readLineSync() ?? '';
      featuresArray.add(nameOfFeature);
      i++;
    }

    print('All of your features are : ');
    print(featuresArray);

    // create 'features' folder inside 'projectName/lib'
    final Directory featuresFolder = Directory('lib/features');
    featuresFolder.createSync(recursive: true);

    // create a folder for each feature
    for (String feature in featuresArray) {
      final Directory featuresFolder = Directory('lib/features/$feature');
      featuresFolder.createSync();
      // Under each feature folder create subfolders for bloc,ui, widgets and repo
      final Directory blocFolder = Directory('lib/features/$feature/bloc');
      final Directory uiFolder = Directory('lib/features/$feature/ui');
      final Directory repoFolder = Directory('lib/features/$feature/repo');
      final Directory widgetsFolder =
          Directory('lib/features/$feature/widgets');
      blocFolder.createSync();
      uiFolder.createSync();
      repoFolder.createSync();
      widgetsFolder.createSync();
    }
  }
}