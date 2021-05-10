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
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"
	rel="stylesheet">
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.1.3/css/bootstrap.css"
	rel="stylesheet">
<link
	href="https://cdn.datatables.net/1.10.21/css/dataTables.bootstrap4.min.css"
	rel="stylesheet">
<link
	href="https://cdn.datatables.net/buttons/1.6.2/css/buttons.dataTables.min.css"
	rel="stylesheet">
<link
	href="https://cdn.datatables.net/select/1.3.1/css/select.dataTables.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.5.1.js"></script>
<script
	src="https://cdn.datatables.net/1.10.21/js/jquery.dataTables.min.js"></script>
<script
	src="https://cdn.datatables.net/1.10.21/js/dataTables.bootstrap4.min.js"></script>
<script src="https://cdn.datatables.net/buttons/1.6.2/js/dataTables.buttons.min.js"></script>
<script src="https://cdn.datatables.net/buttons/1.6.2/js/buttons.flash.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/pdfmake.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/vfs_fonts.js"></script>
<script src="https://cdn.datatables.net/buttons/1.6.2/js/buttons.html5.min.js"></script>
<script src="https://cdn.datatables.net/buttons/1.6.2/js/buttons.print.min.js"></script>
<script src="https://cdn.datatables.net/select/1.3.1/js/dataTables.select.min.js"></script>
<script type="text/javascript">
	$(document)
			.ready(
					function() {
						var table = $('#example')
								.DataTable(
										{
											pageLength : 4,
											buttons: [
									            'copy', 'csv', 'excel', 'pdf',
									            {
									                extend: 'print',
									                text: 'Print all (not just selected)',
									                exportOptions: {
									                    modifier: {
									                        selected: null
									                    }
									                }
									            }
									        ],
											"order" : [ [ 0, "asc" ],
													[ 1, "asc" ], [ 2, "asc" ],
													[ 3, "asc" ], [ 4, "asc" ],
													[ 5, "asc" ], [ 6, "asc" ] ],
											"dom" : '<"pull-left"l><"pull-center"f><"pull-left"B><"pull-right"p>rti',
											"lengthMenu" : [
													[ 4, 50, 100, -1 ],
													[ 4, 50, 100, "All" ] ],
											 select: true
										});
					});
</script>
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

h3 {
	text-align: center;
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
	<span style="float: right;color: #2196F3">Current User, <%=name%></span>
	<span id="date_time" style="float: left;"></span>
	<script type="text/javascript">
		window.onload = date_time('date_time');
	</script>
	<br/>
	<c:forEach items="${defaulterList}" var="data" end="0">
		<h6>
			Status as on Date: <c:out value="${data.currentDateTime}" />
		</h6>
	</c:forEach>
	<br />
	<div align="center">
		<h3 style="text-decoration:underline">DEFAULTER LIST</h3>
		<table id="example"
			class="table table-striped table-bordered cell-border"
			style="width: 100%; height: 20%; background-color: white">
			<thead>
				<tr style="background-color: #2196F3">
					<td><b>Member Id</b></td>
					<td><b>Item Id</b></td>
					<td><b>Item Type</b></td>
					<td><b>Due Date</b></td>
					<td><b>Title</b></td>
					<td><b>Author</b></td>
					<td><b>Action</b></td>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="data" items="${defaulterList}">
					<tr>
						<td><c:out value="${data.memberId}" /></td>
						<td><c:out value="${data.itemId}" /></td>
						<td><c:out value="${data.itemType}" /></td>
						<td><c:out value="${data.dueDateTime}" /></td>
						<td><c:out value="${data.title}" /></td>
						<td><c:out value="${data.author}" /></td>
						<td>
							<form method="post" id="emailId" action="email"></form>
							<button class="btn" form="emailId"
								style="float: none; width: 100%; font-size: 12px" type="submit"
								name="selectedMemberId" value="${data.memberId}">
								<i class="fa fa-bell"></i> Notify
							</button>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
</body>
</html>