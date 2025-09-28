<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<style>
    .app-dash-header {
        background: linear-gradient(135deg, rgba(37,99,235,0.08), rgba(30,64,175,0.1));
        border-radius: 1.5rem;
        padding: 1.75rem 2rem;
        box-shadow: 0 1.5rem 3rem rgba(37, 99, 235, 0.09);
        margin-bottom: 2rem;
        display: flex;
        flex-direction: column;
        gap: 1.25rem;
    }
    @media (min-width: 992px) {
        .app-dash-header {
            flex-direction: row;
            align-items: center;
            justify-content: space-between;
        }
    }
    .app-dash-title {
        font-size: 2rem;
        font-weight: 800;
        color: #1e3a8a;
        display: flex;
        align-items: center;
        gap: 0.75rem;
    }
    .app-dash-nav {
        display: flex;
        flex-wrap: wrap;
        gap: 0.5rem;
        align-items: center;
        justify-content: flex-start;
    }
    .app-dash-nav a {
        display: inline-flex;
        align-items: center;
        gap: 0.45rem;
        padding: 0.55rem 1rem;
        border-radius: 999px;
        font-weight: 600;
        color: #1d4ed8;
        text-decoration: none;
        transition: background-color 0.2s ease, color 0.2s ease, transform 0.15s ease;
        background: #f8fafc;
        border: 1px solid rgba(37, 99, 235, 0.15);
    }
    .app-dash-nav a:hover, .app-dash-nav a:focus {
        background: #1d4ed8;
        color: #fff;
        transform: translateY(-1px);
    }
    .app-language-switch {
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
        background: #fff;
        border-radius: 999px;
        padding: 0.35rem 0.9rem;
        box-shadow: inset 0 0 0 1px rgba(37, 99, 235, 0.12);
    }
    .app-language-switch label {
        margin: 0;
        font-size: 0.9rem;
        font-weight: 600;
        color: #1e40af;
    }
    .app-language-switch .language-switcher-host {
        min-width: 150px;
    }
</style>
<header class="app-dash-header">
    <div class="app-dash-title">
        <i class="fa-solid fa-user-graduate"></i>
        <span data-i18n="studentDashboard.pageTitle">Student Dashboard</span>
    </div>
    <nav class="app-dash-nav">
        <a href="<%= request.getContextPath() %>/studentDashboard" data-i18n-attr="title" data-i18n-title="nav.home" title="Home"><i class="fa fa-home"></i> <span data-i18n="nav.home">Home</span></a>
        <a href="<%= request.getContextPath() %>/resources" data-i18n-attr="title" data-i18n-title="nav.resources" title="Resources"><i class="fa fa-book"></i> <span data-i18n="nav.resources">Resources</span></a>
    <a href="<%= request.getContextPath() %>/student/quizzes" data-i18n-attr="title" data-i18n-title="nav.quizzes" title="Quizzes"><i class="fa fa-clipboard-check"></i> <span data-i18n="nav.quizzes">Quizzes</span></a>
        <a href="<%= request.getContextPath() %>/student/tutoring" data-i18n-attr="title" data-i18n-title="nav.tutoring" title="Tutoring"><i class="fa fa-calendar"></i> <span data-i18n="nav.tutoring">Tutoring</span></a>
        <a href="<%= request.getContextPath() %>/views/profile.jsp" data-i18n-attr="title" data-i18n-title="nav.profile" title="Profile"><i class="fa fa-user"></i> <span data-i18n="nav.profile">Profile</span></a>
        <a href="<%= request.getContextPath() %>/logout" data-i18n-attr="title" data-i18n-title="nav.logout" title="Logout"><i class="fa fa-sign-out-alt"></i> <span data-i18n="nav.logout">Logout</span></a>
        <div class="app-language-switch">
            <label for="language-select" class="mb-0" data-i18n="language.label">Language</label>
            <div class="language-switcher-host" data-google-translate-host></div>
        </div>
    </nav>
</header>
