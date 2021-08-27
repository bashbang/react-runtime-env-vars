import './App.css';

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <p>
          Stage: {window.env.REACT_APP_STAGE}
        </p>
      </header>
    </div>
  );
}

export default App;
