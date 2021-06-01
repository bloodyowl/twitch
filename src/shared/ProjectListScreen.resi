@react.component
let make: (
  ~rootPath: string,
  ~localPath: list<string>,
  ~queryString: string,
  ~projects: array<Project.t>,
) => React.element
