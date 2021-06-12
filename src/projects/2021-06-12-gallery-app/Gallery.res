module Styles = {
  open Emotion
  let container = css({
    "display": "flex",
    "flexDirection": "row",
    "flexWrap": "wrap",
    "alignSelf": "stretch",
  })
  let image = css({
    "width": "33.333333%",
    "padding": 10,
    "boxSizing": "border-box",
    "backgroundColor": "transparent",
    "border": "none",
    "cursor": "pointer",
  })
  let imageRatioContainer = css({
    "display": "block",
    "paddingBottom": "100%",
    "position": "relative",
  })
  let imageElement = css({
    "position": "absolute",
    "width": "100%",
    "left": 0,
    "top": "50%",
    "transform": "translateY(-50%)",
  })
}

let dialogMountNode = document["createElement"](. "div")
document["body"]["appendChild"](. dialogMountNode)

module Dialog = {
  module Styles = {
    open Emotion
    let container = css({
      "position": "fixed",
      "top": 0,
      "left": 0,
      "bottom": 0,
      "right": 0,
      "zIndex": 100,
      "display": "flex",
      "flexDirection": "column",
      "alignItems": "center",
      "justifyContent": "center",
    })
    let underlay = css({
      "position": "fixed",
      "top": 0,
      "left": 0,
      "bottom": 0,
      "right": 0,
      "backgroundColor": Theme.mainContrastColor,
      "backdropFilter": "blur(4px)",
    })
  }

  @react.component
  let make = (~children, ~onClose) => {
    <FocusTrap onPressEscape=onClose>
      <div className=Styles.container>
        <div
          className=Styles.underlay
          tabIndex=0
          role="button"
          ariaLabel="Close"
          onClick={_ => onClose()}
        />
        children
      </div>
    </FocusTrap>
  }
}

module PostComments = {
  module Styles = {
    open Emotion
    let container = css({
      "display": "flex",
      "flexDirection": "column",
      "flexGrow": 1,
    })
    let comments = css({
      "overflowY": "auto",
      "flexGrow": 1,
      "display": "flex",
      "flexDirection": "column",
      "transform": "translateZ(0)",
    })
    let loader = css({
      "display": "flex",
      "flexDirection": "column",
      "flexGrow": 1,
      "alignItems": "center",
      "justifyContent": "center",
    })
    let comment = css({
      "padding": 10,
    })
    let input = css({
      "background": "transparent",
      "border": "none",
      "fontFamily": "inherit",
      "fontSize": "inherit",
      "padding": 10,
      "boxSizing": "border-box",
      "width": "100%",
      "color": "inherit",
    })
  }

  @react.component
  let make = (~imageId) => {
    let (comments, setComments) = React.useState(() => AsyncData.NotAsked)
    let (newComment, setNewComment) = React.useState(() => AsyncData.NotAsked)
    let (commentInput, setCommentInput) = React.useState(() => "")

    React.useEffect0(() => {
      setComments(_ => Loading)
      let request = GalleryPost.Comment.query(~postId=imageId)
      request->Future.get(postDetail => {
        setComments(_ => Done(postDetail))
      })
      Some(() => request->Future.cancel)
    })

    <div className=Styles.container>
      <div className=Styles.comments>
        {switch comments {
        | NotAsked => React.null
        | Loading =>
          <div className=Styles.loader> <ActivityIndicator color=Theme.mainContrastColor /> </div>
        | Done(Error(_)) => <ErrorPage text="An error occured loading the image" />
        | Done(Ok(comments)) =>
          comments
          ->Array.map(comment => {
            <div key=comment.id className=Styles.comment>
              <strong> {comment.username->React.string} </strong>
              {` • `->React.string}
              <span> {comment.comment->React.string} </span>
            </div>
          })
          ->React.array
        }}
      </div>
      <input
        className=Styles.input
        type_="text"
        value=commentInput
        placeholder="Type a comment ..."
        onChange={event => {
          let target = event->ReactEvent.Form.target
          let value = target["value"]
          setCommentInput(_ => value)
        }}
        disabled={newComment->AsyncData.isLoading}
        onKeyDown={event => {
          if event->ReactEvent.Keyboard.key === "Enter" {
            let trimmedComment = commentInput->String.trim
            if trimmedComment !== "" {
              setNewComment(_ => Loading)
              GalleryPost.Comment.post(
                ~postId=imageId,
                ~comment=commentInput->String.trim,
              )->Future.get(comment => {
                switch comment {
                | Ok(comment) =>
                  setComments(existingComments =>
                    existingComments->AsyncData.map(doneComments =>
                      doneComments->Result.map(comments => comments->Array.concat([comment]))
                    )
                  )
                  setNewComment(_ => Done(comment))
                  setCommentInput(_ => "")
                | Error(_) => ()
                }
              })
            }
          }
        }}
      />
    </div>
  }
}

module FullSizePicture = {
  module Styles = {
    open Emotion
    let container = css({
      "position": "relative",
      "alignSelf": "stretch",
    })
    let imageContainer = css({
      "width": "100%",
      "maxWidth": 1000,
      "margin": "auto",
      "display": "flex",
      "flexDirection": "row",
      "alignItems": "stretch",
    })
    let imageRatioContainer = css({
      "position": "relative",
      "display": "block",
      "flexGrow": 1,
    })
    let sidebar = css({
      "width": 300,
      "backgroundColor": Theme.mainBackgroundColor,
      "display": "flex",
      "flexDirection": "column",
    })
    let image = css({
      "position": "absolute",
      "width": "100%",
      "height": "auto",
      "left": 0,
      "top": "50%",
      "transform": "translateY(-50%)",
    })
  }

  @react.component
  let make = (~imageId) => {
    let (image, setImage) = React.useState(() => AsyncData.NotAsked)

    React.useEffect0(() => {
      setImage(_ => Loading)
      let request = GalleryPost.Detail.query(~id=imageId)
      request->Future.get(postDetail => {
        setImage(_ => Done(postDetail))
      })
      Some(() => request->Future.cancel)
    })

    <div className=Styles.container>
      {switch image {
      | NotAsked => React.null
      | Loading => <ActivityIndicator color=Theme.mainBackgroundColor />
      | Done(Error(_)) => <ErrorPage text="An error occured loading the image" />
      | Done(Ok(image)) =>
        <div className=Styles.imageContainer>
          <div className=Styles.imageRatioContainer>
            <div
              style={ReactDOM.Style.make(
                ~paddingBottom={
                  let ratio =
                    image.image.height->Int.toFloat /. image.image.width->Int.toFloat *. 100.0
                  `${ratio->Float.toString}%`
                },
                (),
              )}>
              <img src={"/images/" ++ image.image.url} alt="" className=Styles.image />
            </div>
          </div>
          <div className=Styles.sidebar> <PostComments imageId /> </div>
        </div>
      }}
    </div>
  }
}

@react.component
let make = () => {
  let (galleryItems, setGalleryItems) = React.useState(() => AsyncData.NotAsked)
  let (openImageId, setOpenImageId) = React.useState(() => None)

  React.useEffect0(() => {
    setGalleryItems(_ => Loading)
    let request = GalleryPost.List.query()
    request->Future.get(postList => {
      setGalleryItems(_ => Done(postList))
    })
    Some(() => request->Future.cancel)
  })

  <>
    {switch galleryItems {
    | NotAsked => React.null
    | Loading => <ActivityIndicator />
    | Done(Error(_)) => <ErrorPage text="An error occured loading the images" />
    | Done(Ok(pictures)) =>
      <div className=Styles.container>
        {pictures
        ->Array.map(({id, thumbnail: {url}}) => {
          <button key=id className=Styles.image onClick={_ => setOpenImageId(_ => Some(id))}>
            <div className=Styles.imageRatioContainer>
              <img src={"/images/" ++ url} alt="" className=Styles.imageElement />
            </div>
          </button>
        })
        ->React.array}
      </div>
    }}
    {switch openImageId {
    | None => React.null
    | Some(openImageId) =>
      ReactDOM.createPortal(
        <Dialog onClose={() => setOpenImageId(_ => None)}>
          <FullSizePicture imageId=openImageId />
        </Dialog>,
        dialogMountNode,
      )
    }}
  </>
}
