var gulp = require("gulp");
var concat = require("gulp-concat");
var through2 = require("through2");
var markdownlint = require("markdownlint");

gulp.task("test-mdsyntax", function task() {
  return gulp.src("Modules/SharePointDsc/DSCResources/**/*.md", { "read": false })
    .pipe(through2.obj(function obj(file, enc, next) {
      markdownlint(
        {
          "files": [ file.path ],
          "config": require("./.markdownlint.json")
        },
        function callback(err, result) {
          var resultString = (result || "").toString();
          if (resultString) {
            file.contents = new Buffer(resultString);
          }
          next(err, file);
        });
    }))
    .pipe(concat("markdownissues.txt", { newLine: "\r\n" }))
    .pipe(gulp.dest("."));
});
