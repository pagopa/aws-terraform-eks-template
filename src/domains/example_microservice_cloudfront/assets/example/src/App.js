import React, { useState, useEffect } from 'react';
import logo from './logo.svg';
import './App.css';

const url = "https://667qjtbapk.execute-api.eu-south-1.amazonaws.com/services/echo"

function App() {
  const [res, setRes] = useState(null);

  useEffect(() => {
    fetch(url, { mode: "cors" })
      .then(res => res.text())
      .then(
        (result) => setRes(result),
        (error) => setRes(error)
      )
  }, [])

  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
      </header>
      <main>
        <pre style={{ textAlign: "left", whiteSpace: "pre-line" }}>
          <code>{res}</code>
        </pre>
      </main>
    </div>
  );
}

export default App;
