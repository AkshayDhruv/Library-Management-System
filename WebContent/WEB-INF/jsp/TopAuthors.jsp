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
<style type="text/css">
.css-serial {
	counter-reset: serial-number; /* Set the serial number counter to 0 */
}

.css-serial td:first-child:before {
	counter-increment: serial-number;
	/* Increment the serial number counter */
	content: counter(serial-number); /* Display the counter */
}

.modal-dialog, .modal-content {
	/* 80% of window height */
	height: 90%;
	width: 1200px;
	margin-top: 50px;
	margin-left: 50px;
}

.modal-body {
	/* 100% = dialog height, 120px = header + footer */
	max-height: calc(100% - 120px);
	overflow-y: scroll;
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
	<div class="modal-header">
		<h4 class="modal-title"><b>Top 10 Most Favorite Authors</b></h4>
		<button type="button" class="close" data-dismiss="modal">&times;</button>
	</div>
	<div class="modal-body">
	<span style="float: right;color: #2196F3">Current User, <%=name%></span>
		<table class="table table-bordered css-serial ">
			<thead>
				<tr style="background-color: #2196F3">
					<th style="width:20%"><b>Sr.No.&nbsp;&nbsp;</b></th>
					<th><b>Author Name</b></th>
					<th><b>Item Published</b></th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${listAuthors}" var="data">
					<tr style="background-color: white">
						<td style="width:20%"></td>
						<td><c:out value="${data.author}" /></td>
						<td><c:out value="${data.itemType}" /></td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
	<div class="modal-footer">
		<button type="button" class="btn btn-default"
			style="float: none; width: 30%; font-size: 16px" data-dismiss="modal">Close</button>
	</div>
</body>
</html>