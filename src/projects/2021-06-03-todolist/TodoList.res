module Styles = {
  open Emotion

  let maxWidth = 400

  let container = css({
    "display": "flex",
    "flexDirection": "column",
    "alignItems": "center",
    "flexGrow": 1,
    "alignSelf": "stretch",
    "margin": "0 10px",
    "paddingBottom": 50,
    "overflowY": "auto",
  })
  let title = css({
    "fontWeight": "400",
    "textAlign": "center",
  })
  let removeButton = css({
    "backgroundColor": "transparent",
    "border": "none",
    "padding": "8px 0",
    "margin": 0,
    "display": "flex",
    "cursor": "pointer",
    ":active": {
      "opacity": 0.7,
    },
  })
  let list = css({
    "listStyleType": "none",
    "width": "100%",
    "maxWidth": maxWidth,
    "margin": 0,
    "padding": 0,
  })
  let input = css({
    "width": "100%",
    "maxWidth": maxWidth,
    "backgroundColor": Theme.mainBackgroundColor,
    "color": Theme.mainTextColor,
    "fontFamily": "inherit",
    "fontSize": "inherit",
    "padding": "10px",
    "borderRadius": 8,
    "border": "none",
    "position": "sticky",
    "bottom": 15,
    "boxSizing": "border-box",
    "boxShadow": `0 0 0 1px ${Theme.mainContrastAccentedBackgroundColor}, 0 5px 10px ${Theme.mainContrastBackgroundColor}`,
  })
  let listItem = css({
    "display": "flex",
    "flexDirection": "row",
    "alignItems": "center",
    "padding": "8px 10px",
  })
  let todoText = css({
    "flexGrow": 1,
    "display": "flex",
    "flexDirection": "row",
    "justifyContent": "flex-start",
    "fontSize": 18,
    "transition": "300ms ease-in-out opacity",
  })
  let checkedTodoText = cx([
    todoText,
    css({
      "opacity": 0.5,
    }),
  ])
  let todoTextStrikethroughBox = css({
    "position": "relative",
  })
  let strikethroughAnimation = keyframes({
    "from": {
      "transform": "translateY(-50%) translateY(2px) scaleX(0)",
    },
  })
  let strikethrough = css({
    "position": "absolute",
    "top": "50%",
    "left": -3,
    "right": -3,
    "transformOrigin": "0 50%",
    "transform": "translateY(-50%) translateY(2px)",
    "height": 1,
    "backgroundColor": Theme.mainTextColor,
    "animation": `300ms ease-in-out ${strikethroughAnimation}`,
  })
}

module Uuid = {
  @module("uuid") external v4: unit => string = "v4"
}

type todo = {
  id: string,
  title: string,
  checked: bool,
}

type state = {
  todos: array<todo>,
  input: string,
}

@react.component
let make = () => {
  let (state, setState) = React.useState(() => {
    todos: [],
    input: "",
  })

  let onInputChange = event => {
    let target = event->ReactEvent.Form.target
    let input = target["value"]
    setState(state => {...state, input: input})
  }

  let onInputKeyDown = event => {
    if event->ReactEvent.Keyboard.key === "Enter" {
      event->ReactEvent.Keyboard.preventDefault
      setState(state => {
        todos: state.todos->Array.concat([{id: Uuid.v4(), title: state.input, checked: false}]),
        input: "",
      })
    }
  }

  <div className=Styles.container>
    <h1 className=Styles.title> {`Todo list`->React.string} </h1>
    <ul className=Styles.list>
      {state.todos
      ->Array.map(todo => {
        <li key=todo.id className=Styles.listItem>
          <input
            id=todo.id
            type_="checkbox"
            checked=todo.checked
            onChange={event => {
              let target = event->ReactEvent.Form.target
              let checked = target["checked"]
              setState(state => {
                ...state,
                todos: state.todos->Array.map(item => {
                  item.id === todo.id ? {...item, checked: checked} : item
                }),
              })
            }}
          />
          <Spacer width="10px" />
          <label
            htmlFor=todo.id className={todo.checked ? Styles.checkedTodoText : Styles.todoText}>
            <div className=Styles.todoTextStrikethroughBox>
              {todo.title->React.string}
              {todo.checked ? <div className=Styles.strikethrough /> : React.null}
            </div>
          </label>
          <button
            ariaLabel="Delete"
            className=Styles.removeButton
            onClick={_ => {
              setState(state => {
                ...state,
                todos: state.todos->Array.filter(item => {
                  item.id !== todo.id
                }),
              })
            }}>
            <svg viewBox="0 0 10 10" width="10" height="10">
              <g strokeWidth="2" stroke="#EE4E8F">
                <line x1="0" y1="0" x2="10" y2="10" /> <line x1="10" y1="0" x2="0" y2="10" />
              </g>
            </svg>
          </button>
        </li>
      })
      ->React.array}
    </ul>
    <Spacer height="15px" />
    <input
      className=Styles.input
      type_="text"
      value=state.input
      onChange={onInputChange}
      onKeyDown={onInputKeyDown}
      placeholder="Write a new task"
    />
  </div>
}
