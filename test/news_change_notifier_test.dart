import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_tutorial/article.dart';
import 'package:flutter_testing_tutorial/news_change_notifier.dart';
import 'package:flutter_testing_tutorial/news_service.dart';
import 'package:mocktail/mocktail.dart';

class MockNewsService extends Mock implements NewsService {}

void main() {
  late NewsChangeNotifier nut;
  late MockNewsService mockNewsService;

  setUp(() {
    mockNewsService = MockNewsService();
    nut = NewsChangeNotifier(mockNewsService);
  });

  test(
    "check from initial values",
    () {
      expect(nut.articles, []);
      expect(nut.isLoading, false);
    },
  );

  group("getArticles", () {
    final articlesFromService = [
      Article(title: "Title 1", content: "Content 1"),
      Article(title: "Title 2", content: "Content 2"),
      Article(title: "Title 3", content: "Content 3"),
    ];
    void arrangeNewsServiceReturns3Articles() {
      when(() => mockNewsService.getArticles())
          .thenAnswer((_) async => articlesFromService);
    }

    test(
      "gets article using NewsService",
      () async {
        arrangeNewsServiceReturns3Articles();
        await nut.getArticles();
        verify(() => mockNewsService.getArticles()).called(1);
      },
    );

    test(
      """ indicates loading of data,
    sets articles to the ones from the service,
    indicates that data is not loaded anymore.
      """,
      () async {
        arrangeNewsServiceReturns3Articles();
        final future = nut.getArticles();
        expect(nut.isLoading, true);
        await future;
        expect(nut.articles, articlesFromService);
        expect(nut.isLoading, false);
      },
    );
  });
}
