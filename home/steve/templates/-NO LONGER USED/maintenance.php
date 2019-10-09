<?php
	header($_SERVER["SERVER_PROTOCOL"] . " 503 Service Temporarily Unavailable");
	//header("HTTP/1.1 503 Service Temporarily Unavailable");
	header("Status: 503 Service Temporarily Unavailable");
	header("Retry-After: 3600");
?>

<!DOCTYPE html>
<html>
<head>
<title>REPLACE WITH TITLE</title>
<meta http-equiv="content-type" content="text/html; charset=utf-8" >
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<style>
	@import url('https://fonts.googleapis.com/css?family=Varela+Round');
</style>

<style type="text/css">

body {
	background-color: #d7dfac;
}

body, h1, p {
	font-family: 'Varela Round', sans-serif;
	font-size: 52px;
	font-weight: normal;
	margin: 0;
	padding: 0;
	text-align: center;
	color: #eaefca;
}

.container {
	margin-left:  auto;
	margin-right:  auto;
	margin-top: 175px;
	max-width: 1170px;
	padding-right: 15px;
	padding-left: 15px;
}

.row:before, .row:after {
	display: table;
	content: " ";
}

h1 {
	font-size: 48px;
	font-weight: 300;
	margin: 0 0 20px 0;
}

.lead {
	font-size: 21px;
  	font-weight: 200;
	margin-bottom: 20px;
}

p {
	margin: 0 0 10px;
}

a {
	color: #3282e6;
	text-decoration: none;
}

.domain {
	font-size: 60px;
	font-weight: bold;
	color: #fafbdf;
}

.tag-line {
	font-size: 52px;
	color: #eaefca;
}

.tag-line-2 {
	font-size: 52px;
	color: #fafbdf;
}

.version {
	background-color: #fafbe2;
	margin: 0 auto;
	width: 310px;
	padding-top: 10px;
	padding-bottom: 10px;
	/*border: 1px solid;*/
	margin-top: 50px;
	font-family: Monaco, monospace;
	font-size: 20px;
	color: #d7dfac;
}

/* D E V I C E S */
@media (max-width: 767px) {
	.domain {
		font-size: 40px;
		font-weight: bold;
		color: #fafbdf;
	}

	.tag-line {
		font-size: 32px;
		color: #eaefca;
	}
}

@media (max-width: 767px) and (orientation: landscape) {
	.container {
		margin-top: 100px;
		max-width: 1170px;
	}
}

</style>
</head>

<body>
<div class="container text-center" id="error">
	<div class="row">
		<div class="col-md-12">
			<div class="main-icon text-success">
				<span class="uxicon uxicon-clock-refresh"></span>
			</div>
			<h1 class="domain">Pardon My Appearance</h1>
			<h1><span  class="tag-line">REPLACE WITH DOMAIN</span><span class="tag-line-2"> is undergoing maintenance</span></h1>
			<p class="version">REPLACE WITH VERSION</p>
		</div>
	</div>

</div>

</body>
</html>