import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_app/routes/app_router.dart';
import 'package:task_manager_app/bloc_state_observer.dart';
import 'package:task_manager_app/routes/pages.dart';
import 'package:task_manager_app/tasks/data/local/data_sources/tasks_data_provider.dart';
import 'package:task_manager_app/tasks/data/repository/task_repository.dart';
import 'package:task_manager_app/tasks/presentation/bloc/tasks_bloc.dart';
import 'package:task_manager_app/utils/color_palette.dart';
import 'package:appwrite/appwrite.dart';
import 'package:task_manager_app/provider/appwrite_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set up the Bloc observer
  Bloc.observer = BlocStateOberver();

  // Initialize SharedPreferences
  final SharedPreferences preferences = await SharedPreferences.getInstance();

  // Initialize Appwrite
  final Client client = Client()
    ..setEndpoint('https://cloud.appwrite.io/v1') // Your Appwrite endpoint
    ..setProject('66b2f99400258e649456') // Your Appwrite project ID
    ..setSelfSigned(status: true); // Self-signed certificates

  // Initialize Appwrite instance
  Appwrite.instance.initializeClient(client);

  // Run the app with the initialized preferences
  runApp(MyApp(preferences: preferences));
}

class MyApp extends StatelessWidget {
  final SharedPreferences preferences;

  const MyApp({Key? key, required this.preferences}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => TaskRepository(
        taskDataProvider: TaskDataProvider(preferences),
      ),
      child: BlocProvider(
        create: (context) => TasksBloc(
          context.read<TaskRepository>(),
        ),
        child: MaterialApp(
          title: 'Task Manager',
          debugShowCheckedModeBanner: false,
          initialRoute: Pages.initial,
          onGenerateRoute: onGenerateRoute,
          theme: ThemeData(
            fontFamily: 'Sora',
            visualDensity: VisualDensity.adaptivePlatformDensity,
            canvasColor: Colors.transparent,
            colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF00AB44)),
            useMaterial3: true,
          ),
        ),
      ),
    );
  }
}
