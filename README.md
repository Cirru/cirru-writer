
Cirru Writer
------

Converts Cirru AST (which is in JSON) to formatted Cirru code.

Read [`cirru/`][dir] for demos.

[dir]: https://github.com/Cirru/cirru-writer.coffee/tree/master/cirru

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

### License

MIT