import React, { useState } from "react";
import axios from "axios";
import { useNavigate } from "react-router-dom";

export default function LoginForm() {
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [msg, setMsg] = useState("");
  const navigate = useNavigate();

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const params = new URLSearchParams();
      params.append("username", username);
      params.append("passwordHash", password);

      const res = await axios.post(
        "http://localhost:8080/Servlet_app/teacherLogin",
        params
      );

      if (res.data.status === "success") {
        if (res.data.role === "teacher") {
          navigate("/teacher-dashboard");
        } else if (res.data.role === "student") {
          navigate("/student-dashboard");
        }
      } else {
        setMsg(res.data.message || "Login failed ❌");
      }
    } catch (err) {
      setMsg("Server error ❌");
    }
  };

  return (
    <div className="container mt-5">
      <h2>Login</h2>
      <form onSubmit={handleSubmit}>
        <input
          type="text"
          placeholder="Username"
          value={username}
          onChange={(e) => setUsername(e.target.value)}
          className="form-control mb-2"
        />
        <input
          type="password"
          placeholder="Password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          className="form-control mb-2"
        />
        <button type="submit" className="btn btn-primary">
          Login
        </button>
      </form>
      {msg && <p className="text-danger mt-2">{msg}</p>}
    </div>
  );
}

