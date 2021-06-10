module UserCard = {
  module Styles = {
    open Emotion
    let container = css({
      "display": "flex",
      "flexDirection": "row",
      "alignItems": "center",
      "padding": "10px",
    })
    let avatar = css({
      "borderRadius": "100%",
    })
    let name = css({
      "fontWeight": "700",
    })
    let id = css({
      "opacity": 0.5,
    })
  }
  @react.component
  let make = (~user: User.t) => {
    <div className=Styles.container>
      <img src={user.picture} alt="" width="42" height="42" className=Styles.avatar />
      <Spacer width="10px" />
      <div className=Styles.name> {`${user.firstName} ${user.lastName}`->React.string} </div>
      <Spacer width="20px" />
      <div> {`${user.age->Int.toString} years old`->React.string} </div>
      <Spacer width="20px" />
      <div className=Styles.id> {user.id->React.string} </div>
    </div>
  }
}

let idRegex = %re("/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/")

@react.component
let make = () => {
  let (users, setUsers) = React.useState(() => AsyncData.NotAsked)

  React.useEffect0(() => {
    setUsers(_ => Loading)
    let request = User.queryList()
    request
    ->Future.mapOk(users => users->Array.map(user => (user.id, user)))
    ->Future.get(users => setUsers(_ => Done(users)))
    Some(() => request->Future.cancel)
  })

  switch users {
  | NotAsked => React.null
  | Loading => <ActivityIndicator />
  | Done(Error(_)) => <ErrorPage text="An error occured" />
  | Done(Ok(data)) =>
    <VirtualizedList
      rowHeight=62
      data
      render={user => <UserCard user />}
      matchesSearch={(user, search) => {
        let upperCaseSearch = search->String.toUpperCase
        user.firstName->String.toUpperCase->String.includes(upperCaseSearch) ||
        user.lastName->String.toUpperCase->String.includes(upperCaseSearch) ||
        user.age->Int.toString->String.includes(upperCaseSearch) || (
          idRegex->RegExp.test(search) ? user.id->String.includes(search) : false
        )
      }}
    />
  }
}
