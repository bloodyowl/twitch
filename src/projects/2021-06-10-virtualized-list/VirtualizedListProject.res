@react.component
let make = () => {
  let (users, setUsers) = React.useState(() => AsyncData.NotAsked)

  React.useEffect0(() => {
    setUsers(_ => Loading)
    let request = User.queryList()
    request->Future.get(users => setUsers(_ => Done(users)))
    Some(() => request->Future.cancel)
  })

  switch users {
  | NotAsked => React.null
  | Loading => <ActivityIndicator />
  | Done(Error(_)) => <ErrorPage text="An error occured" />
  | Done(Ok(data)) => <VirtualizedList data />
  }
}
