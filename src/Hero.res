module Styles = {
  open Emotion
  let container = css({
    "width": "100%",
    "margin": "auto",
  })
  let text = css({
    "textAlign": "center",
    "fontSize": "16vw",
    "fontWeight": "bold",
    "padding": 0,
    "margin": 0,
    "whiteSpace": "nowrap",
    "lineHeight": 1.1,
  })
  let smallTextGradient = css({
    "textAlign": "center",
    "fontSize": "8vw",
    "fontWeight": "bold",
    "padding": 0,
    "margin": 0,
    "WebkitBackgroundClip": "text",
    "WebkitTextFillColor": "transparent",
    "backgroundImage": `linear-gradient(to bottom right, ${Theme.mainPurple}, ${Theme.mainPink})`,
    "lineHeight": 1.1,
  })
}

@react.component
let make = (~title) => {
  <>
    <Head> <title> {title->React.string} </title> </Head>
    <div className=Styles.container>
      <h1 className=Styles.text> {title->React.string} </h1>
      <p className=Styles.smallTextGradient> {`twitch.tv/bldwl`->React.string} </p>
    </div>
  </>
}
