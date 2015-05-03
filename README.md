# cf-dart

Quick example project to show how to run Dart (with source maps) on the CommandFusion platform. More to come.

## Build Instructions
1. `./init.sh`
2. `./build.sh`
3. Start your favorite webserver in ./build/web
4. Try debugging the GUI!

## Examples
 - Get all the experssive power of async / await with Dart, and use many fewer callback than JS.
  
```js
CF.userMain = function() {
	CF.watch(CF.PreloadingCompleteEvent, function() {
		CF.getJoin('d1', function(join, value, tokens, tags) {
			console.log('d1: ' + value);
		});
	});
}
```
  
```dart
main () async {
	CF cf = new CF();
	await cf.userMain;
	await cf.preloadingComplete;
	Join join = await cf.getJoin('d1');
	print('d1: ${join.value}');
}

```

## Screenshot

![screenshot](https://raw.githubusercontent.com/gridsoundandscreen/cf-dart/master/screenshot.png)