
Cirru Writer
------

Converts Cirru AST (which is in JSON) to formatted Cirru code.

Read [`cirru/`][dir] for demos.

[dir]: https://github.com/Cirru/cirru-writer.coffee/tree/master/cirru

### Usage

```bash
npm install --save cirru-writer
```

* `generate`

```coffee
{generate} = require 'cirru-writer'
cirru = generate [['cirru']]
# generate :: JSON -> String
```

### License

MIT