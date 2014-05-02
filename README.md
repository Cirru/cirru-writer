
Cirru Writer
------

Converts Cirru AST (which is in JSON) to formatted Cirru code.

Read [`cirru/`][cirru] for demos of that compiled from [`ast/`][ast].

[cirru]: https://github.com/Cirru/cirru-writer.coffee/tree/master/cirru
[ast]: https://github.com/Cirru/cirru-writer.coffee/tree/master/ast

### Usage

```bash
npm install --save cirru-writer
```

* `pretty`

```coffee
{pretty} = require 'cirru-writer'
cirru = pretty [['cirru']]
# pretty :: JSON -> String
```

### Development

Read [`make.coffee`][make] before you go deeper.

Run through all tests:

```bash
./make.coffee test
```

Run specified test in the code `target.run`:

```bash
./make.coffee run
```

Compile code before sending to npm:

```bash
./make.coffee compile
```

[make]: https://github.com/Cirru/cirru-writer.coffee/tree/master/make.coffee

### License

MIT