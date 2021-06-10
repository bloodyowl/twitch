module Styles = {
  open Emotion
  let container = css({"display": "flex", "margin": "auto"})
}

@react.component
let make = (~color="currentColor", ~size=32, ~strokeWidth=2) => {
  <div className=Styles.container>
    <svg
      width={Int.toString(size)}
      height={Int.toString(size)}
      viewBox="0 0 38 38"
      xmlns="http://www.w3.org/2000/svg"
      xmlnsXlink="http://www.w3.org/1999/xlink"
      stroke=color
      style={ReactDOM.Style.make(~overflow="visible", ())}
      ariaLabel="Loading"
      role="alert"
      ariaBusy=true>
      <g fill="none" fillRule="evenodd">
        <g transform="translate(1 1)" strokeWidth={strokeWidth->Int.toString}>
          <circle strokeOpacity=".5" cx="18" cy="18" r="18" />
          <path d="M36 18c0-9.94-8.06-18-18-18">
            <animateTransform
              attributeName="transform"
              type_="rotate"
              from="0 18 18"
              to_="360 18 18"
              dur="1s"
              repeatCount="indefinite"
            />
          </path>
        </g>
      </g>
    </svg>
  </div>
}
