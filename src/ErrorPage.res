module Styles = {
  open Emotion
  let container = css({
    "width": "100%",
    "maxWidth": 800,
    "margin": "auto",
  })
  let text = css({
    "textAlign": "center",
    "fontSize": "14vw",
    "fontWeight": "bold",
    "color": "#F9053D",
  })
}

@react.component
let make = (~text) => {
  <>
    <Head> <title> {text->React.string} </title> </Head>
    <div className=Styles.container> <div className=Styles.text> {text->React.string} </div> </div>
  </>
}
