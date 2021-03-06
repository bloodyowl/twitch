module UserCard = {
  module Styles = {
    open Emotion
    let container = css({
      "display": "flex",
      "flexDirection": "row",
      "alignItems": "center",
      "padding": "10px",
      "justifyContent": "space-between",
    })
    let group = css({
      "display": "flex",
      "flexDirection": "row",
      "alignItems": "center",
      "flexGrow": 1,
      "flexShrink": 1,
    })
    let avatar = css({
      "borderRadius": "100%",
    })
    let name = css({
      "fontWeight": "700",
      "whiteSpace": "nowrap",
    })
    let age = css({
      "whiteSpace": "nowrap",
      "textOverflow": "ellipsis",
      "overflow": "hidden",
      "width": 1,
      "flexGrow": 1,
    })
    let id = css({
      "opacity": 0.5,
      "whiteSpace": "nowrap",
      "width": 1,
      "textOverflow": "ellipsis",
      "overflow": "hidden",
      "flexGrow": 1,
      "textAlign": "right",
      "fontFamily": "monospace",
      "fontSize": 12,
    })
    let extensibleSpacer = css({
      "width": 1,
      "flexGrow": 1,
    })
  }
  @react.component
  let make = (~user: User.t) => {
    <div className=Styles.container>
      <div className=Styles.group>
        <img src={user.picture} alt="" width="42" height="42" className=Styles.avatar />
        <Spacer width="10px" />
        <div className=Styles.name> {`${user.firstName} ${user.lastName}`->React.string} </div>
        <Spacer width="20px" />
        <div className=Styles.age> {`${user.age->Int.toString} years old`->React.string} </div>
      </div>
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
        `${user.firstName} ${user.lastName} ${user.firstName}`
        ->String.toUpperCase
        ->String.includes(upperCaseSearch) ||
        user.age->Int.toString->String.includes(upperCaseSearch) || (
          idRegex->RegExp.test(search) ? user.id->String.includes(search) : false
        )
      }}
    />
  }
}
