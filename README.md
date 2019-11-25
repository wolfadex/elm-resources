# Elm Resources

An opinionated collection of resources for learning and using Elm. Viewable at https://wolfadex.github.io/elm-resources/.

If you have any suggestion, please feel free to make a PR or file an issue.

## Development

- Install [elm](https://guide.elm-lang.org/install/elm.html)
- Install [node](https://nodejs.org/en/)
- Install [terser](https://www.npmjs.com/package/terser)
- Run `elm reactor` while developing

### Production build:

Max/Linux

- Run `./build src/Main.elm`

Windows

- Run `elm make src/Main.elm --optimize --output=elm.js`
- Run `terser elm.js --compress 'pure_funcs="F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9",pure_getters,keep_fargs=false,unsafe_comps,unsafe' | terser --mangle --output=elm.min.js`