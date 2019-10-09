
<!doctype html>

<html lang="en">
<head>
	<meta charset="utf-8">

	<title>Error</title>
	<meta name="description" content="The HTML5 Herald">
	<meta name="author" content="SitePoint">
	<link  rel='stylesheet' href='https://fonts.googleapis.com/css?family=Poppins'>
	
	<style>
		body {
			font-family: Poppins;
		}
	</style>

	<!--[if lt IE 9]>
		<script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
  	<![endif]-->
</head>

<body>
	
	<?php
	
		$http = http_response_code();

		switch ($http) {
			case "403":
				$message = "Forbidden";
				break;
			case "404":
				$message = "Not Found";
				break;
    		case "500":
		        $message = "Internal Server Error";
        		break;
			case "502":
				$message = "Bad Gateway";
				break;
			case "503":
				$message = "Service Unavailable";
				break;
			case "504":
				$message = "Gateway Timeout";
				break;
		}
	
		echo "The server says [" . $_SERVER['DOCUMENT_ROOT'] . "]: Error " . http_response_code() . " - " . $message ; 

	/*
		echo $_SERVER['SERVER_NAME'];
		echo $_SERVER['REQUEST_URI'];
		echo $_SERVER['DOCUMENT_ROOT'];
		echo http_response_code();
	*/

	?>

</body>
</html>