import 'package:flutter_test/flutter_test.dart';
import 'package:tsuzuki_connect/services/content_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads and parses all level vocabulary assets', () async {
    final words = await ContentService().loadVocabulary();

    expect(words, hasLength(218));
    expect(words.map((word) => word.id).toSet(), hasLength(words.length));
    expect(words.where((word) => word.level == 'beginner'), hasLength(91));
    expect(words.where((word) => word.level == 'intermediate'), hasLength(45));
    expect(words.where((word) => word.level == 'advanced'), hasLength(82));
  });
}
