<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!-- Student Dashboard Header Include (Unified Style) -->
<style>
    .dashboard-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 32px;
        background: #fff;
        border-radius: 18px 18px 0 0;
        box-shadow: 0 2px 12px rgba(30,64,175,0.07);
        padding: 32px 36px 18px 36px;
    }
    .dashboard-title {
        font-size: 2.4rem;
        font-weight: 900;
        color: #2563eb;
        display: flex;
        align-items: center;
        gap: 18px;
    }
    .dashboard-nav {
        display: flex;
        gap: 20px;
        align-items: center;
    }
    .dashboard-nav a {
        color: #2563eb;
        font-weight: 700;
        text-decoration: none;
        font-size: 1.18rem;
        display: flex;
        align-items: center;
        gap: 8px;
        padding: 8px 18px;
        border-radius: 6px;
        transition: background 0.15s, color 0.15s;
    }
    .dashboard-nav a:hover {
        background: #e0e7ff;
        color: #1e40af;
    }
    .language-control {
        display: flex;
        align-items: center;
        gap: 8px;
        font-weight: 600;
        color: #1e3a8a;
    }
    .language-control label {
        margin: 0;
    }
    .language-control select {
        border-radius: 14px;
        padding: 4px 12px;
    }
</style>
<div class="dashboard-header">
    <div class="dashboard-title">
        <i class="fa-solid fa-user-graduate"></i>
        <span data-i18n="studentDashboard.pageTitle">Student Dashboard</span>
    </div>
    <nav class="dashboard-nav">
    <a href="<%= request.getContextPath() %>/studentDashboard" data-i18n-attr="title" data-i18n-title="nav.home" title="Home"><i class="fa fa-home"></i> <span data-i18n="nav.home">Home</span></a>
    <a href="<%= request.getContextPath() %>/resources" data-i18n-attr="title" data-i18n-title="nav.resources" title="Resources"><i class="fa fa-book"></i> <span data-i18n="nav.resources">Resources</span></a>
    <a href="<%= request.getContextPath() %>/student/quizzes" data-i18n-attr="title" data-i18n-title="nav.quizzes" title="Quizzes"><i class="fa fa-clipboard-check"></i> <span data-i18n="nav.quizzes">Quizzes</span></a>
    <a href="<%= request.getContextPath() %>/student/tutoring" data-i18n-attr="title" data-i18n-title="nav.tutoring" title="Tutoring"><i class="fa fa-calendar"></i> <span data-i18n="nav.tutoring">Tutoring</span></a>
    <a href="<%= request.getContextPath() %>/views/assignments.jsp" data-i18n-attr="title" data-i18n-title="nav.assignments" title="Assignments"><i class="fa fa-tasks"></i> <span data-i18n="nav.assignments">Assignments</span></a>
    <a href="<%= request.getContextPath() %>/views/profile.jsp" data-i18n-attr="title" data-i18n-title="nav.profile" title="Profile"><i class="fa fa-user"></i> <span data-i18n="nav.profile">Profile</span></a>
    <a href="<%= request.getContextPath() %>/logout" data-i18n-attr="title" data-i18n-title="nav.logout" title="Logout"><i class="fa fa-sign-out-alt"></i> <span data-i18n="nav.logout">Logout</span></a>
        <div class="language-control">
            <label for="language-select" data-i18n="language.label">Language</label>
            <select id="language-select" class="form-select form-select-sm language-switcher">
                <option value="en" data-i18n="language.english">English</option>
                <option value="ta" data-i18n="language.tamil">Tamil</option>
            </select>
        </div>
    </nav>
</div>
