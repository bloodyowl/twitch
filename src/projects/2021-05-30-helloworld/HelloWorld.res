module Styles = {
  open Emotion
  let container = css({
    "display": "flex",
    "flexDirection": "column",
    "flexGrow": 1,
    "textAlign": "center",
    "alignSelf": "stretch",
    "alignItems": "center",
    "justifyContent": "center",
  })
  let title = css({
    "margin": 0,
    "fontSize": 42,
  })
  let description = css({
    "margin": 0,
    "fontSize": 18,
  })
}

@react.component
let make = () => {
  <div className=Styles.container>
    <h1 className=Styles.title> {`Hello world!`->React.string} </h1>
    <p className=Styles.description> {`This is a sample project`->React.string} </p>
  </div>
}
