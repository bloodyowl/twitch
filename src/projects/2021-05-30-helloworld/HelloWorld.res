module Styles = {
  open Emotion
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
  <>
    <h1 className=Styles.title> {`Hello world!`->React.string} </h1>
    <Spacer height="10px" />
    <p className=Styles.description> {`This is a sample project`->React.string} </p>
  </>
}
