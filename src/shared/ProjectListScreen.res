open Project

module Styles = {
  open Emotion
  let container = css({
    "display": "flex",
    "flexDirection": "row",
    "alignItems": "stretch",
    "flexGrow": 1,
    "position": "relative",
  })
  let sidebar = css({
    "flexGrow": 0,
    "width": 200,
    "display": "flex",
    "flexDirection": "column-reverse",
  })
  let sidebarScrollView = css({
    "height": 1,
    "overflowY": "auto",
    "flexGrow": 1,
    "padding": 10,
    "paddingTop": 0,
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

  let searchContainer = css({
    "display": "flex",
    "flexDirection": "row",
    "alignItems": "stretch",
    "paddingLeft": 10,
    "paddingRight": 10,
   })
  let searchBar = css({
    "flexGrow": 1,
    "width": 1,
    "backgroundColor": Theme.mainContrastBackgroundColor,
    "color": "inherit",
    "borderRadius": 8,
    "border": "none",
    "fontFamily": "inherit",
    "padding": 10,
    "fontSize": "inherit",
    ":focus": {
      "background": Theme.mainContrastAccentedBackgroundColor,
      "outline": "none",
    },
  })

  let collapse = css({
    "flexGrow": 0,
    "border": "none",
    "background": Theme.mainContrastBackgroundColor,
    "padding": 10,
    "borderRadius": 8,
    "cursor": "pointer",
    ":hover": {
      "background": Theme.mainContrastAccentedBackgroundColor,
    },
  })

  let stickySidebarActionSize = 44
  let stickySidebarActionPadding = 20
  let stickySidebarAction = css({
    "position": "absolute",
    "left": stickySidebarActionPadding,
    "bottom": stickySidebarActionPadding,
    "backgroundColor": Theme.mainPurple,
    "border": "none",
    "width": stickySidebarActionSize,
    "height": stickySidebarActionSize,
    "borderRadius": stickySidebarActionSize / 2,
    "cursor": "pointer",
    ":hover": {
      "backgroundColor": Theme.mainPink,
    },
    ":active": {
      "backgroundColor": Theme.mainPink,
      "opacity": "0.9",
    },
  })

  let overlayAppear = keyframes({
    "from": {
      "opacity": 0.0,
    },
  })

  let stickySidebarOverlay = css({
    "position": "fixed",
    "backgroundColor": Theme.mainContrastColor,
    "top": -10,
    "left": -10,
    "right": -10,
    "bottom": -10,
    "border": "none",
    "backdropFilter": "blur(4px)",
    "animation": `200ms ease-in-out ${overlayAppear}`,
  })

  let sidebarAppear = keyframes({
    "from": {
      "opacity": 0.0,
      "transform": "translateY(10px)",
    },
  })

  let stickySidebarContainer = css({
    "position": "absolute",
    "left": stickySidebarActionPadding,
    "bottom": stickySidebarActionPadding + stickySidebarActionSize + 10,
    "top": 10,
    "display": "flex",
    "flexDirection": "row",
    "alignItems": "stretch",
    "backgroundColor": Theme.mainBackgroundColor,
    "borderRadius": 10,
    "paddingTop": 10,
    "animation": `200ms ease-in-out ${sidebarAppear}`,
  })

  let stickySidebarPointer = css({
    "position": "absolute",
    "top": "100%",
    "left": stickySidebarActionSize / 2,
    "transform": "translateX(-50%)",
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

let minContainerSizeForSidebar = 600

@react.component
let make = (~localPath, ~queryString, ~projects) => {
  let containerRef = React.useRef(Nullable.null)

  let dimensions = ResizeObserver.useResizeObserver(containerRef)

  let query = React.useMemo1(() => QueryParams.decode(queryString), [queryString])

  let (isSidebarOpen, setIsSidebarOpen) = React.useState(() => true)

  <div className=Styles.container ref={ReactDOM.Ref.domRef(containerRef)}>
    {switch dimensions {
    | None => React.null
    | Some(dimensions) =>
      let hasEnoughSpaceForSidebar = dimensions.width >= minContainerSizeForSidebar
      let sidebar =
        <nav className=Styles.sidebar>
          <div className=Styles.sidebarScrollView>
            {projects
            ->Belt.Array.keepMap(({slug, title, date}) => {
              let shouldShow = switch query->Dict.get("search") {
              | Some(search) =>
                title->String.toUpperCase->String.includes(search->String.toUpperCase)
              | None => true
              }
              shouldShow
                ? Some(
                    <Link
                      key=slug
                      href={`/code/${slug}`}
                      preserveQueryString=true
                      className=Styles.project
                      activeClassName=Styles.activeProject
                      onClick={_ => {
                        if !hasEnoughSpaceForSidebar {
                          setIsSidebarOpen(_ => false)
                        }
                      }}>
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
          <Spacer height="10px" />
          <div className=Styles.searchContainer>
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
            {hasEnoughSpaceForSidebar
              ? <>
                  <Spacer width="10px" />
                  <button
                    className=Styles.collapse
                    onClick={_ => setIsSidebarOpen(_ => false)}
                    title="Collapse sidebar">
                    <svg viewBox="0 0 10 10" width="16" height="16">
                      <g
                        fill="none"
                        stroke=Theme.mainTextColor
                        strokeLinejoin="round"
                        strokeLinecap="round">
                        <polyline points="5 0, 0 5, 5 10" /> <polyline points="0 5, 10 5" />
                      </g>
                    </svg>
                  </button>
                </>
              : React.null}
          </div>
        </nav>

      <>
        {hasEnoughSpaceForSidebar && isSidebarOpen ? sidebar : React.null}
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
        {hasEnoughSpaceForSidebar && isSidebarOpen
          ? React.null
          : <>
              {isSidebarOpen
                ? <>
                    <button
                      className=Styles.stickySidebarOverlay
                      title="Close sidebar"
                      onClick={_ => setIsSidebarOpen(_ => false)}
                    />
                    <FocusTrap
                      className=Styles.stickySidebarContainer
                      onPressEscape={_ => setIsSidebarOpen(_ => false)}>
                      sidebar
                      <svg
                        className=Styles.stickySidebarPointer
                        viewBox="0 0 10 10"
                        width="18"
                        height="18">
                        <polygon fill=Theme.mainBackgroundColor points="0 0, 10 0, 5 5" />
                      </svg>
                    </FocusTrap>
                  </>
                : React.null}
              <button className=Styles.stickySidebarAction onClick={_ => setIsSidebarOpen(not)}>
                <svg viewBox="0 0 16 16" width="16" height="16">
                  <g stroke="#fff" strokeWidth="2" strokeLinecap="round">
                    <line x1="0" y1="2" x2="16" y2="2" />
                    <line x1="0" y1="8" x2="16" y2="8" />
                    <line x1="0" y1="14" x2="16" y2="14" />
                  </g>
                </svg>
              </button>
            </>}
      </>
    }}
  </div>
}
