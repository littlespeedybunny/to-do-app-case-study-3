import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../../core/theme/theme_provider.dart';
import '../../data/repositories/note_repository_impl.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../domain/repositories/note_repository.dart';
import '../../domain/repositories/task_repository.dart';
import '../viewmodels/note_viewmodel.dart';
import '../viewmodels/task_viewmodel.dart';

/// App providers setup
/// Configures all providers for dependency injection
class AppProviders {
  static List<SingleChildWidget> get providers => [
    // Theme provider
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
    
    // Repositories
    Provider<NoteRepository>(
      create: (_) => NoteRepositoryImpl(),
    ),
    Provider<TaskRepository>(
      create: (_) => TaskRepositoryImpl(),
    ),
    
    // ViewModels
    ChangeNotifierProxyProvider<NoteRepository, NoteViewModel>(
      create: (context) => NoteViewModel(
        context.read<NoteRepository>(),
      ),
      update: (context, repository, previous) =>
          previous ?? NoteViewModel(repository),
    ),
    ChangeNotifierProxyProvider<TaskRepository, TaskViewModel>(
      create: (context) => TaskViewModel(
        context.read<TaskRepository>(),
      ),
      update: (context, repository, previous) =>
          previous ?? TaskViewModel(repository),
    ),
  ];
}

