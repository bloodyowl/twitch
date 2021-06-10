module Styles = {
  open Emotion
  let root = css({
    "display": "flex",
    "flexDirection": "column",
    "flexGrow": 1,
    "alignSelf": "stretch",
  })
  let container = css({
    "display": "flex",
    "flexDirection": "column",
    "flexGrow": 1,
    "alignSelf": "stretch",
  })
  let scrollView = css({
    "overflowY": "auto",
    "display": "flex",
    "flexDirection": "column",
    "flexGrow": 1,
    "height": 1,
    "justifyContent": "flex-start",
  })
  let scrollViewContents = css({
    "display": "block",
    "position": "relative",
    "flexShrink": 0,
  })
  let search = css({
    "margin": 10,
    "borderRadius": 8,
    "border": "none",
    "fontSize": "inherit",
    "fontFamily": "inherit",
    "padding": "5px 10px",
    "backgroundColor": Theme.mainBackgroundColor,
  })
}
@react.component
let make = (
  ~data: array<(string, 'a)>,
  ~rowHeight,
  ~threshold=200,
  ~render: 'a => React.element,
  ~matchesSearch: ('a, string) => bool,
) => {
  let (searchInput, setSearchInput) = React.useState(() => None)

  let data = React.useMemo1(() => {
    switch searchInput {
    | Some(searchInput) => data->Array.filter(((_, user)) => matchesSearch(user, searchInput))
    | None => data
    }
  }, [searchInput])

  let totalHeight = rowHeight * data->Array.length
  let containerRef = React.useRef(Nullable.null)

  let (scrollTop, setScrollTop) = React.useState(() => 0)
  let dimensions = ResizeObserver.useResizeObserver(containerRef)

  <div className=Styles.root>
    <input
      className=Styles.search
      type_="text"
      placeholder={"Search ..."}
      value={searchInput->Option.getWithDefault("")}
      onChange={event => {
        let target = event->ReactEvent.Form.target
        let value = target["value"]
        setSearchInput(_ => value === "" ? None : Some(value))
      }}
    />
    <div className=Styles.container ref={ReactDOM.Ref.domRef(containerRef)}>
      {switch dimensions {
      | Some({height}) =>
        let startRenderIndex = max(0, (scrollTop - threshold) / rowHeight)
        let endRenderIndex = min(
          startRenderIndex + (height + threshold) / rowHeight,
          data->Array.length,
        )
        <div
          className=Styles.scrollView
          onScroll={event => {
            let target = event->ReactEvent.UI.target
            let scrollTop = target["scrollTop"]
            setScrollTop(_ => scrollTop)
          }}>
          <div
            className=Styles.scrollViewContents
            style={ReactDOM.Style.make(~height=`${totalHeight->Int.toString}px`, ())}>
            {Belt.Array.range(startRenderIndex, endRenderIndex)
            ->Belt.Array.keepMap(index => data[index])
            ->Array.mapWithIndex(((key, user), index) =>
              <div
                key
                style={ReactDOM.Style.make(
                  ~position="absolute",
                  ~left="0",
                  ~right="0",
                  ~top={
                    let top = (startRenderIndex + index) * rowHeight
                    `${top->Int.toString}px`
                  },
                  ~height=`${rowHeight->Int.toString}px`,
                  (),
                )}>
                {render(user)}
              </div>
            )
            ->React.array}
          </div>
        </div>
      | None => React.null
      }}
    </div>
  </div>
}
