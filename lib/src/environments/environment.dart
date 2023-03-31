import 'environment_model.dart';
import 'environment_development.dart';
import 'environment_production.dart';

const configuration = String.fromEnvironment(
  'c',
  defaultValue: 'dev',
);

final Environment environment = () {
  switch(configuration) {
    case 'prod': 
      return envProd;
    default:
      return envDev;
  }
}();