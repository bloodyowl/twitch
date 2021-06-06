class User {
  constructor(name, age) {
    this.name = name
    this.age = age
  }
  getHelloMessage() {
    return `Hello ${this.name}`
  }
}

let user = new User("Matthias", 27)

console.log(user)
console.log(user.getHelloMessage())

let user = {
  name: "Matthias",
  age: 27
}

function getHelloMessage(user) {
  return `Hello ${user.name}`
}

