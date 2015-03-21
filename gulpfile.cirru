
= gulp $ require :gulp

gulp.task :script $ \ ()
  = script $ require :gulp-cirru-script
  = rename $ require :gulp-rename

  ... gulp
    :src :src/**/*.cirru $ object (:base :src)
    :pipe $ script $ object (:dest :../lib)
    :pipe $ rename $ object (:extname :.js)
    :pipe $ gulp.dest :./lib
