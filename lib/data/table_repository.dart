import 'package:paloma365/model/table_model.dart';

/**
 * Created by Bekhruz Makhmudov on 05/12/24.
 * Project paloma365
 */
class TableRepository {
  //singleton
  static final TableRepository instance = TableRepository._internal();

  factory TableRepository() {
    return instance;
  }

  TableRepository._internal();

  Future<List<TableModel>> fetchTablesFor(int sectionId) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 100));
    List<TableModel> tables = [];
    switch (sectionId) {
      case 1:
        for (int i = 1; i <= 15; i++) {
          tables.add(
            TableModel(id: i, number: i, sectionId: sectionId),
          );
        }
        break;
      case 2:
        for (int i = 1; i <= 20; i++) {
          tables.add(
            TableModel(id: i + 20, number: i, sectionId: sectionId),
          );
        }
        break;
      case 3:
        for (int i = 1; i <= 27; i++) {
          tables.add(
            TableModel(id: i + 40, number: i, sectionId: sectionId),
          );
        }
        break;
    }
    return tables;
  }
}
