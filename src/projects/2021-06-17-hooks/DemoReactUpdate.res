module Styles = {
  open Emotion
  let container = css({
    "display": "flex",
    "flexDirection": "column",
    "alignItems": "center",
    "justifyContent": "center",
    "alignSelf": "stretch",
    "flexGrow": 1,
  })
  let button = css({
    "border": "none",
    "backgroundColor": Theme.mainPink,
    "color": "#fff",
    "borderRadius": 8,
    "fontFamily": "inherit",
    "fontSize": "inherit",
    "padding": 10,
    "cursor": "pointer",
  })
}

type action =
  | Increment
  | Decrement
  | AutoIncrement
  | StopAutoIncrement

@react.component
let make = () => {
  let autoIncrementTimeoutRef = React.useRef(None)
  let (state, dispatch) = ReactUpdate.useReducer((state, action) => {
    switch action {
    | Increment => Update(state + 1)
    | Decrement => Update(state - 1)
    | AutoIncrement =>
      UpdateWithSideEffects(
        state + 1,
        ({send}) => {
          let timeoutId = setTimeout(() => {
            send(AutoIncrement)
          }, 100)
          autoIncrementTimeoutRef.current = Some(timeoutId)
          Some(() => clearTimeout(timeoutId))
        },
      )
    | StopAutoIncrement =>
      SideEffects(
        _ => {
          switch autoIncrementTimeoutRef.current {
          | Some(timeoutId) => clearTimeout(timeoutId)
          | None => ()
          }
          None
        },
      )
    }
  }, 0)

  <div className=Styles.container>
    <h1> {state->React.int} </h1>
    <button className=Styles.button onClick={_ => dispatch(Increment)}>
      {"Increment"->React.string}
    </button>
    <button className=Styles.button onClick={_ => dispatch(Decrement)}>
      {"Decrement"->React.string}
    </button>
    <button
      className=Styles.button
      onClick={_ => {
        dispatch(StopAutoIncrement)
        dispatch(AutoIncrement)
      }}>
      {"Start auto increment"->React.string}
    </button>
    <button className=Styles.button onClick={_ => dispatch(StopAutoIncrement)}>
      {"Stop auto increment"->React.string}
    </button>
  </div>
}
