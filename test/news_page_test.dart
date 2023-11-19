import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_tutorial/article.dart';
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

  final articlesFromService = [
    Article(title: "Title 1", content: "Content 1"),
    Article(title: "Title 2", content: "Content 2"),
    Article(title: "Title 3", content: "Content 3"),
  ];
  void arrangeNewsServiceReturns3Articles() {
    when(() => mockNewsService.getArticles())
        .thenAnswer((_) async => articlesFromService);
  }

  void arrangeNewsServiceReturns3ArticlesAfter2SecondsWait() {
    when(() => mockNewsService.getArticles()).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return articlesFromService;
    });
  }

  testWidgets("title is displayed", (WidgetTester widgetTester) async {
    arrangeNewsServiceReturns3Articles();
    await widgetTester.pumpWidget(createWidgetUnderTest());

    expect(find.text("News"), findsOneWidget);
  });

  testWidgets(
      "loading indicator is displaying while while waiting for articles",
      (widgetTester) async {
    arrangeNewsServiceReturns3ArticlesAfter2SecondsWait();
    await widgetTester.pumpWidget(createWidgetUnderTest());
    await widgetTester.pump(const Duration(milliseconds: 400));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await widgetTester.pumpAndSettle();
  });

  testWidgets("articles are displayed", (widgetTester) async {
    arrangeNewsServiceReturns3Articles();

    await widgetTester.pumpWidget(createWidgetUnderTest());
    await widgetTester.pump();
    for (final article in articlesFromService) {
      expect(find.text(article.title), findsOneWidget);
      expect(find.text(article.content), findsOneWidget);
    }
  });
}
