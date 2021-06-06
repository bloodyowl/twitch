module Styles = {
  open Emotion
  let container = css({
    "display": "flex",
    "flexDirection": "column",
    "alignItems": "center",
    "justifyContent": "center",
    "alignSelf": "stretch",
    "flexGrow": 1,
  })
  let title = css({
    "margin": 0,
    "fontWeight": "400",
  })
}
@react.component
let make = (~title, ~link) => {
  <div className=Styles.container>
    <h1 className=Styles.title> {title->React.string} </h1>
    <a href={link} target="_blank"> {"See the code on GitHub"->React.string} </a>
  </div>
}
