import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main.g.dart';

const double _kSize = 50;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //
      home: const ProviderScope(
          child: MyHomePage(title: 'Flutter Demo Home Page')),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 状態の監視
    final counter = ref.watch(counterNotifierProvider);
    final isLoading = counter.isLoading;
    final number = counter.value;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            isLoading
                ? LoadingAnimationWidget.waveDots(
                    color: Colors.black,
                    size: _kSize,
                  )
                : Text(
                    '$number',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(counterNotifierProvider.notifier).increment(),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

/**
 * 基本的なProvider
 */
// class CounterNotifier extends Notifier<int> {
//   @override
//   int build() => 0;

//   void increment() {
//     state = state + 1;
//   }
// }

// final counterNotifierProvider = NotifierProvider<CounterNotifier, int>(() {
//   return CounterNotifier();
// });

/// 関数ベースのプロバイダー
@riverpod
String greet(GreetRef ref) {
  return 'Hello World!';
}

/// クラスベースのプロバイダー
// @riverpod
// class CounterNotifier extends _$CounterNotifier {
//   @override
//   int build() => 0;
//   void increment() {
//     state = state + 1;
//   }
// }

// 非同期のProvider
@riverpod
class CounterNotifier extends _$CounterNotifier {
  @override
  Future<int> build() async {
    await Future.delayed(
      const Duration(seconds: 1),
    );
    return 0;
  }

  void increment() async {
    final currentValue = state.valueOrNull;
    if (currentValue == null) return;

    state = const AsyncLoading();
    await Future<void>.delayed(const Duration(seconds: 1));
    state = AsyncValue.data(currentValue + 1);
  }
}
