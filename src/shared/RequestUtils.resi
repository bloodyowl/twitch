let handleErrors: Future.t<result<Request.response<'a>, Request.error>> => Future.t<
  result<'a, Errors.t>,
>
