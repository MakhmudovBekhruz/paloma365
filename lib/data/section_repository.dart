import 'package:paloma365/model/section_model.dart';

/**
 * Created by Bekhruz Makhmudov on 05/12/24.
 * Project paloma365
 */
class SectionRepository {
  //singleton
  static final SectionRepository instance = SectionRepository._internal();

  factory SectionRepository() {
    return instance;
  }

  SectionRepository._internal();

  Future<List<SectionModel>> fetchSections() async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 100));
    return [
      SectionModel(
        id: 1,
        name: "Main hall",
      ),
      SectionModel(
        id: 2,
        name: "Basement hall",
      ),
      SectionModel(
        id: 3,
        name: "Second floor",
      )
    ];
  }
}
