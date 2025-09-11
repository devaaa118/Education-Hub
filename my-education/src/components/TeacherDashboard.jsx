import { useState } from "react";

function TeacherDashboard() {
  const [resources, setResources] = useState([]);
  const [formData, setFormData] = useState({
    grade: "",
    subject: "",
    title: "",
    type: "PDF",
    language: "English",
    file: null,
  });

  // Handle input change
  const handleChange = (e) => {
    const { name, value, files } = e.target;
    if (name === "file") {
      setFormData({ ...formData, file: files[0] });
    } else {
      setFormData({ ...formData, [name]: value });
    }
  };

  // Handle form submit
  const handleSubmit = async (e) => {
    e.preventDefault();

    const data = new FormData();
    for (let key in formData) {
      data.append(key, formData[key]);
    }

    try {
      const res = await fetch("http://localhost:8080/Servlet_app/UploadResourceServlet", {
        method: "POST",
        body: data,
      });

      if (res.ok) {
        alert("✅ Resource uploaded successfully!");
        // Here you can reload resources from backend if needed
      } else {
        alert("❌ Upload failed!");
      }
    } catch (error) {
      console.error(error);
      alert("⚠ Something went wrong!");
    }
  };

  return (
    <div style={{ padding: "20px" }}>
      <h1>📘 Teacher Dashboard</h1>
      <h3>Welcome, Teacher!</h3>

      {/* Upload Form */}
      <form onSubmit={handleSubmit} style={{ marginBottom: "20px" }}>
        <h2>📂 Upload New Resource</h2>
        <input
          type="text"
          name="grade"
          placeholder="Grade (e.g. 10)"
          onChange={handleChange}
          required
        />
        <input
          type="text"
          name="subject"
          placeholder="Subject"
          onChange={handleChange}
          required
        />
        <input
          type="text"
          name="title"
          placeholder="Title"
          onChange={handleChange}
          required
        />
        <select name="type" onChange={handleChange}>
          <option value="PDF">PDF</option>
          <option value="Video">Video</option>
          <option value="Quiz">Quiz</option>
        </select>
        <select name="language" onChange={handleChange}>
          <option value="English">English</option>
          <option value="Tamil">Tamil</option>
        </select>
        <input type="file" name="file" onChange={handleChange} required />
        <button type="submit">Upload</button>
      </form>

      {/* Resource List */}
      <div>
        <h2>📑 Uploaded Resources</h2>
        {resources.length === 0 ? (
          <p>No resources uploaded yet.</p>
        ) : (
          <ul>
            {resources.map((r, index) => (
              <li key={index}>
                {r.title} - {r.subject} ({r.type})
              </li>
            ))}
          </ul>
        )}
      </div>
    </div>
  );
}

export default TeacherDashboard;
