import "package:cf_d"

main() async {

  CF cf = new CF();

  Join join = await cf.getJoin();

  print(join.join);
  print(join.value);
  print(join.tokens);
  print(join.tags);
}