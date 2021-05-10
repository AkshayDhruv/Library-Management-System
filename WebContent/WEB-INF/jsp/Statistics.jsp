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
	href="https://cdn.datatables.net/buttons/1.6.2/css/buttons.dataTables.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">

<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>

<!-- Bootstrap library -->

<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>


<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<link rel="stylesheet" type="text/css"
	href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.1.2/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css"
	href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/css/bootstrap-select.min.css">
<script type="text/javascript"
	src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.3.1/js/bootstrap.bundle.min.js"></script>
<script type="text/javascript"
	src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/js/bootstrap-select.min.js"></script>

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
	margin-right: 5px;
}

body {
	font-family: Arial;
	background-color: #eeffee;
}

button.dropdown-toggle.bs-placeholder.btn.btn-primary {
	width: 228%;
	margin-right: -305px;
	color: white;
}

.dropdown-menu.show {
	max-height: 300px;
	min-height: 150px;
	min-width: 480px;
}

.bootstrap-select:not([class*=col-]):not([class*=form-control]):not(.input-group-btn)
	{
	width: 220px;
	margin-left: -4%;
}

input#currentDateTime {
	width: 99%;
	margin-left: 1px;
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

	String updateMessage = request.getParameter("updateMessage");
	String Updmsg = null;
	if (updateMessage != null) {
		Updmsg = updateMessage;
		response.setHeader("Refresh", "2;url=statistics");
	} else {
		Updmsg = "";
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
	<br />
	<c:forEach items="${listData}" var="data" end="0">
		<h6>
			Status as on Date:
			<c:out value="${data.currentDateTime}" />
		</h6>
	</c:forEach>
	<div align="center">
		<h3 style="text-decoration: underline">INVENTORY STATS</h3>
		<br /> <span style="float: none; color: red; font-size: 30px"><%=Updmsg%></span>
		<c:if test="${listData == null}">
			<form action="updateCurrentDateTime" method="post">
				<table>
					<tr>
						<td width="21%">Status as on Date:</td>
						<td><input type="datetime-local" id="currentDateTime"
							onchange="this.form.submit()" name="currentDateTime" disabled /></td>
					</tr>
				</table>
			</form>
		</c:if>
		<c:if test="${listData != null}">
			<form action="updateCurrentDateTime" method="post">
				<table>
					<tr>
						<td width="21%">Status as on Date:</td>
						<td><input type="datetime-local" id="currentDateTime"
							onchange="this.form.submit()" name="currentDateTime" /></td>
					</tr>
				</table>
			</form>
		</c:if>
		<br />
		<table>
			<tr>
				<td width="20%">Status by Item Id:</td>
				<c:if test="${listData == null}">
					<td><select name="selectedItemId" data-href="searchById"
						class="selectpicker openPopup5" data-style="btn btn-primary"
						data-live-search="true"
						data-live-search-placeholder="Search here..."
						title="Select Unique Identification Number (UID)" disabled>
							<c:forEach items="${listData}" var="data">
								<option value="${data.itemId}">${data.itemId}</option>
							</c:forEach>
					</select></td>
				</c:if>
				<c:if test="${listData != null}">
					<td><select name="selectedItemId" data-href="searchById"
						class="selectpicker openPopup5" data-style="btn btn-primary"
						data-live-search="true"
						data-live-search-placeholder="Search here..."
						title="Select Unique Identification Number (UID)">
							<c:forEach items="${listData}" var="data">
								<option value="${data.itemId}">${data.itemId}</option>
							</c:forEach>
					</select></td>
				</c:if>
			</tr>
		</table>
		<br />
		<table>
			<tr>
				<td width="20%">Statistics Report:</td>
				<td><c:if test="${listData == null}">
						<a style="width: 250px" href="/"
							class="btn btn-primary openPopup1" onclick="return false;"><i
							class="fa fa-book"></i> Top 10 Most Favorite Books</a>
						<a style="width: 250px" href="/"
							class="btn btn-primary openPopup2" onclick="return false;"><i
							class="fa fa-user"></i> Top 10 Most Favorite Authors</a>
						<br />
						<br />
						<a style="width: 250px" href="/"
							class="btn btn-primary openPopup3" onclick="return false;"><i
							class="fa fa-newspaper-o"></i> Top 5 Most Favorite Journals</a>
						<a style="width: 250px" href="javascript:void(0);"
							data-href="summary" data-toggle="modal" data-target="#myModal"
							class="btn btn-primary openPopup4"><i
							class="fa fa-sticky-note-o"></i> Summary of Status Inventory</a>
					</c:if> <c:if test="${listData != null}">
						<a style="width: 250px" href="javascript:void(0);"
							data-href="topBooks" data-toggle="modal" data-target="#myModal"
							class="btn btn-primary openPopup1"><i class="fa fa-book"></i>
							Top 10 Most Favorite Books</a>
						<a style="width: 250px" href="javascript:void(0);"
							data-href="topAuthors" data-toggle="modal" data-target="#myModal"
							class="btn btn-primary openPopup2"><i class="fa fa-user"></i>
							Top 10 Most Favorite Authors</a>
						<br />
						<br />
						<a style="width: 250px" href="javascript:void(0);"
							data-href="topJournals" data-toggle="modal"
							data-target="#myModal" class="btn btn-primary openPopup3"><i
							class="fa fa-newspaper-o"></i> Top 5 Most Favorite Journals</a>
						<a style="width: 250px" href="javascript:void(0);"
							data-href="summary" data-toggle="modal" data-target="#myModal"
							class="btn btn-primary openPopup4"><i
							class="fa fa-sticky-note-o"></i> Summary of Status Inventory</a>
					</c:if></td>
			</tr>
		</table>
	</div>
	<div class="modal fade" id="myModal" role="dialog">
		<div class="modal-dialog">
			<div class="modal-content"></div>
		</div>
	</div>
	<script>
		$(document).ready(function() {
			$('.openPopup1').on('click', function() {
				var dataURL1 = $(this).attr('data-href');
				$('.modal-content').load(dataURL1, function() {
					$('#myModal').modal({
						show : true
					});
				});
			});
			$('.openPopup2').on('click', function() {
				var dataURL2 = $(this).attr('data-href');
				$('.modal-content').load(dataURL2, function() {
					$('#myModal').modal({
						show : true
					});
				});
			});
			$('.openPopup3').on('click', function() {
				var dataURL3 = $(this).attr('data-href');
				$('.modal-content').load(dataURL3, function() {
					$('#myModal').modal({
						show : true
					});
				});
			});
			$('.openPopup4').on('click', function() {
				var dataURL4 = $(this).attr('data-href');
				$('.modal-content').load(dataURL4, function() {
					$('#myModal').modal({
						show : true
					});
				});
			});
			$('.openPopup5').on('change', function() {
				var newId = $(this).val();
				var dataURL5 = $(this).attr('data-href');
				var newURL = dataURL5 + '?id=' + newId;
				$('.modal-content').load(newURL, function() {
					$('#myModal').modal({
						show : true
					});
				});
			});
		});
	</script>
</body>
</html>