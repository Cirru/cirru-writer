
var
  gulp $ require :gulp
  sequence $ require :run-sequence
  exec $ . (require :child_process) :exec
  env $ object
    :dev true
    :main :http://localhost:8080/build/main.js

gulp.task :rsync $ \ (cb)
  var
    wrapper $ require :rsyncwrapper
  wrapper.rsync
    object
      :ssh true
      :src $ array :index.html :build :ast
      :recursive true
      :args $ array :--verbose
      :dest :tiye:~/repo/Cirru/cirru-writer/
      :deleteAll true
    \ (error stdout stderr cmd)
      console.error stdout
      console.error error
      console.error stderr
      console.log cmd
      cb

gulp.task :script $ \ ()
  var
    script $ require :gulp-cirru-script

  ... gulp
    src :src/*.cirru
    pipe $ script
    pipe $ gulp.dest :lib/

gulp.task :html $ \ (cb)
  var
    html $ require :./template
    fs $ require :fs
    assets
  if (not env.dev) $ do
    = assets $ require :./build/assets.json
    = env.main $ + :./build/ assets.main
  fs.writeFile :index.html (html env) cb

gulp.task :del $ \ (cb)
  var
    del $ require :del
  del (array :build) cb

gulp.task :webpack $ \ (cb)
  var
    command $ cond env.dev :webpack ":webpack --config webpack.min.js"
  exec command $ \ (err stdout stderr)
    console.log stdout
    console.log stderr
    cb err

gulp.task :build $ \ (cb)
  = env.dev false
  sequence :del :webpack :html cb
