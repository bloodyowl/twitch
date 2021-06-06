type timeoutId

@val external setTimeout: (unit => unit, int) => timeoutId = "setTimeout"
@val external clearTimeout: timeoutId => unit = "clearTimeout"

@val external innerWidth: int = "innerWidth"

@module("uuid") external uuidV4: unit => string = "v4"

Console.log(uuidV4())

Console.log(innerWidth)

let timeoutId = setTimeout(() => {
  Console.log("foo")
}, 1000)

clearTimeout(timeoutId)

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
Console.log(user->User.getHelloMessage)

module LocalStorage = {
  type t
  @return(nullable) @send external getItem: (t, string) => option<string> = "getItem"
  @send external clear: t => unit = "clear"
  @send external removeItem: (t, string) => unit = "removeItem"
  @send external setItem: (t, string, string) => unit = "setItem"
}

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

module Location = {
  type t
  @get external href: t => string = "href"
  @set external setHref: (t, string) => unit = "href"
}

@val external location: Location.t = "location"

Console.log(location->Location.href)
Console.log(location->Location.setHref("/bar"))

@val external toBase64: string => string = "btoa"
@val external fromBase64: string => string = "atob"

let x = toBase64("foo")

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

@send external forEachWithThisValue: (array<'a>, 'a => unit) => unit = "forEach"

let foo = (~foo, ~bar, ~baz="hello", ()) => {
  Console.log(foo ++ bar ++ baz)
}

foo(~bar="bar", ~foo="foo", ())

module MyComponent = {
  @react.component
  let make = (~foo, ~bar, ~baz="hello") => {
    <div />
  }
}

let x = <MyComponent foo="foo" bar="bar" />

type myObject
@obj
external makeMyObject: (~foo: string, ~bar: string, ~baz: string=?, unit) => myObject = ""

Console.log(makeMyObject(~foo="foo", ~bar="foo", ()))
Console.log(makeMyObject(~foo="foo", ~bar="foo", ~baz="baz", ()))
