type dimensions = {width: int, height: int}

module ResizeObserverEntry = {
  type t
  type contentRect = {width: float, height: float}
  @get external contentRect: t => contentRect = "contentRect"
}

module ResizeObserver = {
  type t
  @new external make: (array<ResizeObserverEntry.t> => unit) => t = "ResizeObserver"
  @send external observe: (t, Dom.element) => unit = "observe"
  @send external unobserve: (t, Dom.element) => unit = "unobserve"
}

let useResizeObserver = (element: React.ref<Nullable.t<Dom.element>>) => {
  let (dimensions, setDimensions) = React.useState(() => None)
  React.useEffect0(() => {
    switch element.current->Nullable.toOption {
    | Some(element) =>
      let resizeObserver = ResizeObserver.make(entries => {
        entries->Array.forEach(entry => {
          let contentRect = entry->ResizeObserverEntry.contentRect
          let width = contentRect.width->Int.fromFloat
          let height = contentRect.height->Int.fromFloat
          setDimensions(prevState => {
            // Makes sure we don't trigger a rerender if the dimensions are the same
            switch prevState {
            | Some(prevDimensions) =>
              if prevDimensions.width != width || prevDimensions.height != height {
                Some({width: width, height: height})
              } else {
                prevState
              }
            | None => Some({width: width, height: height})
            }
          })
        })
      })
      resizeObserver->ResizeObserver.observe(element)
      Some(() => resizeObserver->ResizeObserver.unobserve(element))
    | None => None
    }
  })
  dimensions
}
