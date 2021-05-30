import './App.css';
import Web3 from 'web3';
import { useEffect, useState } from "react";

function App() {

    // useState Hook to declare ac
   const [accounts,setAccounts] = useState();

    useEffect(() => {
        // load blockchain data, then set the accounts

        loadBlockchain();
    })


    async function loadBlockchain() {
        const web3 = new Web3(Web3.givenProvider || 'http://localhost:8545');
        // const network = await web3.eth.net.getNetworkType();
        const accounts = await web3.eth.getAccounts();
        console.log(accounts)
        await setAccounts(accounts);
    }


  return (
    <div>
      <header className="">

      </header>
      <main>
        <div>
          <h1>Hello World</h1>
            <p>your account: {accounts}</p>
        </div>
      </main>
    </div>
  );
}

export default App;
