<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Student Signup - Education Hub</title>
    <link rel="stylesheet" href="../common/bootstrap.jsp">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        body {
            min-height: 100vh;
            background: linear-gradient(120deg, #a1c4fd 0%, #c2e9fb 100%);
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .signup-container {
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 8px 40px rgba(30,64,175,0.13), 0 1.5px 8px rgba(0,0,0,0.04);
            padding: 44px 36px 36px 36px;
            max-width: 420px;
            width: 100%;
        }
        .signup-title {
            font-size: 2rem;
            font-weight: 900;
            color: #2563eb;
            text-align: center;
            margin-bottom: 18px;
            display: flex;
            align-items: center;
            gap: 12px;
            justify-content: center;
        }
        .form-label {
            font-weight: 600;
            color: #334155;
        }
        .form-control {
            border-radius: 7px;
            border: 1.5px solid #cbd5e1;
            margin-bottom: 16px;
            font-size: 1.08rem;
            padding: 10px 12px;
        }
        .btn-signup {
            background: #2563eb;
            color: #fff;
            font-weight: 700;
            border-radius: 7px;
            font-size: 1.13rem;
            width: 100%;
            padding: 12px 0;
            margin-top: 8px;
            box-shadow: 0 2px 8px rgba(37,99,235,0.10);
            transition: background 0.18s, box-shadow 0.18s;
        }
        .btn-signup:hover {
            background: #1746a2;
            box-shadow: 0 4px 16px rgba(37,99,235,0.18);
        }
        .back-link {
            display: block;
            margin-top: 18px;
            text-align: center;
            color: #64748b;
            font-size: 1.01rem;
            text-decoration: none;
        }
        .back-link:hover {
            color: #2563eb;
            text-decoration: underline;
        }
    </style>
</head>
<body>
<jsp:include page="../common/googleTranslateWidget.jspf" />
<div class="signup-container">
    <div class="signup-title"><i class="fa-solid fa-user-graduate"></i> Student Signup</div>
    <form action="<%= request.getContextPath()%>/studentsignupServlet" method="post" style="display: flex; flex-direction: column; gap: 0.5rem;">
        <div style="display: flex; flex-direction: column; gap: 0.2rem;">
            <label for="username" class="form-label">Username</label>
            <input type="text" class="form-control" name="username" required minlength="6" maxlength="30" placeholder="Choose a username">
        </div>
        <div style="display: flex; flex-direction: column; gap: 0.2rem;">
            <label for="fullname" class="form-label">Full Name</label>
            <input type="text" class="form-control" name="fullname" required placeholder="Your full name">
        </div>
        <div style="display: flex; flex-direction: column; gap: 0.2rem;">
            <label for="grade" class="form-label">Grade</label>
            <select name="grade" id="grade" class="form-control" required onchange="toggleStreamDropdown()">
                <option value="" disabled selected>Select your grade</option>
                <option value="1">I</option>
                <option value="2">II</option>
                <option value="3">III</option>
                <option value="4">IV</option>
                <option value="5">V</option>
                <option value="6">VI</option>
                <option value="7">VII</option>
                <option value="8">VIII</option>
                <option value="9">IX</option>
                <option value="10">X</option>
                <option value="11">XI</option>
                <option value="12">XII</option>
            </select>
        </div>
        <div id="streamDiv" style="display:none; flex-direction: column; gap: 0.2rem;">
            <label for="stream" class="form-label">Stream</label>
            <select name="stream" id="stream" class="form-control">
                <option value="" disabled selected>Select your stream</option>
                <option value="science">Science</option>
                <option value="commerce">Commerce</option>
                <option value="arts">Arts</option>
            </select>
            <span id="streamWarning" style="color:red; display:none; font-size:0.95rem;">Please select a stream for Grade XI or XII.</span>
        </div>
        <script>
        function toggleStreamDropdown() {
            var grade = document.getElementById('grade').value;
            var streamDiv = document.getElementById('streamDiv');
            var streamSelect = document.getElementById('stream');
            var streamWarning = document.getElementById('streamWarning');
            if (grade === '11' || grade === '12') {
                streamDiv.style.display = 'flex';
                streamSelect.required = true;
            } else {
                streamDiv.style.display = 'none';
                streamSelect.required = false;
                streamSelect.value = '';
                streamWarning.style.display = 'none';
            }
        }
        // On page load, call toggleStreamDropdown in case of browser autofill
        window.onload = function() {
            toggleStreamDropdown();
        };
        // Warn if stream is missing for grades 11/12 on submit
        document.querySelector('form').addEventListener('submit', function(e) {
            var grade = document.getElementById('grade').value;
            var stream = document.getElementById('stream').value;
            var streamWarning = document.getElementById('streamWarning');
            if ((grade === '11' || grade === '12') && !stream) {
                streamWarning.style.display = 'inline';
                e.preventDefault();
            } else {
                streamWarning.style.display = 'none';
            }
        });
        </script>
        <div style="display: flex; flex-direction: column; gap: 0.2rem;">
            <label for="email" class="form-label">E-Mail</label>
            <input type="email" class="form-control" name="email" required placeholder="Enter your email">
        </div>
        <div style="display: flex; flex-direction: column; gap: 0.2rem;">
            <label for="password_hash" class="form-label">Password</label>
            <input type="password" class="form-control" name="password_hash" required minlength="8" placeholder="Create a password">
        </div>
        <div style="display: flex; flex-direction: column; gap: 0.2rem;">
            <label for="confirmpassword" class="form-label">Confirm Password</label>
            <input type="password" class="form-control" name="confirmpassword" required placeholder="Re-enter your password">
        </div>
        <input type="hidden" name="role" value="student">
        <button type="submit" class="btn-signup">Sign Up as Student</button>
    </form>
    <a href="<%= request.getContextPath() %>/views/commonLogin.jsp" class="back-link"><i class="fa fa-arrow-left"></i> Back to Login</a>
</div>
</body>
</html>