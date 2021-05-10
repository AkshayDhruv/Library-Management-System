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

p {
	margin: 0
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
	String name = (String) session.getAttribute("name");
	//redirect user to login page if not logged in
	if (email == null) {
		name = "Please login to continue...";
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
		<span style="float: right; color: #2196F3">Welcome, <%=name%></span> <br />
		<br /> <br />
		<div class="container">
			<h1>Getting Started!!!</h1>

			<br />
			<p>The aim of this project is to build a decision support system
				for a university library.</p>
			<p>The library carries a large number of books, journals,
				conference proceedings, reference books, and copies of some recorded
				lectures on CD.</p>
			<p>These items are loaned to members. Members of the library are
				mainly students, faculty, visiting scholars, and staff.</p>
			<p>This is an automated system that would facilitate the process
				of searching the database for books written by a particular author,
				books published by a certain publisher, books on a particular
				subject, etc.</p>
			<br />
			<br />
			<div align="left">
				<p style="text-decoration: underline">
					<b>Current Functionalities:</b>
				</p>
				<p>
					<b>Login/Logout : </b>User can access the site only after
					signing In. New User can register themselves first.
				</p>
				<p>
					<b>Upload : </b>This page is only operated by Admin. Only Admin can
					upload the library records. <span style="color: red;">Note:
						All the previous data will be deleted.</span>
				</p>
				<p>
					<b>Statistics: </b>This page has 6 sub categories:
				</p>
				<p>
					<b>a. </b>User can change the status date to check the status of an
					item at a particular date.
				</p>
				<p>
					<b>b. </b>User can check the status of a particular item by it's
					id.
				</p>
				<p>
					<b>c. </b>User can check top 10 books issued.
				</p>
				<p>
					<b>d. </b>User can check top 10 authors whose items are issued.
				</p>
				<p>
					<b>e. </b>User can check top 5 journals issued.
				</p>
				<p>
					<b>f. </b>User can check the summary of the items.
				</p>
				<p>
					<b>Member: </b>This page has the details of the items
					issued/returned as per the members. User can also add/edit/delete
					the member records.
				</p>
				<p>
					<b>Master: </b>This page has the details of the total items in the
					library. User can also add/edit/delete the items in the library.
				</p>
				<p>
					<b>Defaulter: </b>This page has the details of the defaulter's
					(items that are overdue). User can also notify the member by
					sending emails. <span style="color: red;">(Currently disabled)</span>
				</p>
			</div>
		</div>
	</div>
</body>
</html>