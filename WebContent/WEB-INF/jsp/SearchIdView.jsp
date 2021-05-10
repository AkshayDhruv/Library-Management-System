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

.modal-dialog,
.modal-content {
    /* 80% of window height */
    height: 80%;
    width: 1200px;
    margin-top:50px;
    margin-left:50px;
}

.modal-body {
    /* 100% = dialog height, 120px = header + footer */
    max-height: calc(100% - 120px);
    /* overflow-y: scroll; */
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
		<h4 class="modal-title">ITEM STATUS</h4>
		<button type="button" class="close" data-dismiss="modal" onClick="window.location.reload()">&times;</button>
	</div>
	<div class="modal-body">
		<span style="float: right;color: #2196F3">Current User, <%=name%></span>
		<table class="table table-bordered css-serial ">
			<thead>
				<tr style="background-color: #2196F3">
					<th><b>Sr.No.&nbsp;&nbsp;</b></th>
					<th><b>Member Id</b></th>
					<th><b>Item Id</b></th>
					<th><b>Item Status</b></th>
					<th><b>Item Type</b></th>
					<th><b>Borrow Date</b></th>
					<th><b>Due Date &nbsp;&nbsp;&nbsp;</b></th>
					<th><b>Return Date</b></th>
					<th><b>Title</b></th>
					<th><b>Author</b></th>
				</tr>
			<thead>
			<tbody>
				<tr style="background-color: white">
					<td></td>
					<td><c:out value="${data.memberId}" /></td>
					<td><c:out value="${data.itemId}" /></td>
					<td><c:out value="${data.itemStatus}" /></td>
					<td><c:out value="${data.itemType}" /></td>
					<td><c:out value="${data.borrowDateTime}" /></td>
					<td><c:out value="${data.dueDateTime}" /></td>
					<td><c:out value="${data.returnDateTime}" /></td>
					<td><c:out value="${data.title}" /></td>
					<td><c:out value="${data.author}" /></td>
				</tr>
			</tbody>
		</table>
	</div>
	<div class="modal-footer">
		<button type="button" class="btn btn-default"
			style="float: none; width: 30%; font-size: 16px" data-dismiss="modal" onClick="window.location.reload()">Close</button>
	</div>
</body>
</html>