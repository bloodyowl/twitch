@react.component
let make = (
  ~href,
  ~matchHref=?,
  ~className=?,
  ~style=?,
  ~activeClassName=?,
  ~activeStyle=?,
  ~matchSubroutes=false,
  ~title=?,
  ~children,
  ~preserveQueryString=false,
  ~onMouseEnter=?,
  ~onMouseLeave=?,
  ~onClick=?,
) => {
  let url = Router.useUrl()
  let path = url.path->List.reduce("", (acc, item) => acc ++ "/" ++ item)
  let compareHref = matchHref->Option.getWithDefault(href)
  let isActive = matchSubroutes
    ? (path ++ "/")->String.startsWith(compareHref) || path->String.startsWith(compareHref)
    : path === compareHref || path ++ "/" === compareHref
  let queryString = if preserveQueryString {
    url.search == "" ? "" : (href->String.includes("?") ? "&" : "?") ++ url.search
  } else {
    ""
  }
  let actualHref = Router.makeHref(href) ++ queryString

  let onClick = React.useCallback2(event => {
    switch (ReactEvent.Mouse.metaKey(event), ReactEvent.Mouse.ctrlKey(event)) {
    | (false, false) =>
      event->ReactEvent.Mouse.preventDefault
      Router.push(actualHref)
    | _ => ()
    }
    switch onClick {
    | Some(onClick) => onClick(event)
    | None => ()
    }
  }, (actualHref, onClick))

  <a
    ?onMouseEnter
    ?onMouseLeave
    href=actualHref
    ?title
    className={Emotion.cx(
      [className, isActive ? activeClassName : None]->Belt.Array.keepMap(identity),
    )}
    style=?{switch (style, isActive ? activeStyle : None) {
    | (Some(a), Some(b)) => Some(ReactDOM.Style.combine(a, b))
    | (Some(a), None) => Some(a)
    | (None, Some(b)) => Some(b)
    | (None, None) => None
    }}
    onClick={onClick}>
    children
  </a>
}
