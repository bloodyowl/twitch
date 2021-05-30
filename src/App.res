CssReset.inject()

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
      | list{"code", ...localPath} =>
        <ProjectListScreen localPath queryString=url.search projects=ProjectList.projects />
      | _ => <ErrorPage text="Not found" />
      }}
    </>
  }
}

switch ReactDOM.querySelector("#root") {
| Some(root) => ReactDOM.render(<App />, root)
| None => Console.error("Missing #root element")
}
