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

// Our component can receive any type of data.
// The `'a` parameter represents something that unknown type, it's called a type parameter (often called a generic).
// For that reason, not knowing what's inside, we can't hardcode in our components things that assume a given form,
// That's why we need to pass `render` and `matchesSearch` from the outside, because the caller knows the type.
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
    // We've got an container that we measure (using the ref and useResizeObserver).
    // That gives us the virtualized list viewport height (kind of the height of a window we're look our list through)
    <div className=Styles.container ref={ReactDOM.Ref.domRef(containerRef)}>
      {
        // Given we need the dimension to know what to render, we wait for the first measurement until we do anything
        switch dimensions {
        | Some({height}) =>
          // That's the index of the first item we need to render.
          // `threshold` is a little extra space in which we render elements even though
          // they're not currently visible. It helps us catch up with fast scrolling.
          // The `max` is so that the lowest index we're getting is 0 (and not -3 given the threshold)
          let startRenderIndex = max(0, (scrollTop - threshold) / rowHeight)
          // Same logic there, except it's the last element that needs to be rendered
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
              {
                // Get a small array containing the indexes we'll need to render
                Belt.Array.range(startRenderIndex, endRenderIndex)
                // Get the data for each index
                ->Belt.Array.keepMap(index => data[index])
                ->Array.mapWithIndex(((key, user), index) =>
                  // Each element is positionned absolutely, so that it doesn't depend of its previous siblings.
                  // Given the whole point is about not rendering elements that aren't visible, the previous siblings likely aren't there
                  // Also: DON'T FORGET TO PASS A KEY HERE
                  <div
                    key
                    style={ReactDOM.Style.make(
                      ~position="absolute",
                      ~left="0",
                      ~right="0",
                      ~top={
                        let top = (startRenderIndex + index) * rowHeight
                        // The element is `startRenderIndex` + the index in this array,
                        // because the array is a subset of data starting at `startRenderIndex`
                        `${top->Int.toString}px`
                      },
                      ~height=`${rowHeight->Int.toString}px`,
                      (),
                    )}>
                    {render(user)}
                  </div>
                )
                ->React.array
              }
            </div>
          </div>
        | None => React.null
        }
      }
    </div>
  </div>
}
