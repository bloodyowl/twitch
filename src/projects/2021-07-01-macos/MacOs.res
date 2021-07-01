type app = {
  icon: string,
  name: string,
  id: string,
}

type windowRect = {x: int, y: int, width: int, height: int}

type window = {
  id: string,
  rect: windowRect,
  title: option<string>,
  contents: React.element,
}

module Uuid = {
  @module("uuid") external v4: unit => string = "v4"
}

type contextualMenuItem = {
  label: string,
  onClick: unit => unit,
}

module ContextualMenu = {
  module Styles = {
    open Emotion
    let container = css({
      "borderRadius": 10,
      "backgroundColor": "rgba(0, 0, 0, 0.5)",
      "backdropFilter": "blur(60px) saturate(210%)",
      "boxShadow": "inset 0 0 0 1px rgba(255, 255, 255, 0.3), 0 0 0 1px rgba(0, 0, 0, 0.2), 0 2px 5px rgba(0, 0, 0, 0.1)",
      "padding": 4,
    })
    let separator = css({
      "height": 1,
      "backgroundColor": "rgba(255, 255, 255, .5)",
      "marginLeft": 10,
      "marginRight": 10,
    })
    let button = css({
      "paddingLeft": 10,
      "paddingRight": 10,
      "border": "none",
      "backgroundColor": "transparent",
      "borderRadius": 6,
      "fontFamily": "inherit",
      "whiteSpace": "nowrap",
      "color": "inherit",
      "fontSize": "inherit",
      ":hover": {
        "backgroundColor": "#1251B0",
      },
    })
  }
  @react.component
  let make = (~menuItems) => {
    <div className=Styles.container>
      {menuItems
      ->Array.mapWithIndex((sectionItems, index) => {
        <React.Fragment key={index->Int.toString}>
          {index === 0 ? React.null : <div className=Styles.separator />}
          {sectionItems
          ->Array.mapWithIndex(({onClick, label}, index) =>
            <button onClick={_ => onClick()} key={index->Int.toString} className=Styles.button>
              {label->React.string}
            </button>
          )
          ->React.array}
        </React.Fragment>
      })
      ->React.array}
    </div>
  }
}

module ContextualMenuButton = {
  module Styles = {
    open Emotion
    let container = css({
      "position": "relative",
    })
    let closeUnderlay = css({
      "position": "fixed",
      "left": 0,
      "top": 0,
      "right": 0,
      "bottom": 0,
    })
    let underlay = css({
      "position": "absolute",
      "left": 0,
      "top": 0,
      "right": 0,
      "bottom": 0,
      "backgroundColor": "rgba(255, 255, 255, 0.4)",
      "borderRadius": 5,
    })
    let contents = css({
      "position": "relative",
      "display": "flex",
      "alignItems": "center",
      "justifyContent": "center",
    })
    let contextualMenu = css({
      "position": "absolute",
      "top": "100%",
      "left": 0,
    })
  }
  @react.component
  let make = (~menuItems, ~children) => {
    let (isOpen, setIsOpen) = React.useState(() => false)
    <>
      {isOpen
        ? <div tabIndex={-1} onClick={_ => setIsOpen(_ => false)} className=Styles.closeUnderlay />
        : React.null}
      <div onClick={_ => setIsOpen(isOpen => !isOpen)} className=Styles.container>
        {isOpen ? <div className=Styles.underlay /> : React.null}
        <div className=Styles.contents> children </div>
        {isOpen
          ? <div className=Styles.contextualMenu> <ContextualMenu menuItems /> </div>
          : React.null}
      </div>
    </>
  }
}

module Clock = {
  let padLeft = (string, padChar, int) => {
    (padChar->String.repeat(int) ++ string)->String.sliceToEnd(~start=-int)
  }

  @react.component
  let make = () => {
    let (currentDate, setCurrentDate) = React.useState(() => Date.make())

    React.useEffect0(() => {
      let intervalId = setInterval(() => {
        setCurrentDate(_ => Date.make())
      }, 1_000)
      Some(
        () => {
          clearInterval(intervalId)
        },
      )
    })

    let hours = currentDate->Date.getHours->Int.toString->padLeft("0", 2)
    let minutes = currentDate->Date.getMinutes->Int.toString->padLeft("0", 2)
    let seconds = currentDate->Date.getSeconds->Int.toString->padLeft("0", 2)
    React.string(`${hours}:${minutes}:${seconds}`)
  }
}

module FinderBar = {
  module Styles = {
    open Emotion
    let container = css({
      "height": 24,
      "backgroundColor": "rgba(0, 0, 0, 0.5)",
      "backdropFilter": "blur(60px) saturate(210%)",
      "color": "#fff",
      "display": "flex",
      "flexDirection": "row",
      "alignItems": "center",
      "fontSize": 14,
      "justifyContent": "space-between",
      "padding": "0 20px 0 10px",
    })
    let block = css({
      "display": "flex",
      "flexDirection": "row",
      "alignItems": "center",
    })
    let appleLogo = css({
      "maxWidth": "20px",
      "margin": "0 10px",
      "height": "auto",
    })
    let focusedAppName = css({
      "fontWeight": "700",
    })
  }
  @react.component
  let make = (~setOpenWindows) => {
    <div className=Styles.container>
      <div className=Styles.block>
        <ContextualMenuButton
          menuItems=[
            [
              {
                label: "About this Mac",
                onClick: () =>
                  setOpenWindows(windows =>
                    windows->Array.concat([
                      {
                        id: Uuid.v4(),
                        rect: {x: 50, y: 50, width: 400, height: 400},
                        title: Some("About this Mac"),
                        contents: <h1> {"Hello world!"->React.string} </h1>,
                      },
                    ])
                  ),
              },
            ],
          ]>
          <svg width="24px" height="24px" viewBox="0 0 24 24" className=Styles.appleLogo>
            <g stroke="none" strokeWidth="1" fill="none" fillRule="evenodd">
              <g transform="translate(4.000000, 2.000000)" fill="currentColor" fillRule="nonzero">
                <path
                  d="M13.3249036,18.2348746 C12.2958743,19.2350356 11.1605246,19.0791169 10.0783351,18.6075581 C8.92779683,18.1264921 7.8759846,18.096069 6.66089466,18.6075581 C5.14772797,19.2616558 4.34462946,19.0715112 3.43331201,18.2348746 C-1.71183446,12.9298381 -0.952403248,4.84868928 4.89521709,4.54445779 C6.31345488,4.62051566 7.30641119,5.32975531 8.14178553,5.38870016 C9.38345556,5.13580774 10.5719654,4.41135652 11.90097,4.50642886 C13.4976742,4.63572724 14.6918797,5.26700757 15.4892825,6.40217129 C12.2047425,8.37967594 12.9831595,12.7149746 16,13.9319005 C15.3962522,15.5196086 14.6216323,17.0883022 13.323005,18.2481847 L13.3249036,18.2348746 Z M8.02787084,4.48741439 C7.87408602,2.12962039 9.78215695,0.190144677 11.9769132,0 C12.2787871,2.71906889 9.50876171,4.75361694 8.02787084,4.48741439 Z"
                />
              </g>
            </g>
          </svg>
        </ContextualMenuButton>
        <Spacer width="20px" />
        <div className=Styles.focusedAppName> {"Finder"->React.string} </div>
      </div>
      <div className=Styles.block> <Clock /> </div>
    </div>
  }
}

let finder = {
  id: Uuid.v4(),
  name: "Finder",
  icon: "/images/macos/applications/Finder.png",
}

module DockApplicationTooltip = {
  module Styles = {
    open Emotion
    let container = css({
      "position": "relative",
    })
    let tooltip = css({
      "position": "absolute",
      "bottom": "calc(100% + 20px)",
      "left": "50%",
      "transform": "translateX(-50%)",
      "backgroundColor": "#333",
      "border": "1px solid #555",
      "padding": "2px 15px",
      "fontSize": 14,
      "borderRadius": 5,
    })
    let arrow = css({
      "position": "absolute",
      "top": "100%",
      "left": "50%",
      "transform": "translateX(-50%)",
      "width": 10,
      "height": 10,
    })
    let arrowBack = cx([
      arrow,
      css({
        "width": 12,
        "height": 12,
      }),
    ])
  }
  @react.component
  let make = (~title, ~children) => {
    let (isHovered, setIsHovered) = React.useState(() => false)
    <div
      onMouseEnter={_ => setIsHovered(_ => true)}
      onMouseLeave={_ => setIsHovered(_ => false)}
      className=Styles.container>
      children
      <div
        className=Styles.tooltip
        ariaHidden={!isHovered}
        style={ReactDOM.Style.make(
          ~opacity=isHovered ? "1" : "0",
          ~transition=isHovered ? "none" : "100ms ease-out opacity",
          (),
        )}>
        {title->React.string}
        <svg viewBox="0 0 5 5" className=Styles.arrowBack>
          <polygon points="0 0, 5 0, 2.5 2.5" fill="#555" />
        </svg>
        <svg viewBox="0 0 5 5" className=Styles.arrow>
          <polygon points="0 0, 5 0, 2.5 2.5" fill="#333" />
        </svg>
      </div>
    </div>
  }
}

module Dock = {
  module Styles = {
    open Emotion
    let container = css({
      "position": "absolute",
      "bottom": "5px",
      "left": "50%",
      "transform": "translateX(-50%)",
      "height": 76,
      "padding": "12px 5px 8px",
      "borderRadius": 20,
      "backgroundColor": "rgba(0, 0, 0, 0.5)",
      "backdropFilter": "blur(60px) saturate(210%)",
      "boxShadow": "inset 0 0 0 1px rgba(255, 255, 255, 0.03), 0 2px 5px rgba(255, 255, 255, 0.1)",
      "boxSizing": "border-box",
      "display": "flex",
      "flexDirection": "row",
      "alignItems": "stretch",
    })
    let appIcon = css({
      "margin": "0 5px",
    })
  }
  @react.component
  let make = (~applications) => {
    <div className=Styles.container>
      {[finder]
      ->Array.concat(applications)
      ->Array.map(app =>
        <DockApplicationTooltip key={app.id} title={app.name}>
          <img src={app.icon} width="56" height="56" alt={app.name} className={Styles.appIcon} />
        </DockApplicationTooltip>
      )
      ->React.array}
    </div>
  }
}

// Georges gave you that: ["#FF5F57", "#29C83F", "#FEBC2E"]
module Window = {
  module Styles = {
    open Emotion
    let container = css({
      "display": "flex",
      "flexDirection": "column",
      "alignItems": "stretch",
      "borderRadius": 8,
      "backgroundColor": "#222",
      "color": "#fff",
      "boxShadow": "0 0 0 1px rgba(255, 255, 255, 0.3), 0 0 0 2px rgba(0, 0, 0, 0.8), 0 20px 30px -10px rgba(0, 0, 0, 0.7)",
    })
    let titleBar = css({
      "display": "flex",
      "flexDirection": "row",
      "justifyContent": "center",
      "alignItems": "center",
      "padding": "5px",
      "position": "relative",
    })
    let title = css({
      "fontWeight": 700,
      "overflow": "hidden",
      "textOverflow": "ellipsis",
      "width": 1,
      "flexGrow": 1,
      "whiteSpace": "nowrap",
      "textAlign": "center",
    })
    let contents = css({
      "flexGrow": 1,
      "backgroundColor": "#111",
      "borderBottomLeftRadius": 8,
      "borderBottomRightRadius": 8,
      "display": "flex",
      "flexDirection": "column",
      "alignItems": "center",
      "justifyContent": "center",
    })
    let closeButton = css({
      "position": "absolute",
      "top": "50%",
      "transform": "translateY(-50%)",
      "left": "10px",
      "width": 12,
      "height": 12,
      "borderRadius": "100%",
      "backgroundColor": "#FF5F57",
    })
  }
  @react.component
  let make = (~window, ~onClose) => {
    let top = window.rect.y->Int.toString
    let left = window.rect.x->Int.toString
    let width = window.rect.width->Int.toString
    let height = window.rect.height->Int.toString
    <div
      className=Styles.container
      style={ReactDOM.Style.make(
        ~position="absolute",
        ~top=`${top}px`,
        ~left=`${left}px`,
        ~width=`${width}px`,
        ~height=`${height}px`,
        (),
      )}>
      <div className=Styles.titleBar>
        <div className=Styles.closeButton onClick={_ => onClose()} />
        {switch window.title {
        | Some(title) => <div className=Styles.title> {title->React.string} </div>
        | None => React.null
        }}
      </div>
      <div className=Styles.contents> {window.contents} </div>
    </div>
  }
}

module Styles = {
  open Emotion
  let container = css({
    "display": "flex",
    "flexDirection": "column",
    "flexGrow": 1,
    "alignItems": "stretch",
    "alignSelf": "stretch",
    "backgroundSize": "cover",
    "backgroundPosition": "50% 50%",
  })
}

type systemPreferences = {wallpaper: string}

@react.component
let make = () => {
  let (systemPreferences, _) = React.useState(() => {
    wallpaper: "/images/macos/wallpapers/Wallpaper.png",
  })

  let (openWindows, setOpenWindows) = React.useState(() => [])

  <div
    className=Styles.container
    style={ReactDOM.Style.make(~backgroundImage=`url("${systemPreferences.wallpaper}")`, ())}>
    <FinderBar setOpenWindows />
    <Dock
      applications=[
        {
          id: Uuid.v4(),
          name: "Safari",
          icon: "/images/macos/applications/Safari.png",
        },
      ]
    />
    {openWindows
    ->Array.map(window =>
      <Window
        window
        onClose={() =>
          setOpenWindows(windows => windows->Array.filter(item => item.id !== window.id))}
      />
    )
    ->React.array}
  </div>
}
