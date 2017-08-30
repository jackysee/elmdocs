# Elm Blog Engine

This is a work in progress. I'm currently working to make the documentation better so that everyone can enjoy this as much as I do. I also am working to expand the feature set of this package. So stay tuned for that.

This is based on the git-book (https://www.gitbook.com/book/sporto/elm-tutorial/details) by Sporto. I've followed through a handful of free guides and nothing is as comprehensive as his. With this elm-package, truly, I stand on the shoulders of giants.

### Installing Elm 

https://guide.elm-lang.org/install.html

### Installing Dependencies of this package (and this package also!)

```
elm package install elm-lang/html
elm package install elm-lang/http
elm package install evancz/url-parser
elm package install elm-lang/navigation
elm-package install evancz/elm-markdown
elm-package install rundis/elm-bootstrap
elm-package install jamby1100/elm-blog-engine
```

### Node and the server

```
# install nodejs and initialise node
brew install node 
npm init 

# install node server and  dependencies
npm i json-server@0.9 -S 
npm i webpack@1 webpack-dev-middleware@1 webpack-dev-server@1 elm-webpack-loader@3 file-loader@0 style-loader@0 css-loader@0 url-loader@0 -S
npm i ace-css@1 font-awesome@4 -S

# install foreman
npm install -g foreman
```

III. Running Notes

```
# running the json-server that feeds data
npm run api

# compiling the elm script
nf start
```

Resources:

Rails Core

  *Styles* 
  https://github.com/Nerian/bootstrap-datepicker-rails
  https://github.com/haml/haml
  http://getbootstrap.com/
  https://github.com/bokmann/font-awesome-rails

  *Rich Web Text Editor*
  https://www.froala.com/wysiwyg-editor/docs/concepts/image/upload
  https://github.com/froala/wysiwyg-rails

Elm-Rails Integration
  https://github.com/fbonetti/elm-rails
  https://github.com/fbonetti/elm-rails/issues/14