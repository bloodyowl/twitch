@react.component
let make: (
  ~href: string,
  ~matchHref: string=?,
  ~className: string=?,
  ~style: ReactDOM.Style.t=?,
  ~activeClassName: string=?,
  ~activeStyle: ReactDOM.Style.t=?,
  ~matchSubroutes: bool=?,
  ~title: string=?,
  ~children: React.element,
  ~preserveQueryString: bool=?,
  ~onMouseEnter: ReactEvent.Mouse.t => unit=?,
  ~onMouseLeave: ReactEvent.Mouse.t => unit=?,
  ~onClick: ReactEvent.Mouse.t => unit=?,
) => React.element
