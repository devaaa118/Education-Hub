# Education-Hub AI Guide

## Architecture snapshot
- Backend is a Jakarta Servlet + JSP app; controllers live in `src/main/java/com/edu/controller`, views under `src/main/webapp/views`.
- Data layer is raw JDBC via `userDAO` and `resourceDAO` with MySQL `education_hub`; no ORM or Spring MVC despite the dependency in `pom.xml`.
- `TeacherDashboardServlet`, `StudentDashboardServlet`, etc. forward directly to JSPs and populate request attributes; frontend React prototype in `my-education/` is not wired into the WAR.

## Session & routing conventions
- Authentication stores the logged-in `User` object in the HTTP session under "user"; always gate teacher flow by checking `user != null && "teacher".equalsIgnoreCase(user.getRole())`.
- URL patterns follow servlet annotations: e.g., `/teacherDashboard`, `/upload-resource`, `/my-resources`; JSPs are addressed via `/views/*.jsp`.
- Logout is handled by `LogoutServlet` mapped to `/logout`; keep redirects relative to `request.getContextPath()`.

## Data access & schema
- JDBC connection strings are hard-coded in `userDAO#getConnection` and `resourceDAO#getConnection`; adjust credentials locally before running.
- Preferred patterns: always fetch metadata (classes, subjects, streams) from `resourceDAO` helpers instead of duplicating SQL in servlets.
- Database blueprint lives in `src/main/webapp/resources/schema.sql`; load this into MySQL before testing new features.

## Resource management flows
- Uploads go through `UploadResourceServlet`: it requires either `resourceFile` (multipart) or `resourceUrl`; validation ensures class/subject combos come from DAO-provided maps.
- `TeacherResourceLibraryServlet` and `EditResourceServlet` centralize filtering and update logic; reuse `storeFormValues`/`clearFormValues` patterns when adding fields.
- Student resource access (`StudentSubjectResourcesServlet`, `StudentDashboardServlet`) expects mappings from `student_classes`; keep new queries compatible with the existing joins that include optional streams.

## File storage rules
- `FileStorageUtil` saves into an `uploads` folder, defaulting to `${jboss.server.data.dir}` when deployed on WildFly; fall back uses `ServletContext.getRealPath`.
- When replacing files, call `deleteFile` on the previous path after successful insert/update to avoid orphaned assets.
- Downloads rely on `DownloadResourceServlet` + `resolveAbsolutePath`; make sure any new file types supply the correct `Content-Type`.

## Build, run, deploy
- Maven build: `mvn clean package` creates `target/Servlet_app.war`. Post-package the `maven-antrun-plugin` copies the WAR to `D:/WildFly server/.../deployments`; change or disable that path before running on another machine.
- Runtime expectations: Java 17+, WildFly or any Jakarta EE 10-compatible container, and a reachable MySQL instance with the schema loaded.
- Tests are legacy JUnit 3 stubs only; rely on manual verification or add servlet-level tests if expanding coverage.

## Frontend sandbox
- `my-education/` is a standalone Vite React app (`npm install && npm run dev`); it's currently a playground and not referenced by the server-side JSPs.
- If integrating React, plan a build output into `src/main/webapp` or expose REST endpoints; today the WAR serves classic JSP pages.

## Developer tips
- Use JSTL tags in JSPs (`<c:forEach>`, `<fmt:formatDate>`) as shown in `teacherDashboard.jsp` to keep Java out of templates.
- Keep enums (resource type/language) consistent with database values; server code usually trusts client inputs, so add validation before persisting.
- When adding new DAOs, mirror the defensive `PreparedStatement` usage and maintain the habit of ordering query results for predictable display.
