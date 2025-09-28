---
description: Repository Information Overview
alwaysApply: true
---

# Repository Information Overview

## Repository Summary
This repository contains a Java Servlet-based web application with a React frontend. The project is an educational platform that supports student and teacher roles, resource management, and user authentication.

## Repository Structure
- **src/main/java**: Java source code organized in MVC pattern
- **src/main/webapp**: JSP views, web resources, and configuration files
- **my-education**: React frontend application built with Vite
- **target**: Compiled classes and WAR deployment artifacts

### Main Repository Components
- **Java Servlet Backend**: Jakarta EE 6.0 application with Spring MVC integration
- **React Frontend**: Modern UI built with React 19 and Vite
- **MySQL Database**: Persistence layer for user and educational data

## Projects

### Java Servlet Application
**Configuration File**: pom.xml

#### Language & Runtime
**Language**: Java
**Version**: Jakarta EE 6.0
**Build System**: Maven
**Package Manager**: Maven

#### Dependencies
**Main Dependencies**:
- jakarta.servlet-api (6.0.0)
- jakarta.servlet.jsp.jstl-api (3.0.0)
- spring-webmvc (6.2.10)
- hibernate-core (5.6.15.Final)
- mysql-connector-java (8.0.33)

**Development Dependencies**:
- junit (3.8.1)

#### Build & Installation
```bash
mvn clean package
```

#### Deployment
The application is configured to automatically deploy to WildFly server:
- WAR file is copied to WildFly deployments directory during the package phase
- Default deployment path: D:/WildFly server/wildfly-37.0.0.Final/standalone/deployments

#### Application Structure
**Controllers**: src/main/java/com/edu/controller
- Servlet controllers for handling HTTP requests
- Authentication and session management

**Models**: src/main/java/com/edu/model
- Domain objects representing users and educational resources

**DAO**: src/main/java/com/edu/dao
- Data access objects for database operations

**Views**: src/main/webapp/views
- JSP pages for different user interfaces
- Login, signup, and dashboard pages for students and teachers

### React Frontend (my-education)
**Configuration File**: package.json

#### Language & Runtime
**Language**: JavaScript (React)
**Version**: React 19.1.1
**Build System**: Vite 7.1.2
**Package Manager**: npm

#### Dependencies
**Main Dependencies**:
- react (19.1.1)
- react-dom (19.1.1)

**Development Dependencies**:
- @vitejs/plugin-react (5.0.0)
- eslint (9.33.0)
- vite (7.1.2)

#### Build & Installation
```bash
cd my-education
npm install
npm run build
```

#### Development
```bash
cd my-education
npm run dev
```