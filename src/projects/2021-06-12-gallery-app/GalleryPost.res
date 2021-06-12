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
      ~responseType=(JsonAsAny: Request.responseType<array<t>>),
      (),
    )->RequestUtils.handleErrors
}
