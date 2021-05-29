import logo from './logo.svg';
import './App.css';
import { Drizzle } from '@drizzle/store'
import { contract } from './contracts/alloy'

const options = {
  contracts: [contract]
}

const drizzle = new Drizzle(options)

function App() {

  console.log(drizzle);
  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>
          Edit <code>src/App.js</code> and save to reload.
        </p>
        <a
          className="App-link"
          href="https://reactjs.org"
          target="_blank"
          rel="noopener noreferrer"
        >
          Learn React now
        </a>
      </header>
    </div>
  );
}

export default App;
