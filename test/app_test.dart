import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_tutorial/news_change_notifier.dart';
import 'package:flutter_testing_tutorial/news_page.dart';
import 'package:flutter_testing_tutorial/news_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockNewsService extends Mock implements NewsService {}

void main() {
  late MockNewsService mockNewsService;

  setUp(() {
    mockNewsService = MockNewsService();
  });
  Widget createWidgetUnderTest() {
    return MaterialApp(
      title: 'News App',
      home: ChangeNotifierProvider(
        create: (_) => NewsChangeNotifier(mockNewsService),
        child: const NewsPage(),
      ),
    );
  }

  testWidgets("Tapping on the first article opens the article page",
      (widgetTester) async {
        
    await widgetTester.pumpWidget(createWidgetUnderTest());
    await widgetTester.pump();
    await widgetTester.tap(find.text("Content 1"));
    await widgetTester.pumpAndSettle();
    expect(find.byType(NewsPage), findsOneWidget);
    expect(find.text("Title 1"), findsOneWidget);
  });
}
