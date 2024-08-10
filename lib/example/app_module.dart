import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:playground/example/env/env.dart';
import 'package:playground/example/pages/home_page.dart';

import 'datasource/search_datasource.dart';
import 'pages/home_controller.dart';
import 'repositories/search_repository.dart';

class AppModule extends Module {
  @override
  void binds(i) {
    i.addInstance(HitsSearcher(
        applicationID: Constants.applicationId,
        apiKey: Constants.apiKey,
        indexName: Constants.indexName,
        options: const ClientOptions(
          connectTimeout: Duration(seconds: 40),
        )));

    i.add(SearchDatasource.new);
    i.add(SearchRepository.new);
    i.add(HomeController.new);
  }

  @override
  void routes(r) {
    r.child('/',
        child: (context) => MyHomePage(
              controller: Modular.get<HomeController>(),
            ));
  }
}
