@react.component
let make: (
  ~localPath: list<string>,
  ~queryString: string,
  ~projects: array<Project.t>,
) => React.element
