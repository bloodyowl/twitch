// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Uuid from "uuid";
import * as React from "react";
import * as Caml_option from "rescript/lib/es6/caml_option.js";

console.log(Uuid.v4());

console.log(innerWidth);

var timeoutId = setTimeout((function (param) {
        console.log("foo");
        
      }), 1000);

clearTimeout(timeoutId);

function make(name, age) {
  return {
          name: name,
          age: age
        };
}

function getHelloMessage(user) {
  return "Hello " + user.name + "!";
}

var User = {
  make: make,
  getHelloMessage: getHelloMessage
};

var user = {
  name: "Matthias",
  age: 27
};

console.log(getHelloMessage(user));

var LocalStorage = {};

console.log(window.parent.localStorage);

console.log(Caml_option.nullable_to_opt(localStorage.getItem("foo")));

localStorage.clear();

localStorage.removeItem("foo");

localStorage.setItem("foo", "bar");

console.log(Caml_option.nullable_to_opt(localStorage.getItem("foo")));

localStorage.clear();

localStorage.removeItem("foo");

localStorage.setItem("foo", "bar");

var $$Location = {};

console.log(location.href);

console.log((location.href = "/bar", undefined));

var x = btoa("foo");

var $$Date = {};

var myDate = new Date("2020-06-06");

var myDateFromFloat = new Date(123123.3);

var myDateFromDAte = new Date(myDate);

var myDateNow = new Date();

[
    1,
    2,
    3
  ].forEach(function (prim) {
      console.log(prim);
      
    });

[
    1,
    2,
    3
  ].forEach(function (prim0, prim1) {
      console.log(prim0, prim1);
      
    });

function foo(foo$1, bar, bazOpt, param) {
  var baz = bazOpt !== undefined ? bazOpt : "hello";
  console.log(foo$1 + bar + baz);
  
}

foo("foo", "bar", undefined, undefined);

function Bindings$MyComponent(Props) {
  var $staropt$star = Props.baz;
  $staropt$star !== undefined;
  return React.createElement("div", undefined);
}

var MyComponent = {
  make: Bindings$MyComponent
};

var z = React.createElement(Bindings$MyComponent, {
      foo: "foo",
      bar: "bar"
    });

console.log({
      foo: "foo",
      bar: "foo"
    });

console.log({
      foo: "foo",
      bar: "foo",
      baz: "baz"
    });

export {
  timeoutId ,
  User ,
  user ,
  LocalStorage ,
  $$Location ,
  x ,
  $$Date ,
  myDate ,
  myDateFromFloat ,
  myDateFromDAte ,
  myDateNow ,
  foo ,
  MyComponent ,
  z ,
  
}
/*  Not a pure module */
