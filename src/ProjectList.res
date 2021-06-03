open Project

let projects = [
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
