import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paloma365/data/section_repository.dart';
import 'package:paloma365/model/section_model.dart';
import 'package:paloma365/pages/section_tables_page.dart';
import 'package:paloma365/widget/section_item_widget.dart';

/**
 * Created by Bekhruz Makhmudov on 05/12/24.
 * Project paloma365
 */
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loading = true;
  List<SectionModel> sections = [];

  Future<void> fetchSections() async {
    setState(() {
      loading = true;
    });
    sections = await SectionRepository().fetchSections();
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    fetchSections();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          "Paloma365",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigoAccent,
      ),
      body: loading
          ? const Center(
              child: CupertinoActivityIndicator(),
            )
          : ListView.separated(
              itemCount: sections.length,
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              separatorBuilder: (context, index) => const SizedBox(
                height: 15,
              ),
              itemBuilder: (context, index) => SectionItemWidget(
                key: ValueKey(sections[index].id),
                model: sections[index],
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) =>
                          SectionTablesPage(section: sections[index]),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
