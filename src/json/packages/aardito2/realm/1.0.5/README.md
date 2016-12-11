# realm
> Realm is an alternate implementation of Redux using Elm. Actions are created in JavaScript with a payload, which is sent through ports into your Elm store. Elm performs the role of a reducer in Redux, and sends the new state back to JavaScript.

## Usage

### JavaScript
```shell
npm install @aardito2/realm
```

#### createStore(elmStore, initialState = {}, enhancer)
```javascript
// using elm-webpack-loader
import elmStore from './store.elm';

const initialState = {};
const store = createStore(elmStore.Store, initialState);
```

#### applyMiddleware
See <a href="https://github.com/reactjs/redux/blob/master/docs/api/applyMiddleware.md">Redux docs</a>.

#### createAction(actionType) => payload => action
```javascript
const INCREMENT = 'increment';
const increment = createAction(INCREMENT);

const SET_STRING = 'set_string';
const setString = createAction(SET_STRING);
```
#### store.dispatch(action)
```javascript
dispatch(increment());
dispatch(setString('foo'));
```

### Elm
```shell
elm-package install @aardito2/realm
```

Your Elm file should be a Platform.programWithFlags. In main, your update should use Realm.updateState, which takes an outgoing port and an update function and returns a new update function which will automatically send your updated state back to JavaScript.

For each action used in JavaScript, two things are required:

1) An incoming port with the same name as the action type.

2) A subscription to the above port which converts the incoming action into a Msg to be handled by your update function.

See <a href="https://github.com/aardito2/realm/blob/master/example/store.elm">store.elm</a> for a full example of the structure of the store in Elm.
