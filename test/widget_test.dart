import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:planetario/main.dart'; // Importe seu main.dart

void main() {
  testWidgets('Testa a adição de um planeta', (WidgetTester tester) async {
    // Construa o aplicativo.
    await tester.pumpWidget( const MyApp());

    // Encontre os campos de texto e o botão.
    final nameField = find.byType(TextFormField).at(0); // Assumindo que o nome é o primeiro campo
    final descriptionField = find.byType(TextFormField).at(1); // Assumindo que a descrição é o segundo
    final addButton = find.text('Adicionar Planeta');

    // Insira dados nos campos de texto.
    await tester.enterText(nameField, 'Planeta Teste');
    await tester.enterText(descriptionField, 'Descrição de Teste');

    // Toque no botão "Adicionar Planeta".
    await tester.tap(addButton);
    await tester.pump(); // Aguarda a reconstrução do widget

    // Verifique se o planeta foi adicionado à lista.
    expect(find.text('Planeta Teste'), findsOneWidget);
    expect(find.text('Descrição de Teste'), findsOneWidget);


  });
}