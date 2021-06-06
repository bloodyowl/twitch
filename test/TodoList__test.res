open ReactTest

testWithReact("TodoList", container => {
  act(() => {
    ReactDOM.render(<TodoList />, container)
  })

  containsElement(~message="Contains input to create todo", container, `input[type="text"]`)

  let input = container->querySelector(`input[type="text"]`)

  act(() => {
    switch input {
    | Some(input) => input->Simulate.changeWithEvent({"target": {"value": "First todo"}})
    | None => ()
    }
  })

  act(() => {
    switch input {
    | Some(input) => input->Simulate.keyDownWithEvent({"key": "Enter"})
    | None => ()
    }
  })

  containsElementWithPartialText(
    ~message="Contains submitted todo",
    container,
    `label`,
    `First todo`,
  )
  containsElement(~message="Contains a checkbox", container, `input[type="checkbox"]`)
  containsElement(~message="Contains a deletion button", container, `button[aria-label="Delete"]`)

  let deleteButton = container->querySelector(`button[aria-label="Delete"]`)

  act(() => {
    switch deleteButton {
    | Some(deleteButton) => deleteButton->Simulate.click
    | None => ()
    }
  })

  doesNotContainElementWithPartialText(
    ~message="Removed the todo on delete",
    container,
    `label`,
    `First todo`,
  )
})
