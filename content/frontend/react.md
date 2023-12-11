+++
title = "React"
date = 2023-11-22T00:00:00+05:30
weight = 1
pre = "<i class=\"devicon-react-original colored\"></i> "
+++

<sub>Started on: 22-11-2023</sub>
<br>
<sub>Finished on: 08-12-2023</sub>

Codevolution: 
- [30 Days Roadmap](https://www.youtube.com/shorts/_1VwcJ2D3eM)
- [Playlist](https://youtube.com/playlist?list=PLC3y8-rFHvwgg3vaYJgHGnModB54rxOk3&si=nTCsAF1lmH3tisY7) 
- [Crash Course](https://youtu.be/jLS0TkAHvRg)
- [React Ecosystem in 2023](https://www.youtube.com/watch?v=6j9tnGMbm2c)

Official Docs: https://react.dev

---
What and Why?
Create new app using Vite & Folder structure

Component-driven architecture
Functional components & export (default and Named `{ ... }`)

Component Lifecycle - Mounting, Updating, Unmounting, Error Handling. Diff methods are called as and when the component goes through stages above

JSX (evaluate JS within curly-braces, single-element return, fragment `<>`, camelCase attributes, double-curlies `{{ ... }}` to pass an object). Everytime state variable changes or new props values are recieved, the component function runs and JSX is returned again to provide dynamic content

Virtual DOM - copy of actual DOM, actual DOM changing is expensive so we change virtual DOM and at the end match with actual DOM and change only what is mismatch, not whole

Important Learning - whatever executable is placed in the root of a component (inside function) is run every time the component re-renders and it returns JSX every time, `useEffect` hook and Live Search uses this phenomena.
Also, whenever a parent re-renders, all its children do too even when they have no updated data sent to them, use memo() to avoid this wastage of resources.

props (immutable, `Hello({ msg })`, `props` variable, `props.children`, default value), name must match in call and definition when not using `props` variable since its not a JS method call but a React construct

state - state variable and setter function, variable is immutable, pass either a value to set in the setter or pass a function reference (using arrow function) containing logic to execute, takes in its own state variable's current value as argument. Ex - `setTodos(currentTodos => { // add todo and return new array })` put this in the button onClick handler method and not root (it will run setter and render entire component in a loop otherwise)

Hooks - pre-defined methods that always start with "`use`" prefix, always called at component function root not inside loops or if-else

Event Handling - (handler function w/o args, pass args to handler function using arrow function, `event` variable)
Child-Parent data passing - send method reference as prop to call parent's method, can pass args too - obviously we need to use arrow functions for that

Important learning  - to pass a function with arguments we NEED to use arrow function (e.g. state setter, event handler with args, child-to-parent function reference prop with args). i.e. when we need to store functions for later calling but with args, otherwise we can just specify function by name. Ex - `{ clickHandler }` vs `{ () => clickHandler('Hi') }`

Conditional rendering - `if`, ternary operator `?:`, short-circuit (`&&`)
Rendering lists: `{ names.map((name) => <h2>{name}</h2>) }` where `const names = ['Abhi', 'Arya']`. Use a unique `key` attribute for better React DOM building.

Styling - `.css` stylesheet, inline using JS objects, Module stylesheet (`myStyles.modules.css`), CSS in JS Library
- in simple stylesheet approach the CSS is imported to all child components as well automatically and className will be valid in them! But with module stylesheet since it is imported with a name, they don't do that

Forms - use a state and `onChange` to receive input, handler function for `onSubmit` and prevent page refresh mechanism

HTTP GET and POST - `fetch()` method or a thirdy-party library like Axios, `useEffect` hook for GET and a onSubmit handler function for POST

useEffect hook - customize side-effects, placed at component root `useEffect(()=>{}, [a,b,c])` runs function every time there is change to _any_ of the states `a`, `b` or `c`. With empty `[]` as second parameter it calls arrow function only on the first load of the component (this is how we send GET)

Important learning  - spread syntax `...arr` means that we are unwrapping elements of the array. Ex - `[...arr, 2, 3]` is a new array, `{...obj, name}` is a new Object . Ex - used to add element to immutable array state variable and return it, add completed property to todo object and return it in the ToDo app.

localStorage - use in `useEffect`, stores KV pairs `localStorage.setItem("ITEM", jsonStr)` and get with  `localStorage.getItem("ITEM")`

Live search: using re-render to run stuff placed in root of the component function, `filteredList` is built everytime `query` changes state, `query` comes from form input of course

useTransition: mark state updates and transitions using this hook, and display a message, execute logic, etc... when state change happens

useContext : pass data directly to any grandchild component skipping any children using Context API (global state mamangement), we can send props with context tag too (including callback function refs)

useReducer : replcement for `useState` but better, similar to reduce in Java and JS
```js
const [currState, dispatch] = useReducer(reducer, initState)
function reducer(currState, action) { }

// use dispatch() to call reducer later onClick
```

memo: wrap a functional component inside `export const newComponent = React.memo(myComponent)` and it returns a `newComponent` that has in-built memoization and does not re-renders when it doesn't need to (no change in its state or props) when its parent does

useMemo: `const isEven = useMemo(()=>{ //code }, [a])` stores results of all code execution and runs (and re-render) only when `a` is changed to an unseen before value, otherwise stored value is returned if there is no new `a` or we're re-rendering because of some other state variable change, `a` is one of the inputs to the function

When a component re-renders, all the arrow function variables placed in the component function root get reinitialized, their body contents may remain the same but React sees them as a diff ones. If they're passed as a prop to a component, that component will re-render unnecessarily. It will even fool `React.memo()` wrapped child component since React believes prop value has legit changed.

useCallback: `const cachedFn = useCallback(()=>{ //fn }, [a])` similar to useMemo but returns a function ref which changes only if value of `a` has changed between re-renders, `a` is one of the inputs to the function, we use `cachedFn` as callback prop wherever `fn` was used

Difference? useMemo calls the function and caches its return values and returns one of those values, whereas useCallback caches the function itself and returns a function reference

useRef - `const myRef = useRef(init)`, a ref's `current` field can be used as a variable holding values but they do not re-render component upon change. Read/write value to it using `myRef.current = newVal`. If we put this itself or any value displayed on screen in a ref (like prop or state) it will not reflect in browser so be careful. 
We can also store DOM elements in a ref, `const myRef = useRef(null)` and attribute on a JSX element use ref attribute `<input ref = {myRef} />`, when components renders for the first time `myRef` will point to the `<input>` tag and we can do stuff like `myRef.current.focus()` or `myRef.current.play()`, `myRef.current.pause()` etc.

Error Boundaries - upon error don't remove UI element instead display fallback UI, error boundary is a special component that wraps code prone to error, `ErrorBoundary` is a custom "foobar" class component that we wrote with overridden lifecycle methods

```js
<ErrorBoundary fallback={ <p>Something went wrong</p> }>  
<Profile />
</ErrorBoundary>
```

Portals - render components outside root DOM element, by default everything is rendered as child of `App` component placed in `<div id="root">` element of the DOM (`index.html`). If we want to render any HTML code in another  HTML tag other than "root". We can do so using Portals.
`{createPortal(children, domNode)}`
```js
// in component JSX
{ createPortal(<p>Test</p>, document.getElementById("overlays")) }

// in index.html
<div id="overlays"></div>
```
The code will directly be injected in the "overlays" tag, and will act as children of whatever component its called from, meaning we can pass props, state etc. as we would to a normal child, Ex - used to create Modal popups

Custom Hooks - put common logic to components in a normal JS function defined in its own file and named `useXXXX` so that linters etc. recognize it as a custom hook

React Server Components - SSR, render JS not in the user browser but on the server, some areas on the page instantly load, we can also access data layer right from inside a server component so no need of APIs. React Frameworks like Next.js and Remix use them internally.

Explore Ecosystem - Axios, React Router, Redux Toolkit

---

Class Components & Legacy most used topics
