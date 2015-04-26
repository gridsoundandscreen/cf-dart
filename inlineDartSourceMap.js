var fs = require('fs');

function inlineDartSourceMap(inputFilePath, buildPath, mapPath) {
  fs.readFile(mapPath, function (err, data) {
    if (err) throw err;
    var sourceMapObject = JSON.parse(data);
    var sources = sourceMapObject.sources;
    var sourcesContent = [];

    for (var sourceIdx = 0; sourceIdx < sources.length; sourceIdx ++) {
      var path = sources[sourceIdx];

      var file = fs.readFileSync(buildPath + path).toString();
      sourcesContent[sourceIdx] = file;
    }

    sourceMapObject.sourcesContent = sourcesContent;

    var sourceMapPrefix = '//# sourceMappingURL=data:application/json;base64,';



    fs.readFile(inputFilePath, function(err, data) {
      if (err) throw err;
      var inlineSourceMap = sourceMapPrefix + Buffer(JSON.stringify(sourceMapObject)).toString('base64');
      var stringFile = data.toString();
      var output = stringFile.replace(/\/\/# sourceMappingURL=(.*)/g, inlineSourceMap);

      fs.writeFile(inputFilePath, output, function(err) {
        if (err) throw err;
        console.log('Converted source map to inline source map.');
      });
    })
  });
}

module.exports = inlineDartSourceMap;



