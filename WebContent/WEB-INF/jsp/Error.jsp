<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isErrorPage="true"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Library Management System</title>
<script>
	setTimeout(function() {
		window.location.href = 'home';
	}, 5000);
</script>
</head>
<body>
	<%
		String email = (String) session.getAttribute("email");
	String name = null;
	//redirect user to login page if not logged in
	if (email == null) {
		response.sendRedirect("home");
	} else {
		name = (String) session.getAttribute("name");
	}
	%>
<nav class="navbar navbar-expand-md navbar-dark bg-dark fixed-top">
		<div
			class="navbar-collapse collapse w-100 order-1 order-md-0 dual-collapse2">
			<ul class="navbar-nav mr-auto">
				<li class="nav-item"><a class="nav-link" href="home">Home</a></li>
				<li class="nav-item"><a class="nav-link" href="process">Upload</a></li>
				<li class="nav-item"><a class="nav-link" href="statistics">Statistics</a></li>
				<li class="nav-item"><a class="nav-link" href="view">Member</a></li>
				<li class="nav-item"><a class="nav-link" href="search">Master</a></li>
				<li class="nav-item"><a class="nav-link" href="defaulter">Defaulter</a></li>
			</ul>
		</div>
		<div class="mx-auto order-0">
			<h6 class="navbar-brand mx-auto">Welcome To Library</h6>
			<button class="navbar-toggler" type="button" data-toggle="collapse"
				data-target=".dual-collapse2">
				<span class="navbar-toggler-icon"></span>
			</button>
		</div>
		<div class="navbar-collapse collapse w-100 order-3 dual-collapse2">
			<ul class="navbar-nav ml-auto">
				<li class="nav-item"><a class="nav-link" href="loginPage">Login</a>
				</li>
				<li class="nav-item"><a class="nav-link" href="logout">Logout</a>
				</li>
			</ul>
		</div>
	</nav>
	<br />
	<br />
	<br />
	<br />
	<span style="float: right;color: #2196F3">Current User, <%=name%></span>
	<div align="center">
		<h1>Error</h1>
		<h2><%=exception.getMessage()%><br />
		</h2>
	</div>
</body>
</html>