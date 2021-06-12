module Image = {
  type t = {
    url: string,
    width: int,
    height: int,
  }
}

module List = {
  type t = {
    id: string,
    thumbnail: Image.t,
    title: string,
    likes: int,
  }

  let query = () =>
    Request.make(
      ~url="/data/gallery/list.json",
      ~method=#GET,
      ~responseType=(JsonAsAny: Request.responseType<array<t>>),
      (),
    )->RequestUtils.handleErrors
}

module Detail = {
  type t = {
    id: string,
    thumbnail: Image.t,
    image: Image.t,
    title: string,
    likes: int,
  }

  let query = (~id) =>
    Request.make(
      ~url=`/data/gallery/post/${id}.json`,
      ~method=#GET,
      ~responseType=(JsonAsAny: Request.responseType<t>),
      (),
    )->RequestUtils.handleErrors
}

@module("uuid") external uuidV4: unit => string = "v4"

module Comment = {
  type t = {
    id: string,
    username: string,
    comment: string,
  }

  let fakeServerState = MutableMap.String.make()

  let query = (~postId) => {
    Future.make(resolve => {
      let timeoutId = setTimeout(() => {
        resolve(Ok(fakeServerState->MutableMap.String.getWithDefault(postId, [])))
      }, 300)
      Some(() => clearTimeout(timeoutId))
    })
  }

  let post = (~postId, ~comment) => {
    Future.make(resolve => {
      let timeoutId = setTimeout(() => {
        let comment = {
          id: uuidV4(),
          // Let's pretend there's an auth
          username: "bloodyowl",
          comment: comment,
        }
        fakeServerState->MutableMap.String.update(postId, comments => {
          Some(comments->Option.getWithDefault([])->Array.concat([{comment}]))
        })
        resolve(Ok(comment))
      }, 500)
      Some(() => clearTimeout(timeoutId))
    })
  }
}
