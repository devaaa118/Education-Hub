<form action="UploadResourceServlet" method="post" enctype="multipart/form-data">
    <div class="mb-3">
        <label>Grade:</label>
        <input type="text" name="grade" class="form-control" required>
    </div>
    <div class="mb-3">
        <label>Subject:</label>
        <input type="text" name="subject" class="form-control" required>
    </div>
    <div class="mb-3">
        <label>Title:</label>
        <input type="text" name="title" class="form-control" required>
    </div>
    <div class="mb-3">
        <label>Type:</label>
        <select name="type" class="form-control" required>
            <option value="PDF">PDF</option>
            <option value="Video">Video</option>
            <option value="Quiz">Quiz</option>
        </select>
    </div>
    <div class="mb-3">
        <label>Language:</label>
        <select name="language" class="form-control" required>
            <option value="Tamil">Tamil</option>
            <option value="English">English</option>
        </select>
    </div>
    <div class="mb-3">
        <label>Upload File:</label>
        <input type="file" name="file" class="form-control" required>
    </div>
    <button type="submit" class="btn btn-primary">Upload</button>
</form>

