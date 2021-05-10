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
	href="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
	rel="stylesheet" id="bootstrap-css">
<script
	src="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
<script
	src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
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
<script type="text/javascript">
function toggleResetPswd(e){
    e.preventDefault();
    $('#logreg-forms .form-signin').toggle() // display:block or none
    $('#logreg-forms .form-reset').toggle() // display:block or none
}

function toggleSignUp(e){
    e.preventDefault();
    $('#logreg-forms .form-signin').toggle(); // display:block or none
    $('#logreg-forms .form-signup').toggle(); // display:block or none
}

$(()=>{
    // Login Register Form
    $('#logreg-forms #forgot_pswd').click(toggleResetPswd);
    $('#logreg-forms #cancel_reset').click(toggleResetPswd);
    $('#logreg-forms #btn-signup').click(toggleSignUp);
    $('#logreg-forms #cancel_signup').click(toggleSignUp);
})
</script>
<style type="text/css">

/* sign in FORM */
#logreg-forms {
	width: 412px;
	margin: 10vh auto;
	background-color: #f3f3f3;
	box-shadow: 0 1px 3px rgba(0, 0, 0, 0.12), 0 1px 2px rgba(0, 0, 0, 0.24);
	transition: all 0.3s cubic-bezier(.25, .8, .25, 1);
}

#logreg-forms form {
	width: 100%;
	max-width: 410px;
	padding: 15px;
	margin: auto;
}

#logreg-forms .form-control {
	position: relative;
	box-sizing: border-box;
	height: auto;
	padding: 10px;
	font-size: 16px;
}

#logreg-forms .form-control:focus {
	z-index: 2;
}

#logreg-forms .form-signin input[type="email"] {
	margin-bottom: -1px;
	border-bottom-right-radius: 0;
	border-bottom-left-radius: 0;
}

#logreg-forms .form-signin input[type="password"] {
	border-top-left-radius: 0;
	border-top-right-radius: 0;
}

#logreg-forms .social-login {
	width: 390px;
	margin: 0 auto;
	margin-bottom: 14px;
}

#logreg-forms .social-btn {
	font-weight: 100;
	color: white;
	width: 190px;
	font-size: 0.9rem;
}

#logreg-forms a {
	display: block;
	padding-top: 10px;
	color: lightseagreen;
}

#logreg-form .lines {
	width: 200px;
	border: 1px solid red;
}

#logreg-forms button[type="submit"] {
	margin-top: 10px;
}

#logreg-forms .facebook-btn {
	background-color: #3C589C;
}

#logreg-forms .google-btn {
	background-color: #DF4B3B;
}

#logreg-forms .form-reset, #logreg-forms .form-signup {
	display: none;
}

#logreg-forms .form-signup .social-btn {
	width: 210px;
}

#logreg-forms .form-signup input {
	margin-bottom: 2px;
}

.form-signup .social-login {
	width: 210px !important;
	margin: 0 auto;
}

/* Mobile */
@media screen and (max-width:500px) {
	#logreg-forms {
		width: 300px;
	}
	#logreg-forms  .social-login {
		width: 200px;
		margin: 0 auto;
		margin-bottom: 10px;
	}
	#logreg-forms  .social-btn {
		font-size: 1.3rem;
		font-weight: 100;
		color: white;
		width: 200px;
		height: 56px;
	}
	#logreg-forms .social-btn:nth-child(1) {
		margin-bottom: 5px;
	}
	#logreg-forms .social-btn span {
		display: none;
	}
	#logreg-forms  .facebook-btn:after {
		content: 'Facebook';
	}
	#logreg-forms  .google-btn:after {
		content: 'Google+';
	}
}

body {
	font-family: Arial;
	background-color: #eeffee;
	margin: 0;
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
        String email=(String)session.getAttribute("email");
        //redirect user to home page if already logged in
        if(email!=null){
            response.sendRedirect("home");
        } 
        String errorMessage = request.getParameter("errorMessage");
    	String errMsg = null;
    	if (errorMessage != null) {
    		errMsg = errorMessage;
    		response.setHeader("Refresh", "3;url=loginPage");
    	} else {
    		errMsg = "";
    	}
    	String message = request.getParameter("message");
    	String msg = null;
    	if (message != null) {
    		msg = message;
    		response.setHeader("Refresh", "3;url=loginPage");
    	} else {
    		msg = "";
    	}
    	String passMessage = request.getParameter("passMessage");
    	String passmsg = null;
    	if (passMessage != null) {
    		passmsg =  passMessage;
    		response.setHeader("Refresh", "3;url=loginPage");
    	} else {
    		passmsg = "";
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
	<span id="date_time" style="float: left;"></span>
	<script type="text/javascript">
		window.onload = date_time('date_time');
	</script>
	<br />
	<div align="center">
		<h2 align="center" style="text-decoration: underline">LOGIN PAGE</h2>
				<span style="text-align: center; color: green; font-size:20px"><%=msg%></span>
				<span style="color: red; text-align: center; font-size:20px"><%=errMsg%></span>
				<span style="color: #2196F3; text-align: center; font-size:20px"><%=passmsg%></span>
		<div id="logreg-forms">
			<form class="form-signin" action="login" method="post">
				<h1 class="h3 mb-3 font-weight-normal" style="text-align: center">
					Sign In</h1>
				<input type="email" id="inputEmail" name="email"
					class="form-control" placeholder="Email address" required autofocus>
				<input type="password" id="inputPassword" name="password"
					class="form-control" placeholder="Password" required>

				<button class="btn btn-success " type="submit"
					style="float: none; width: 100%; font-size: 14px; text-align: center">
					<i class="fa fa-sign-in"></i> Login
				</button>
				<a href="#" id="forgot_pswd">Forgot password?</a>
				<hr>
				<!-- <p>Don't have an account!</p>  -->
				<button class="btn btn-primary btn-block" type="button"
					id="btn-signup"
					style="float: none; width: 100%; font-size: 14px; text-align: center">
					<i class="fa fa-user-plus"></i> Register
				</button>
			</form>

			<form action="requestPassword" method="post" class="form-reset">
			<h1 class="h3 mb-3 font-weight-normal" style="text-align: center">
					Request Password</h1>
				<input type="text" id="user-name" name="registeredUserName" class="form-control"
					placeholder="Full name" required autofocus> 
				<input type="email" id="resetEmail" name="registeredUserEmail" class="form-control"
					placeholder="Email address" required autofocus>
				<input type="text" id="security-question" class="form-control"
					placeholder="What is your favorite food?" readonly>
				<input type="text" id="security-answer" name="registeredUserSecurityAnswer" class="form-control"
					placeholder="Security Answer" required autofocus>
				<button class="btn btn-primary btn-block" type="submit"
					style="float: none; width: 100%; font-size: 14px; text-align: center">Submit</button>
				<a href="#" id="cancel_reset"><i class="fa fa-angle-left"></i>
					Back</a>
			</form>

			<form action="register" method="post" class="form-signup">
			<h1 class="h3 mb-3 font-weight-normal" style="text-align: center">
					New Registration</h1>
				<input type="text" id="user-name" name="newUser" class="form-control"
					placeholder="Full name" required autofocus> 
				<input type="email" id="user-email" name="email" class="form-control"
					placeholder="Email address" required autofocus> 
				<input type="password" id="user-pass" name="password" class="form-control"
					placeholder="Password" required autofocus> 
				<input type="text" id="security-question" class="form-control"
					placeholder="What is your favorite food?" readonly>
				<input type="text" id="security-answer" name="secuityAnswer" class="form-control"
					placeholder="Security Answer" required autofocus>

				<button class="btn btn-primary btn-block" type="submit"
					style="float: none; width: 100%; font-size: 14px; text-align: center">
					<i class="fa fa-user-plus"></i> Sign Up
				</button>
				<a href="#" id="cancel_signup"><i class="fa fa-angle-left"></i>
					Back</a>
			</form>
			<br>

		</div>
		<p style="text-align: center">
			<a
				href="http://bit.ly/2RjWFMfunction toggleResetPswd(e){
    e.preventDefault();
    $('#logreg-forms .form-signin').toggle() // display:block or none
    $('#logreg-forms .form-reset').toggle() // display:block or none
}

function toggleSignUp(e){
    e.preventDefault();
    $('#logreg-forms .form-signin').toggle(); // display:block or none
    $('#logreg-forms .form-signup').toggle(); // display:block or none
}

$(()=>{
    // Login Register Form
    $('#logreg-forms #forgot_pswd').click(toggleResetPswd);
    $('#logreg-forms #cancel_reset').click(toggleResetPswd);
    $('#logreg-forms #btn-signup').click(toggleSignUp);
    $('#logreg-forms #cancel_signup').click(toggleSignUp);
})g"
				target="_blank" style="color: black"></a>
		</p>
	</div>
</body>
</html>