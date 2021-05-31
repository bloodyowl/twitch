@val external publicPath: option<string> = "process.env.PUBLIC_PATH"

let publicPath = publicPath->Option.getWithDefault("/")

let join = (s1, s2) =>
  `${s1}/${s2}`
  ->String.replaceRegExp(%re("/:\/\//g"), "__PROTOCOL__")
  ->String.replaceRegExp(%re("/\/+/g"), "/")
  ->String.replaceRegExp(%re("/__PROTOCOL__/g"), "://")

let makeHref = join(publicPath)

let rec stripInitialPath = (path, sourcePath) => {
  switch (path, sourcePath) {
  | (list{a1, ...a2}, list{b1, ...b2}) if a1 === b1 => stripInitialPath(a2, b2)
  | (path, _) => path
  }
}

// copied from RescriptReactRouter
let pathParse = str =>
  switch str {
  | "" | "/" => list{}
  | raw =>
    /* remove the preceeding /, which every pathname seems to have */
    let raw = raw->String.sliceToEnd(~start=1)
    /* remove the trailing /, which some pathnames might have. Ugh */
    let raw = switch raw->String.get(String.length(raw) - 1) {
    | Some("/") => raw->String.slice(~start=0, ~end=-1)
    | _ => raw
    }
    /* remove search portion if present in string */
    let raw = switch raw->String.splitAtMost("?", ~limit=2) {
    | [path, _] => path
    | _ => raw
    }

    raw->String.split("/")->Array.filter(item => item->String.length != 0)->List.fromArray
  }

type url = RescriptReactRouter.url

let useUrl = (~serverUrl=?, ()) => {
  let url = RescriptReactRouter.useUrl(~serverUrl?, ())

  React.useMemo1(() => {
    {...url, path: stripInitialPath(url.path, pathParse(publicPath))}
  }, [url])
}

let push = url => {
  RescriptReactRouter.push(makeHref(url))
}

let replace = url => {
  RescriptReactRouter.replace(makeHref(url))
}
