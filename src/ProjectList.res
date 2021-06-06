open Project

let projects = [
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
