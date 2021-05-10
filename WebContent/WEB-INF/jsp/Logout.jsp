<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*, javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.1.3/css/bootstrap.css"
	rel="stylesheet">
<link
	href="https://cdn.datatables.net/1.10.21/css/dataTables.bootstrap4.min.css"
	rel="stylesheet">
<title>Library Management System</title>
<script type="text/javascript">
	function date_time(id) {
		date = new Date;
		year = date.getFullYear();
		month = date.getMonth();
		months = new Array('January', 'February', 'March', 'April', 'May',
				'June', 'Jully', 'August', 'September', 'October', 'November',
				'December');
		d = date.getDate();
		day = date.getDay();
		days = new Array('Sunday', 'Monday', 'Tuesday', 'Wednesday',
				'Thursday', 'Friday', 'Saturday');
		h = date.getHours();
		if (h < 10) {
			h = "0" + h;
		}
		m = date.getMinutes();
		if (m < 10) {
			m = "0" + m;
		}
		s = date.getSeconds();
		if (s < 10) {
			s = "0" + s;
		}
		result = '' + days[day] + ' ' + months[month] + ' ' + d + ' ' + year
				+ ' ' + h + ':' + m + ':' + s;
		document.getElementById(id).innerHTML = result;
		setTimeout('date_time("' + id + '");', '1000');
		return true;
	}
</script>
<style>
body {
	font-family: Arial, Helvetica, sans-serif;
	margin: 0;
	background-color: #eeffee;
}

.container {
	text-align: center;
}

.btn {
	float: right;
	background: #2196F3;
	color: white;
	padding: 5px;
	font-size: 15px;
	border: 1px solid grey;
	width: 8%;
}
</style>
</head>
<body>

<%
		String email = (String) session.getAttribute("email");
	String name = null;
	//redirect user to login page if not logged in
	if (email == null) {
		response.sendRedirect("home");
	} else {
		session.invalidate();
		name = "You are successfully logged out.";
		response.setHeader("Refresh", "3;url=home");
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
	<div>
		<span id="date_time" style="float: left;"></span>
		<script type="text/javascript">
			window.onload = date_time('date_time');
		</script>
		<br />
		<br /> <br />
		<h1 style="text-align:center;color:#2196F3"><%=name%></h1>
	</div>
</body>
</html>