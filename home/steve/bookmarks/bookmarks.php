<?php
	$url = urldecode($_GET['url']);		// from 'url=' in URL 
	$title = urldecode($_GET['title']);	// from 'title=' in URL
	
	$mysql_credentials = parse_ini_file('../mysql-credentials.ini');
	
	// Connect to the database
	$mysqli = new mysqli($mysql_credentials['host'], $mysql_credentials['username'], $mysql_credentials['password'], $mysql_credentials['database']);
	if (mysqli_connect_errno()) {
		die("Can not connect to the database: " . mysqli_connect_error());
	}

	// Change character set to utf8
	if (!$mysqli->set_charset("utf8")) {
		die("Error loading character set utf8: %s\n" . $mysqli->error);
	}
	
	//$temp=preg_replace('/[^A-Za-z0-9]+/', ' ', $title);
	$words = explode( " ", preg_replace('/[^A-Za-z0-9]+/', ' ', $title) );
	
	$stmt = $mysqli->prepare("SELECT name FROM bm_terms WHERE `name`=?");
	
	$tags = array();
	$e = 0;
	foreach ($words as $word) {
		$stmt->bind_param('s', $word);
		$stmt->execute();
		$stmt->bind_result($return);
		$stmt->fetch();
		
		if ( strtoupper($word) === strtoupper($return) ) {
			$tags[$e] = $return . ' ';
			$e++;
		}
		
		$stmt->free_result();
	}
	
	$tags = array_unique($tags);
	
	$tag_list = '';
	foreach ($tags as $tag) {
		$tag_list .= $tag;
	}
	
	$mysqli->close();
	
?>
	
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml"> 
<head> 
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> 
    <meta name="keywords" content="" /> 
    <meta name="description" content="" /> 
    <meta name="author" content="Steve Ward" /> 
    <title>Add Bookmark</title> 
    <style type="text/css">
    
		/* Content */
		@import url(https://fonts.googleapis.com/css?family=Open+Sans:400italic,700italic,400,700);
		@import url(https://fonts.googleapis.com/css?family=Raleway:400,700);

		/* Headings */
		@import url(https://fonts.googleapis.com/css?family=Oxygen:400,700);
		@import url(https://fonts.googleapis.com/css?family=Roboto:400,700);
		@import url(https://fonts.googleapis.com/css?family=Bitter:400,700,400italic);
		@import url(https://fonts.googleapis.com/css?family=Dosis:400,700);
		@import url(https://fonts.googleapis.com/css?family=Cantarell:400,700,400italic,700italic);
		@import url(https://fonts.googleapis.com/css?family=Cabin+Sketch);
		@import url(https://fonts.googleapis.com/css?family=Montserrat);

		/* Code */
		@import url(https://fonts.googleapis.com/css?family=Source+Code+Pro:400,700);
	
		html,body {
			height:100%;
			width:100%;
			margin:0;
		}
	
		body {
		  display:flex;
		}
   
        form {
        	font-family: "Open Sans";
        	font-size: 20px;
        	margin:auto;	/* If display:flex; it centers both horizontally and vertically */
        	width:700px;
        }
        
        fieldset {
			border:1px solid #999;
			border-radius:8px;
			box-shadow:0 0 10px #999;
		}

        
        label {
            float:left;
            width:30px;
            /*text-align:right;*/
            padding-right:10px;
            /*clear:left;*/
        }
        
        
        label [for="url"], label [for="title"] {
        	padding-top: 7px;
        }
        
        
        input {
            width:507px;
            padding: 5px;
            font-size: 16px;
        }
        
        input::placeholder {
        	color: #ccc;
        }
        
        textarea {
    		resize: none;
    		/*border-radius:5px; */
    		font-size: 16px;
		}

 
         textarea, input[type="text"] { 
    		background-color: #eeffff;
    		border: solid 1px #006699;
    		padding-left: 5px;		
		}

        
        textarea:read-only, input[type="text"]:read-only { 
    		background-color: #ffffee;
    		border: solid 1px #ffcc33;
    		padding-left: 5px;
		}
		
		input[type="text"] {
			padding-left: 5px;
		}
		
        .button {
            width:100px;
            font-size: 20px;
        }
        
		p.heading {
			font-size: 30px;
			margin-top: 10px;
			margin-bottom: 15px;
		}
		
		.button {
			background-color: #0066ff;
			border: none;
			color: #fff;
			padding: 15px 32px;
			text-align: center;
			text-decoration: none;
			display: inline-block;
			margin: 4px 2px;
			cursor: pointer;
			border-radius: 5px;	
			font-size: 20px;	
		}


    </style>
</head> 
<body> 
    <!-- <div id="content"> -->
        <form action="add.php" method="post" accept-charset="utf-8">
            <fieldset>
                <p class="heading">Add Bookmark</p>
                
                <!-- <span style="font-family: 'Source Code Pro';">Test:&nbsp;<input type="text" name="taglist" id="taglist" tabindex="3" placeholder="Enter a comma or space separated list of tags" value="<?php echo $tag_list; ?>"><br /><br /></span>
                <span style="font-family: 'Source Code Pro';">URL:&nbsp;&nbsp;<input type="text" name="taglist" id="taglist" tabindex="3" placeholder="Enter a comma or space separated list of tags" value="<?php echo $tag_list; ?>"><br /><br /></span> -->

                <label for"url" style="font-size: 14px; margin-top: 10px;">URL:</label>
              	<textarea rows="2" cols="60>" name="url" id="url" tabindex="1" readonly><?php echo $url; ?></textarea>
  
                <label for="title" style="font-size: 14px; margin-top: 10px;">Title:</label>
                <textarea rows="2" cols="60>" name="title" id="title" tabindex="2"><?php echo $title; ?></textarea>
  
                <label for="taglist" style="font-size: 14px; margin-top: 5px; padding-right: 12px;">Tags:</label>
                <input type="text" name="taglist" id="taglist" tabindex="3" placeholder="Enter a comma or space separated list of tags" value="<?php echo $tag_list; ?>"><br /><br />
  
                <input type="submit" value="Add" class="button" tabindex="4" />
            </fieldset>
        </form>
    <!-- </div> -->
</body> 
</html>
