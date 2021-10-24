module App = {
  @react.component
  let make = () => {
    <div> {React.string("Hello World")} </div>
  }
}

switch ReactDOM.querySelector("#main") {
| Some(main) => ReactDOM.render(<App />, main)
| None => ()
}
