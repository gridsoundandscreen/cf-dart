import 'package:cf_dart/cf_dart.dart';

main() async {

  CF cf = new CF();

  Join join = await cf.getJoin();

  print(join.join);
  print(join.value);
  print(join.tokens);
  print(join.tags);
}