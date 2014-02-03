
Cirru Writer
------

Converts JSON representation to Cirru code.

Read [`cirru/`][dir] for demos.

[dir]: https://github.com/Cirru/cirru-writer.coffee/tree/master/cirru

Clone repo and run `npm test` to see if it works fine.

### Usage

```bash
npm install --save cirru-writer
```

* `writer`

```coffee
{writer} = require 'cirru-writer'
cirru = writer jsonData
# writer :: JSON -> String
```

### Future

AMD is not as nice as CommonJS for modularization,
so I'm not offering a browser-side version.

But I hope there is a good one in the future.

### License

MIT