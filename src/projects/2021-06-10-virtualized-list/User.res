type t = {
  firstName: string,
  lastName: string,
  picture: string,
  id: string,
  age: int,
}

let queryList = () => {
  Request.make(
    ~url="/data/users.json",
    ~method=#GET,
    ~responseType=(JsonAsAny: Request.responseType<array<t>>),
    (),
  )->RequestUtils.handleErrors
}
