import "dart:js";
import "dart:async";

main() async {

  Future<String> getJoin(String join) {
    Completer c = new Completer();
    JsObject CF = context['CF'];
    JsFunction getJoin = CF['getJoin'];

    var callbackFunc = (String join, String value, JsObject tokens) {
      c.complete([join, value, tokens]);
    };

    getJoin.apply(['test1', callbackFunc]);

    return c.future;
  }

  getJoin('testJoin').then((value) {
    print(value[0]);
    print(value[1]);
    print(value[2]['[token1]']);
  });
}