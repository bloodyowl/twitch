Emotion.injectGlobal(`
@font-face {
  font-family: HelveticaNowDisplay;
  src: url("/public/assets/webfonts/regular.woff2"),
    url("/public/assets/webfonts/regular.woff");
  font-style: normal;
  font-weight: 400;
  font-display: swap;
}
@font-face {
  font-family: HelveticaNowDisplay;
  src: url("/public/assets/webfonts/bold.woff2"),
    url("/public/assets/webfonts/bold.woff");
  font-style: normal;
  font-weight: 700;
  font-display: swap;
}
html {
  padding: 0;
  margin: 0;
  height: -webkit-fill-available;
  font-family: HelveticaNowDisplay, "Helvetica Neue", Helvetica, Arial, sans-serif;
  background-color: #F4F7F8;
  color: #31383E;
}

@media(prefers-color-scheme: dark) {
  html {
    background-color: #222;
    color: #fff;
  }
}

body {
  padding: 0; 
  margin: 0;
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  min-height: -webkit-fill-available;
}
#root {
  display: flex;
  flex-direction: column;
  flex-grow: 1
}`)

module App = {
  @react.component
  let make = () => {
    let url = Router.useUrl()

    React.useEffect1(() => {
      let () = window["scrollTo"](. 0, 0)
      None
    }, [url.path])

    <>
      <Head defaultTitle="bldwl" titleTemplate="%s - bldwl" />
      <Header />
      {switch url.path {
      | list{} => <Hero title=`Bienvenue !` />
      | list{"discuss"} => <Hero title=`Discussions` />
      | _ => <ErrorPage text="Not found" />
      }}
    </>
  }
}

switch ReactDOM.querySelector("#root") {
| Some(root) => ReactDOM.render(<App />, root)
| None => Console.error("Missing #root element")
}
