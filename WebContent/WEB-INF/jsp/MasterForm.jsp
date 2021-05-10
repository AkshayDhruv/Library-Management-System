<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="java.io.*,java.util.*, javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Library Management System</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.1.3/css/bootstrap.css"
	rel="stylesheet">
<link
	href="https://cdn.datatables.net/1.10.21/css/dataTables.bootstrap4.min.css"
	rel="stylesheet">
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
<style type="text/css">
.btn {
	float: right;
	background: #2196F3;
	color: white;
	padding: 5px;
	font-size: 15px;
	border: 1px solid grey;
	width: 8%;
}

body {
	font-family: Arial;
	background-color: #eeffee;
}

h2 {
	text-align: center;
}

table {
	table-layout: auto;
	margin-left: 500px;
	margin-right: 500px;
	border: 1px solid black;
}

td {
	padding: 10px;
	border: 1px solid black;
}

input[type=number] {
	width: 100%;
}

input[type=text] {
	width: 100%;
}

select[name=itemType] {
	width: 100%;
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
	<span style="float: right; color: #2196F3">Current User, <%=name%></span>
	<span id="date_time" style="float: left;"></span>
	<script type="text/javascript">
		window.onload = date_time('date_time');
	</script>
	<div align="center">
		<c:if test="${data == null}">
			<form action="insertMaster" method="post">
				<h3 style="text-decoration: underline">ADD NEW MASTER RECORD</h3>
				<table style="background-color: lightyellow">
					<tr>
						<td width="20%">Item Id</td>
						<td><input type="number" name="itemId" size="50%"
							value="" required/></td>
					</tr>
					<tr>
						<td width="20%">Item Type</td>
						<td><select name="itemType" id="itemType" required>
								<option value="" selected
									disabled>Choose Item Type</option>
								<option value="Book">Book</option>
								<option value="Reference Book">Reference Book</option>
								<option value="CD">CD</option>
								<option value="Journal">Journal</option>
								<option value="Conference Procedings">Conference Procedings</option>
						</select></td>
					</tr>
					<tr>
						<td width="20%">Title</td>
						<td><textarea rows="2" cols="53" name="title"></textarea></td>
					</tr>
					<tr>
						<td width="20%">Author</td>
						<td><input type="text" name="author" size="50%"
							value="" /></td>
					</tr>
					<tr>
						<td width="20%">Publisher</td>
						<td><input type="text" name="publisher" size="50%"
							value="" /></td>
					</tr>
					<tr>
						<td width="20%">Publication Year</td>
						<td><input type="number" name="publicationYear" size="50%"
							value="" /></td>
					</tr>
					<tr>
						<td width="20%">Edition</td>
						<td><input type="number" name="edition" size="50%"
							value="" /></td>
					</tr>
					<tr>
						<td width="20%">Subject</td>
						<td><input type="text" name="subject" size="50%"
							value="" /></td>
					</tr>
					<tr>
					<tr>
						<td colspan="2" align="center">
						<button class="btn"
							style="float: none; width: 20%; font-size: 15px" type="submit"
							value="submit" ><i class="fa fa-save"> Add</i></button></td>
					</tr>
				</table>
			</form>
		</c:if>
		<c:if test="${data != null}">
			<form action="updateMaster" method="post">
			<h3 style="text-decoration: underline">UPDATE MASTER RECORD</h3>
		<table style="background-color: lightyellow">
			<tr>
				<td width="20%">Item Id</td>
				<td>
				<input type="number" name="itemId" size="50%" value="<c:out value='${data.itemId}'/>" readonly/>
				</td>
			</tr>
			<tr>
				<td width="20%">Item Type</td>
				<td>
				<select name="itemType" id="itemType" required>
						<option value="<c:out value='${data.itemType}'/>">${data.itemType}</option>
						<option value="Book">Book</option>
						<option value="Reference Book">Reference Book</option>
						<option value="CD">CD</option>
						<option value="Journal">Journal</option>
						<option value="Conference Procedings">Conference Procedings</option>
				</select>
				</td>
			</tr>
			<tr>
				<td width="20%">Title</td>
				<td><textarea rows="2" cols="53" name="title"><c:out value='${data.title}'/></textarea></td>
			</tr>
			<tr>
				<td width="20%">Author</td>
				<td><input type="text" name="author" size="50%" value="<c:out value='${data.author}'/>" /></td>
			</tr>
			<tr>
				<td width="20%">Publisher</td>
				<td><input type="text" name="publisher" size="50%"
					value="<c:out value='${data.publisher}'/>" /></td>
			</tr>
			<tr>
				<td width="20%">Publication Year</td>
				<td><input type="number" name="publicationYear" size="50%"
					value="<c:out value='${data.publicationYear}'/>"/></td>
			</tr>
			<tr>
				<td width="20%">Edition</td>
				<td><input type="number" name="edition" size="50%"
					value="<c:out value='${data.publicationEdition}'/>"/></td>
			</tr>
			<tr>
				<td width="20%">Subject</td>
				<td><input type="text" name="subject" size="50%" value="<c:out value='${data.subject}'/>" /></td>
			</tr>
			<tr>
				<td colspan="2" align="center">
				<button class="btn"
						style="float: none; width: 20%; font-size: 15px" type="submit"
						value="submit"><i class="fa fa-refresh"></i> Update </button>
				</td>
			</tr>
		</table>
		</form>
		</c:if>
	</div>
</body>
</html>