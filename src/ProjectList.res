open Project

let projects = [
  {
    title: "Virtualized list",
    slug: "virtualized-list",
    date: "2021-06-10",
    render: () => <VirtualizedListProject />,
  },
  {
    title: "Bindings",
    slug: "bindings",
    date: "2021-06-06",
    render: () =>
      <NoInterface
        title=`No interface for this one 🤷‍♂️`
        link="https://github.com/bloodyowl/twitch/tree/main/src/projects/2021-06-06-bindings"
      />,
  },
  {
    title: "Todo list",
    slug: "todo-list",
    date: "2021-06-03",
    render: () => <TodoList />,
  },
  {
    title: "Hello world",
    slug: "hello-world",
    date: "2021-05-30",
    render: () => <HelloWorld />,
  },
]
