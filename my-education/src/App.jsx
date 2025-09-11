import { useState } from "react";
import "./App.css";

function App() {
  const [page, setPage] = useState("home");

  return (
    <div className="app">
      <header className="header">
        <h1>📘 Education Hub</h1>
        <nav>
          <button onClick={() => setPage("home")}>Home</button>
          <button onClick={() => setPage("teacherLogin")}>Teacher Login</button>
          <button onClick={() => setPage("studentLogin")}>Student Login</button>
          <button onClick={() => setPage("signup")}>Signup</button>
          
        </nav>
      </header>

      <main className="content">
        {page === "home" && <h2>Welcome to Education Hub</h2>}

        {page === "teacherLogin" && (
          <form className="form">
            <h2>Teacher Login</h2>
            <input type="text" placeholder="Username" />
            <input type="password" placeholder="Password" />
            <button type="submit">Login</button>
          </form>
        )}

        {page === "studentLogin" && (
          <form className="form">
            <h2>Student Login</h2>
            <input type="text" placeholder="Username" />
            <input type="password" placeholder="Password" />
            <button type="submit">Login</button>
          </form>
        )}

        {page === "signup" && (
          <form className="form">
            <h2>Signup</h2>
            <input type="text" placeholder="Name" />
            <input type="text" placeholder="Username" />
            <input type="email" placeholder="Email" />
            <input type="password" placeholder="Password" />
            <select>
              <option value="student">Student</option>
              <option value="teacher">Teacher</option>
            </select>
            <button type="submit">Register</button>
          </form>
        )}
      </main>
    </div>
  );
}

export default App;
