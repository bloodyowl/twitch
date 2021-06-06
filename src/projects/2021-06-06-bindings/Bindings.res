// Don't forget to check the output, it's been checked in in the repo!

// Opaque types means the compiler doesn't care about what's inside
// You can just declare that the type exists
type timeoutId

// Even though `timeoutId` is in practice an `int`, given there isn't much
// to do with it being an int, using an opaque type gives us the insurance
// that `clearTimeout` can only receive a value that `setTimeout` returned
@val external setTimeout: (unit => unit, int) => timeoutId = "setTimeout"
@val external clearTimeout: timeoutId => unit = "clearTimeout"

// @val means that we access a value in scope
@val external innerWidth: int = "innerWidth"

// @module lets us bind to JS modules
@module("uuid") external uuidV4: unit => string = "v4"

// It generates "inline" JS calls, no additional cost
Console.log(uuidV4())

Console.log(innerWidth)

let timeoutId = setTimeout(() => {
  Console.log("foo")
}, 1000)

clearTimeout(timeoutId)

// See `BindingClass.js`, in fact, modules let us express concepts very close to classes
// in terms of code organisation
module User = {
  type t = {
    name: string,
    age: int,
  }
  let make = (~name, ~age) => {name: name, age: age}

  let getHelloMessage = user => {
    `Hello ${user.name}!`
  }
}

let user = User.make(~name="Matthias", ~age=27)
// This `->` is a pipe operator.
// This, in combination with modules being accessible in scope, gives us similar ergonomics as JS dot access `.`
Console.log(user->User.getHelloMessage)

// We generally organise bindings as modules: one module = one class
module LocalStorage = {
  // `t` is a convention if there's a "main" type in a module
  type t
  @return(nullable) @send external getItem: (t, string) => option<string> = "getItem"
  @send external clear: t => unit = "clear"
  @send external removeItem: (t, string) => unit = "removeItem"
  @send external setItem: (t, string, string) => unit = "setItem"
}

// @val & @get have different semantics, check the output
@val external localStorage: LocalStorage.t = "localStorage"
@get external getLocalStorage: Dom.window => LocalStorage.t = "localStorage"
@val external currentWindow: Dom.window = "window"
@val external parentWindow: Dom.window = "window.parent"

Console.log(parentWindow->getLocalStorage)

Console.log(localStorage->LocalStorage.getItem("foo"))
localStorage->LocalStorage.clear
localStorage->LocalStorage.removeItem("foo")
localStorage->LocalStorage.setItem("foo", "bar")

let _ = {
  open LocalStorage
  Console.log(localStorage->getItem("foo"))
  localStorage->clear
  localStorage->removeItem("foo")
  localStorage->setItem("foo", "bar")
}

// We can bind to getters & setters too
module Location = {
  type t
  @get external href: t => string = "href"
  @set external setHref: (t, string) => unit = "href"
}

@val external location: Location.t = "location"

Console.log(location->Location.href)
Console.log(location->Location.setHref("/bar"))

// We can alias badly named functions for our internal use without altering
// the output code
@val external toBase64: string => string = "btoa"
@val external fromBase64: string => string = "atob"

let x = toBase64("foo")

// To deal with polymorphic functions, we can define several bindings
// to the same JS value
module Date = {
  type t
  @new external fromString: string => t = "Date"
  @new external fromFloat: float => t = "Date"
  @new external fromDate: t => t = "Date"
  @new external make: unit => t = "Date"
}

let myDate = Date.fromString("2020-06-06")
let myDateFromFloat = Date.fromFloat(123123.3)
let myDateFromDAte = Date.fromDate(myDate)
let myDateNow = Date.make()

@send external forEach: (array<'a>, 'a => unit) => unit = "forEach"
@send external forEachWithIndex: (array<'a>, ('a, int) => unit) => unit = "forEach"

[1, 2, 3]->forEach(Console.log)
[1, 2, 3]->forEachWithIndex(Console.log2)

// Named arguments in ReScript compile to a plain function
// The `()` at the end is here because `baz` is optional.
// Given ReScript is currently curried, it's a "checkpoint" argument
// that indicates that we've passed everything that we wanted
let foo = (~foo, ~bar, ~baz="hello", ()) => {
  Console.log(foo ++ bar ++ baz)
}

foo(~bar="bar", ~foo="foo", ())

// React component use a special annotation to use objects as props
// while retaining ReScript's function ergonomics
module MyComponent = {
  @react.component
  let make = (~foo as _, ~bar as _, ~baz as _="hello") => {
    <div />
  }
}

let z = <MyComponent foo="foo" bar="bar" />

// Useful for big chunks of config option with lots of optional fields,
// so that users don't have to write every single field as `None`
type myObject
@obj
external makeMyObject: (~foo: string, ~bar: string, ~baz: string=?, unit) => myObject = ""

Console.log(makeMyObject(~foo="foo", ~bar="foo", ()))
Console.log(makeMyObject(~foo="foo", ~bar="foo", ~baz="baz", ()))
