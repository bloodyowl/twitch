module Styles = {
  open Emotion
  let container = css({
    "flexGrow": 0,
    "padding": 10,
    "display": "flex",
    "flexDirection": "row",
  })
  let logoContainer = css({
    "position": "relative",
    "padding": "0 10px",
    "zIndex": 2,
    "transition": "200ms ease-in-out transform",
    "display": "flex",
    "alignItems": "center",
    "justifyContent": "center",
  })
  let speakingLogoContainer = cx([
    logoContainer,
    css({
      "transform": "translate(50px, 60px)",
    }),
  ])
  let speechBackgroundColor = "#000"
  let speech = css({
    "position": "absolute",
    "top": 0,
    "left": "100%",
    "transform": "translate(10px, 10px)",
    "backgroundColor": speechBackgroundColor,
    "color": "#fff",
    "padding": "10px 20px",
    "whiteSpace": "nowrap",
    "borderRadius": 8,
    "pointerEvents": "none",
  })
  let speechPointer = css({
    "position": "absolute",
    "right": "100%",
    "top": "50%",
    "transform": "translateY(-50%)",
  })
  let nav = css({
    "display": "flex",
    "flexDirection": "row",
    "alignItems": "center",
    "justifyContent": "flex-start",
    "padding": 10,
    "paddingLeft": 20,
    "flexGrow": 1,
  })
  let popAnimation = keyframes({
    "from": {
      "opacity": 0.0,
      "transform": "translateX(-10px)",
    },
  })
  let navItem = css({
    "paddingLeft": 10,
    "paddingRight": 10,
    "textDecoration": "none",
    "color": "#9146ff",
    "borderRadius": 8,
    "height": 36,
    "display": "flex",
    "flexDirection": "row",
    "alignItems": "center",
    "justifyContent": "center",
    "animation": `300ms ease-in-out ${popAnimation} backwards`,
    "@media(hover: hover)": {
      ":hover": {
        "backgroundColor": "rgba(0, 0, 0, 0.05)",
      },
    },
    ":active": {
      "backgroundColor": "#55269A",
      "color": "#fff",
    },
  })
  let activeNavItem = css({
    "backgroundColor": "#9146ff",
    "color": "#fff",
    "@media(hover: hover)": {
      ":hover": {
        "backgroundColor": "#9146ff",
      },
    },
    ":active": {
      "backgroundColor": "#55269A",
      "color": "#fff",
    },
  })
  let eyesAnimation = keyframes({
    "40%": {
      "transform": "scaleY(1)",
    },
    "50%": {
      "transform": "scaleY(0.5)",
    },
    "60%": {
      "transform": "scaleY(1)",
    },
  })
  let eyes = css({
    "animation": `4s infinite linear ${eyesAnimation}`,
    "transformOrigin": "50% 30%",
  })
  let externalLinks = css({
    "alignSelf": "center",
    "padding": 10,
    "textAlign": "right",
  })
  let github = css({
    "color": Theme.mainPurple,
    "textDecoration": "none",
  })
  let copyright = css({
    "fontSize": 14,
  })
}

type link = {
  emoji: string,
  title: string,
  href: string,
}

let links = [
  {
    emoji: `👋`,
    title: `Bienvenue`,
    href: `/`,
  },
  {
    emoji: `💻`,
    title: `Let's code`,
    href: `/code`,
  },
  {
    emoji: `💬`,
    title: `Discussions`,
    href: `/discuss`,
  },
]

@react.component
let make = () => {
  let (speech, setSpeech) = React.useState(() => None)

  let timeoutRef = React.useRef(None)

  let clearTimeout = React.useCallback0(() => {
    switch timeoutRef.current {
    | Some(timeoutId) => clearTimeout(timeoutId)
    | None => ()
    }
  })

  React.useEffect0(() => Some(clearTimeout))

  <header className=Styles.container>
    <div
      className={switch speech {
      | Some(_) => Styles.speakingLogoContainer
      | None => Styles.logoContainer
      }}>
      <svg viewBox="0 0 2400 2800" width="36" height="42">
        <path fill="#fff" d="M2200 1300l-400 400h-400l-350 350v-350H600V200h1600z" />
        <g fill=Theme.mainPurple>
          <path
            d="M500 0L0 500v1800h600v500l500-500h400l900-900V0H500zm1700 1300l-400 400h-400l-350 350v-350H600V200h1600v1100z"
          />
          <path d="M1700 550h200v600h-200zM1150 550h200v600h-200z" className=Styles.eyes />
        </g>
      </svg>
      {switch speech {
      | Some(speech) =>
        <div className=Styles.speech>
          <svg className=Styles.speechPointer viewBox="0 0 10 10" width="10" height="10">
            <polygon fill=Styles.speechBackgroundColor points="3 5, 10 0, 10 10" />
          </svg>
          {speech->React.string}
        </div>
      | None => React.null
      }}
    </div>
    <nav className=Styles.nav>
      {links
      ->Array.mapWithIndex(({href, emoji, title}, index) => {
        let delay = index * 100
        <React.Fragment key=href>
          <Link
            style={ReactDOM.Style.make(~animationDelay=`${delay->Int.toString}ms`, ())}
            matchSubroutes={href !== "/"}
            onMouseEnter=?{Environment.supportsHover
              ? Some(
                  _ => {
                    clearTimeout()
                    setSpeech(_ => Some(title))
                  },
                )
              : None}
            onMouseLeave=?{Environment.supportsHover
              ? Some(
                  _ => {
                    let timeoutId = setTimeout(() => {
                      setSpeech(_ => None)
                    }, 500)
                    timeoutRef.current = Some(timeoutId)
                  },
                )
              : None}
            onClick={_ => {
              clearTimeout()
              setSpeech(_ => None)
            }}
            href
            className=Styles.navItem
            activeClassName=Styles.activeNavItem
            title>
            <div ariaHidden=true> {emoji->React.string} </div>
          </Link>
          <Spacer />
        </React.Fragment>
      })
      ->React.array}
    </nav>
    <div className=Styles.externalLinks>
      <a
        className=Styles.github
        href="https://github.com/bloodyowl/twitch"
        target="_blank"
        rel="noopener">
        {`Source code`->React.string}
      </a>
      <div className=Styles.copyright> {`© bloodyowl 2021`->React.string} </div>
    </div>
  </header>
}
