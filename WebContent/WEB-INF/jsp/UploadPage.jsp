<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*, javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<title>Library Management System</title>
<script type="text/javascript">
	function _(el) {
		return document.getElementById(el);
	}

	function uploadFile() {
		var fileInput = document.getElementById('customFile');
		var filePath = fileInput.value;
		var allowedExtensions = /(\.xlsx|\.xlsm)$/i;
		if (!allowedExtensions.exec(filePath)) {
			alert('Invalid File. Please upload file having extensions .xlsx or.xlsm only.');
			fileInput.value = '';
			location.reload();
		} else {
			var file = _("customFile").files[0];
			var formdata = new FormData();
			formdata.append("customFile", file);
			var ajax = new XMLHttpRequest();
			ajax.upload.addEventListener("progress", progressHandler, false);
			ajax.addEventListener("load", completeHandler, false);
			ajax.addEventListener("error", errorHandler, false);
			ajax.addEventListener("abort", abortHandler, false);
			ajax.open("POST", "upload");
			ajax.send(formdata);
		}
	}

	function progressHandler(event) {
		_("loaded_n_total").innerHTML = "Uploaded " + event.loaded
				+ " bytes of " + event.total;
		var percent = (event.loaded / event.total) * 100;
		_("progressBar").value = Math.round(percent);
		_("status").innerHTML = "Processing your file. Please wait a few moments.";
	}

	function completeHandler(event) {
		_("status").innerHTML = "File Processed Successfully!";
		_("customFile").value = "";
		_("progressBar").value = 0; 
		setTimeout(function(){
			   window.location.reload(1);
			}, 5000);
	}

	function errorHandler(event) {
		_("status").innerHTML = "Upload Failed";
	}

	function abortHandler(event) {
		_("status").innerHTML = "Upload Aborted";
	}
	
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
	table-layout: fixed;
	margin-left: 200px;
	margin-right: 200px;
}

td {
	padding: 50px;
}
</style>
<script>

function test(){
	alert("You are not authorised to view this page.")
	window.location.href="home";
}
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
		if(email.trim().equals("admin123@gmail.com")){
			name = (String) session.getAttribute("name");
		}
		else{
			%>
	<script>
		test();
	</script>
	<%
		}
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
	<br />
	<br />
	<div align="center">
		<h2 style="text-decoration:underline">UPLOAD INVENTORY</h2>
		<br/>
		<table>
			<tr style="background-color: #2196F3; text-align: center">
				<th>Upload File (only *.xlsm or *.xlsx file type allowed)</th>
			</tr>
			<tr style="background-color: white; text-align: center">
				<td>
					<h4 style="text-align: center">Select files from your system</h4> <br />
					<form method="post" enctype="multipart/form-data">
						<div class="custom-file">
							<input style="text-align: center" type="file" name="customFile"
								class="custom-file-input" id="customFile" onchange="uploadFile()" />
							<label class="custom-file-label" for="customFile">Choose file</label>
						</div>
						<br /><br/>
						<progress id="progressBar" value="0" max="100"
							style="height: 30px; width: 100%;"></progress>
						<br />
						<h3 style="text-align: center" id="status"></h3>
						<p style="text-align: center" id="loaded_n_total"></p>
					</form> <br />
					<form method="post" action="download">
						<button class="btn btn-primary"
							style="float: none; width: 100%; font-size: 14px; text-align: center"
							type="submit" name="submit" id="formButton">
							<i class="fa fa-download"></i> Download Sample File
						</button>
					</form>
				</td>
			</tr>
		</table>
	</div>
	<div id="alertModal" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">Errors Found!</h4>
            </div>
            <div class="modal-body">
                <p></p>
            </div>
            <div class="modal-footer">
                <button class="btn btn-default" data-dismiss="modal">
                    Close</button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
</div><!-- /.modal -->
	<script>
// Add the following code if you want the name of the file appear on select
$(".custom-file-input").on("change", function() {
  var fileName = $(this).val().split("\\").pop();
  $(this).siblings(".custom-file-label").addClass("selected").html(fileName);
});
</script>
</body>
</html>