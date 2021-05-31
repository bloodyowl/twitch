@val external matchMedia: string => {..} = "matchMedia"

let supportsHover = matchMedia("(hover: hover)")["matches"]
