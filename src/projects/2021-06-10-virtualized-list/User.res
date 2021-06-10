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
  )
  ->Future.mapError(~propagateCancel=true, error =>
    switch error {
    | #NetworkRequestFailed => Errors.NetworkRequestFailed
    | #Timeout => Errors.Timeout
    }
  )
  ->Future.mapResult(({response}) => {
    switch response {
    | Some(response) => Ok(response)
    | None => Error(Errors.EmptyResponse)
    }
  })
}
