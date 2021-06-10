module Styles = {
  open Emotion
  let container = css({
    "display": "flex",
    "flexGrow": 1,
    "alignSelf": "stretch",
  })
}
@react.component
let make = (~data as _: array<'a>) => {
  <div className=Styles.container />
}
