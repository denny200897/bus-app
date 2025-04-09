import 'package:flutter_test/flutter_test.dart';
import 'package:notes_app/main.dart'; // 使用你的專案名稱

void main() {
  testWidgets('NotebookApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(NotesApp());

    // Verify that our app starts with the initial state.
    expect(find.text('還沒有筆記，快來添加吧！'), findsOneWidget);
  });
}