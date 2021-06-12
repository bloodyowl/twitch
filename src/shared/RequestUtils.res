open Request

let handleErrors = request => {
  request
  ->Future.mapError(~propagateCancel=true, error =>
    switch error {
    | #NetworkRequestFailed => Errors.NetworkRequestFailed
    | #Timeout => Errors.Timeout
    }
  )
  ->Future.mapResult(~propagateCancel=true, ({response}) => {
    switch response {
    | Some(response) => Ok(response)
    | None => Error(Errors.EmptyResponse)
    }
  })
}
