open Emotion

module Styles = {
  let spacer = css({"flexShrink": 0.0, "flexGrow": 0.0})
}

@react.component
let make = (~width="10px", ~height="10px", ()) => {
  let className = React.useMemo2(() => {
    css({"width": width, "height": height})
  }, (width, height))
  <div className={cx([Styles.spacer, className])} />
}
