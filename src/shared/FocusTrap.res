external elementAsObject: Dom.element => {..} = "%identity"

let getFocusableElements = element => {
  let element = element->elementAsObject
  let focusable = element["querySelectorAll"](.
    "a[href], area[href], input:not([disabled]), select:not([disabled]), textarea:not([disabled]), button:not([disabled]), iframe, object, embed, *[tabindex], *[contenteditable]",
  )
  Array.from(focusable)
}

@react.component
let make = (~onPressEscape=?, ~className=?, ~children) => {
  let trapRef = React.useRef(Nullable.null)
  let previouslyFocusedRef = React.useRef(Nullable.null)

  let onKeyDown = React.useCallback1(event => {
    switch event->ReactEvent.Keyboard.key {
    | "Escape" =>
      switch onPressEscape {
      | Some(onPressEscape) => onPressEscape()
      | None => ()
      }
    | "Tab" =>
      switch trapRef.current->Nullable.toOption {
      | Some(trapElement) =>
        let target = event->ReactEvent.Keyboard.target
        let focusable = getFocusableElements(trapElement)
        let first = focusable[0]
        let last = focusable[Array.length(focusable) - 1]
        switch (first, last) {
        | (Some(first), Some(last)) =>
          let isTargetFirst = target === first
          let isTargetLast = target === last
          let isShiftKeyPressed = event->ReactEvent.Keyboard.shiftKey
          if isTargetFirst && isShiftKeyPressed {
            event->ReactEvent.Keyboard.preventDefault
            last["focus"](. undefined)
          } else if isTargetLast && !isShiftKeyPressed {
            event->ReactEvent.Keyboard.preventDefault
            first["focus"](. undefined)
          }
        // No focusable elements, can skip
        | _ => ()
        }
      | None => ()
      }
    | _ => ()
    }
  }, [onPressEscape])

  React.useEffect0(() => {
    switch trapRef.current->Nullable.toOption {
    | Some(trapElement) =>
      previouslyFocusedRef.current = document["activeElement"]
      let focusable = getFocusableElements(trapElement)
      switch focusable[0] {
      | Some(element) =>
        let () = element["focus"](. undefined)
      | None => ()
      }
      Some(
        () => {
          switch previouslyFocusedRef.current->Nullable.toOption {
          | Some(previouslyFocusedElement) => previouslyFocusedElement["focus"](. undefined)
          | None => ()
          }
        },
      )
    | None => None
    }
  })

  <div ?className ref={ReactDOM.Ref.domRef(trapRef)} onKeyDown> children </div>
}
