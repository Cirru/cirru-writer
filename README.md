
Cirru Writer
------

Converts Cirru AST (which is in JSON) to formatted Cirru code.

Read [`cirru/`][cirru] for demos of that compiled from [`ast/`][ast].

[cirru]: https://github.com/Cirru/cirru-writer.coffee/tree/master/cirru
[ast]: https://github.com/Cirru/cirru-writer.coffee/tree/master/ast

Demo: http://repo.cirru.org/writer/

### Usage

```bash
npm install --save cirru-writer
```

* `render`

```coffee
{render} = require 'cirru-writer'
cirru = render [['cirru']]
# render :: JSON -> String
```

### Development

Run through all tests:

```bash
cirru-script test.cirru
```

Compile code before sending to npm:

```bash
# officially gulp is not support CirruScript
# but by updating node-interpret you may run
gulp script
```

### License

MIT
