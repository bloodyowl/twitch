open Project

module Styles = {
  open Emotion
  let container = css({
    "display": "flex",
    "flexDirection": "row",
    "alignItems": "stretch",
    "flexGrow": 1,
  })
  let sidebar = css({
    "flexGrow": 0,
    "maxWidth": 200,
    "width": "100%",
    "padding": 10,
    "paddingTop": 0,
    "display": "flex",
    "flexDirection": "column",
  })
  let sidebarScrollView = css({
    "height": 1,
    "overflowY": "auto",
    "flexGrow": 1,
  })
  let project = css({
    "padding": "10px 20px",
    "display": "block",
    "textDecoration": "none",
    "color": "currentColor",
    "borderRadius": "10px",
    "lineHeight": 1.0,
    ":hover": {
      "backgroundColor": "rgba(0, 0, 0, 0.07)",
      "@media(prefers-color-scheme: dark)": {
        "backgroundColor": "rgba(255, 255, 255, 0.05)",
      },
    },
    ":active": {
      "opacity": 0.8,
    },
  })
  let activeProject = css({
    "backgroundColor": Theme.mainPurple,
    "color": "#fff",
    ":hover": {
      "backgroundColor": Theme.mainPurple,
      "@media(prefers-color-scheme: dark)": {
        "backgroundColor": Theme.mainPurple,
      },
    },
  })
  let projectName = css({
    "fontWeight": "700",
  })
  let date = css({
    "fontSize": "12px",
    "opacity": 0.5,
  })
  let contents = css({
    "flexGrow": 1,
    "display": "flex",
    "flexDirection": "column",
    "alignItems": "center",
    "justifyContent": "center",
    "padding": 10,
    "paddingTop": 0,
  })
  let projectContainer = css({
    "position": "relative",
    "display": "flex",
    "flexDirection": "column",
    "alignItems": "center",
    "justifyContent": "center",
    "alignSelf": "stretch",
    "flexGrow": 1,
    "backgroundColor": "#fff",
    "borderRadius": 10,
    "boxShadow": "0 0 0 0.5px rgba(0, 0, 0, 0.05), 0 15px 20px rgba(0, 0, 0, 0.1)",
    "@media(prefers-color-scheme: dark)": {
      "backgroundColor": "#444",
    },
  })
  let projectContents = css({
    "height": 1,
    "overflowY": "auto",
    "flexGrow": 1,
    "display": "flex",
    "flexDirection": "column",
    "alignItems": "flex-start",
    "justifyContent": "flex-start",
    "alignSelf": "stretch",
  })
  let nothing = css({
    "fontWeight": "700",
    "fontSize": "7vw",
    "textAlign": "center",
    "opacity": 0.4,
  })
  let searchBar = css({
    "backgroundColor": "rgba(0, 0, 0, 0.05)",
    "@media(prefers-color-scheme: dark)": {
      "backgroundColor": "rgba(255, 255, 255, 0.05)",
    },
    "borderRadius": 8,
    "border": "none",
    "fontFamily": "inherit",
    "padding": 10,
    "fontSize": "inherit",
  })
}

let dateTimeFormater = Intl.DateTimeFormat.makeWithLocaleAndOptions(
  "fr-FR",
  {
    "day": "2-digit",
    "month": "2-digit",
    "year": "numeric",
  },
)

@react.component
let make = (~localPath, ~queryString, ~projects) => {
  let query = React.useMemo1(() => QueryParams.decode(queryString), [queryString])

  <div className=Styles.container>
    <nav className=Styles.sidebar>
      <input
        type_="text"
        placeholder=`Search …`
        value={query->Dict.get("search")->Option.getWithDefault("")}
        className=Styles.searchBar
        onChange={event => {
          let target = event->ReactEvent.Form.target
          let value = target["value"]
          let nextQuery = query->Dict.copy
          if value === "" {
            nextQuery->Dict.delete("search")
          } else {
            nextQuery->Dict.set("search", value)
          }
          let queryString = nextQuery->QueryParams.encode
          RescriptReactRouter.replace(`?${queryString}`)
        }}
      />
      <Spacer height="10px" />
      <div className=Styles.sidebarScrollView>
        {projects
        ->Belt.Array.keepMap(({slug, title, date}) => {
          let shouldShow = switch query->Dict.get("search") {
          | Some(search) => title->String.toUpperCase->String.includes(search->String.toUpperCase)
          | None => true
          }
          shouldShow
            ? Some(
                <Link
                  key=slug
                  href={`/code/${slug}`}
                  preserveQueryString=true
                  className=Styles.project
                  activeClassName=Styles.activeProject>
                  <div className=Styles.projectName> {title->React.string} </div>
                  <time className=Styles.date>
                    {dateTimeFormater
                    ->Intl.DateTimeFormat.format(Date.fromString(date))
                    ->React.string}
                  </time>
                </Link>,
              )
            : None
        })
        ->React.array}
      </div>
    </nav>
    <main className=Styles.contents>
      {switch localPath {
      | list{slug} =>
        let project = projects->Array.find(project => project.slug === slug)
        switch project {
        | Some({render}) =>
          <div className=Styles.projectContainer>
            <div className=Styles.projectContents> {render()} </div>
          </div>
        | None => <div className=Styles.nothing> {"Not found"->React.string} </div>
        }
      | list{} => <div className=Styles.nothing> {"Pick a project"->React.string} </div>
      | _ => <ErrorPage text="Not found" />
      }}
    </main>
  </div>
}
