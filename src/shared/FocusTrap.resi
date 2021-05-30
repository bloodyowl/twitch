@react.component
let make: (
  ~onPressEscape: unit => unit=?,
  ~className: string=?,
  ~children: React.element,
) => React.element
