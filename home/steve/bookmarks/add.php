<?php

	$mysql_credentials = parse_ini_file('../mysql-credentials.ini');
	//print_r($mysql_credentials);

	date_default_timezone_set("Europe/London");
	
	if(isset($_POST['url'])) $url=$_POST['url'];
	if(isset($_POST['title'])) $title=$_POST['title'];
	if(isset($_POST['taglist'])) $taglist=$_POST['taglist'];
	$table = 'bm_posts';
	$slug = create_slug($title);

	// defaults
	$post_author = 1;
	$post_date = date("Y-m-d H:i:s");
	$post_date_gmt = gmdate('Y-m-d H:i:s', strtotime($post_date) );
	$post_content = '<a href="' . $url . '" target="_blank" rel="noopener">' . $url . '</a>';
	$post_status = "publish";
	$comment_status = "closed";
	
	// Connect to the database
	$mysqli = new mysqli($mysql_credentials['host'], $mysql_credentials['username'], $mysql_credentials['password'], $mysql_credentials['database']);
	if (mysqli_connect_errno()) {
		die("Can not connect to the database: " . mysqli_connect_error());
	}

	// Change character set to utf8
	if (!$mysqli->set_charset("utf8")) {
		die("Error loading character set utf8: %s\n" . $mysqli->error);
	}
	
	$queries = array('','','','','','','');
	
	$statements = array(	"INSERT INTO bm_posts (`post_author`, `post_date`, `post_date_gmt`, `post_content`, `post_title`, `post_status`, `comment_status`, `post_name`, `post_modified`, `post_modified_gmt`) values(?,?,?,?,?,?,?,?,?,?)",
							"SELECT name FROM bm_terms WHERE `name`=? LIMIT 1",
							"INSERT INTO bm_terms (`name`, `slug`, `term_group`) values(?,?,?)",
							"INSERT INTO bm_term_taxonomy (`term_id`,`taxonomy`) VALUES(?,?)",
							"SELECT bm_term_taxonomy.term_taxonomy_id, bm_term_taxonomy.count FROM bm_terms INNER JOIN bm_term_taxonomy ON bm_terms.`term_id` = bm_term_taxonomy.`term_id` WHERE bm_terms.`name` =?",
							"INSERT INTO bm_term_relationships (`object_id`, `term_taxonomy_id`) values(?,?)",
							"UPDATE `bm_term_taxonomy` SET `count`=? WHERE `term_taxonomy_id`=?"
						);
						
	$queries[0] = $mysqli->prepare($statements[0]);				
	$queries[1] = $mysqli->prepare($statements[1]);
	$queries[2] = $mysqli->prepare($statements[2]);
	$queries[3] = $mysqli->prepare($statements[3]);
	$queries[4] = $mysqli->prepare($statements[4]);
	$queries[5] = $mysqli->prepare($statements[5]);
	$queries[6] = $mysqli->prepare($statements[6]);

	
	
	

	
	// Check if 'Bookmark' category exists in bm_terms table
	// $queries[1]
	$name = "Bookmark";
	$stmt = $mysqli->prepare("SELECT name FROM bm_terms WHERE `name`=? LIMIT 1");
	$stmt->bind_param("s", $name);
	$stmt->execute();
	$stmt->bind_result($return_val);
	$stmt->fetch();
	$stmt->close();
	
	if ( $return_val == "" ) {
		
		// Add row to bm_terms
		// $queries[2]
		$lcname = strtolower($name);
		$term_group = 0;
		$stmt = $mysqli->prepare("INSERT INTO bm_terms (`name`, `slug`, `term_group`) values(?,?,?)");
		$stmt->bind_param("ssi", $name, $lcname, $term_group);
		$stmt->execute();
		$term_id = $stmt->insert_id;			// Used to create bm_term_taxonomy row
		$stmt->close();
		
		// Add row to bm_term_taxonomy
		// $queries[3]
		$taxonomy = "category";
		$stmt = $mysqli->prepare("INSERT INTO bm_term_taxonomy (`term_id`,`taxonomy`) VALUES(?,?)");
		//$term_taxonomy_id = $stmt->insert_id;	// Used to create bm_term_relationships row
		$stmt->close();
		
		
	//} else {
		//echo $return_val;
	}
	
	
	// Check if 'Link' post type exists in bm_terms table
	// $queries[1]
	$name = "post-format-link";
	$stmt = $mysqli->prepare("SELECT name FROM bm_terms WHERE `name`=? LIMIT 1");
	$stmt->bind_param("s", $name);
	$stmt->execute();
	$stmt->bind_result($return_val);
	$stmt->fetch();
	$stmt->close();
	
	if ( $return_val == "" ) {
		
		// Add row to bm_terms
		// $queries[2]
		$term_group = 0;
		$stmt = $mysqli->prepare("INSERT INTO bm_terms (`name`, `slug`, `term_group`) values(?,?,?)");
		$stmt->bind_param("ssi", $name, $name, $term_group);
		$stmt->execute();
		$term_id = $stmt->insert_id;			// Used to create bm_term_taxonomy row
		$stmt->close();
		
		// Add row to bm_term_taxonomy
		// $queries[3]
		$taxonomy = "post_format";
		$stmt = $mysqli->prepare("INSERT INTO bm_term_taxonomy (`term_id`,`taxonomy`) VALUES(?,?)");
		$stmt->bind_param("is", $term_id, $taxonomy);
		$stmt->execute();
		//$term_taxonomy_id = $stmt->insert_id;	// Used to create bm_term_relationships row
		$stmt->close();
		
		
	//} else {
		//echo $return_val;
	}
	
	
	/*
	$a_term_taxonomy_id = array('','');
	$a_count = array('','');
	
	
	// Get term_taxonomy_id from bm_term_taxonomy
	$name = "Bookmark";
	$stmt = $mysqli->prepare("SELECT bm_term_taxonomy.term_taxonomy_id, bm_term_taxonomy.count FROM bm_terms INNER JOIN bm_term_taxonomy ON bm_terms.`term_id` = bm_term_taxonomy.`term_id` WHERE bm_terms.`name` =?");
	$stmt->bind_param("s", $name);
	$stmt->execute();
	$stmt->bind_result($a_term_taxonomy_id[0], $a_count[0]);
	$stmt->fetch();
	$a_count[0] = $a_count[0] + 1;
	//$stmt->close();	
	//echo $uncategorised . "\n";
	//print_r($a_count);
	
	$name = "post-format-link";
	// no need to create another $mysqli->prepare object
	$stmt->bind_param("s", $name);
	$stmt->execute();
	$stmt->bind_result($a_term_taxonomy_id[1], $a_count[1]);
	$stmt->fetch();
	$stmt->close();	
	$a_count[1] = $a_count[1] + 1;
	//echo $post_format_link;
	//print_r($a_count);
	*/
	
	
	// 1. Add row to bm_posts
	// $queries[0]
	$stmt = $mysqli->prepare("INSERT INTO $table (`post_author`, `post_date`, `post_date_gmt`, `post_content`, `post_title`, `post_status`, `comment_status`, `post_name`, `post_modified`, `post_modified_gmt`) values(?,?,?,?,?,?,?,?,?,?)");
	$stmt->bind_param('isssssssss', $post_author, $post_date, $post_date_gmt, $post_content, $title, $post_status, $comment_status, $slug, $post_date, $post_date_gmt);
	$stmt->execute();
	$object_id = $stmt->insert_id;
	$stmt->close();
	
	// 2. Check and add row for tag to bm_terms
	$tags = explode(" ", preg_replace('/\s\s+/', ' ', preg_replace('/,/', ' ', $taglist) ) );
	
	foreach($tags as $tag) {

		if ($tag != "") {
	
			// Check if tag exists in bm_terms
			//echo $tag;
			$queries[1]->bind_param("s", $tag);
			$queries[1]->execute();
			$queries[1]->bind_result($name);
			$queries[1]->fetch();
			$queries[1]->free_result();
			//echo $name  . "<br />";
	
			if ( $name == "" ) {

				// Add tag to bm_terms
				// Add row to bm_terms
				$lcname = strtolower($tag);
				$term_group = 0;
				$queries[2]->bind_param("ssi", $tag, $lcname, $term_group);
				$queries[2]->execute();
				$term_id = $queries[2]->insert_id;			// Used to create bm_term_taxonomy row

				// Add row to bm_term_taxonomy
				$taxonomy = "post_tag";
				$queries[3]->bind_param("is", $term_id, $taxonomy);
				$queries[3]->execute();
		
			}
		
		}
		
		// 3. Get `term_taxonomy_id` and `count` for tag from bm_term_taxonomy
		$queries[4]->bind_param("s", $tag);
		$queries[4]->execute();
		$queries[4]->bind_result($term_taxonomy_id, $count);
		$queries[4]->fetch();
		$queries[4]->free_result();
		$count++;
	
		// 4. Add row in bm_term_relationships for tag
		$queries[5]->bind_param('is', $object_id, $term_taxonomy_id);
		$queries[5]->execute();
	
		// 5. Update count in bm_term_taxonomy
		$queries[6]->bind_param('ii', $count, $term_taxonomy_id);
		$queries[6]->execute();

	}
		
	// 6.  Get `term_taxonomy_id` and `count` for 'Bookmark' category from bm_term_taxonomy
	$search = 'Bookmark';
	$queries[4]->bind_param("s", $search);
	$queries[4]->execute();
	$queries[4]->bind_result($term_taxonomy_id, $count);
	$queries[4]->fetch();
	$queries[4]->free_result();
	$count++;
	
	// 7.  Add row in bm_term_relationships for category
	$queries[5]->bind_param('is', $object_id, $term_taxonomy_id);
	$queries[5]->execute();
	
	// 8.  Update count in bm_term_taxonomy
	$queries[6]->bind_param('ii', $count, $term_taxonomy_id);
	$queries[6]->execute();
	
	// 9.  Get `term_taxonomy_id` and `count` for 'post-format-link' post type from bm_term_taxonomy
	$search = 'post-format-link';
	$queries[4]->bind_param("s", $search);
	$queries[4]->execute();
	$queries[4]->bind_result($term_taxonomy_id, $count);
	$queries[4]->fetch();
	$queries[4]->free_result();
	$count++;
	
	// 10. Create row in bm_term_relationships for post type
	$queries[5]->bind_param('is', $object_id, $term_taxonomy_id);
	$queries[5]->execute();
		
	// 11. Update count in bm_term_taxonomy
	$queries[6]->bind_param('ii', $count, $term_taxonomy_id);
	$queries[6]->execute();
	
	
	/*  * * * * * * * * * * * * * * * * * * * * * * * * O L D    C O D E  * * * * * * * * * * * * * * * * * * * * * * * * */
	
	/*
	// Create the prepared MySQL statement, bind the variables and execute it
    if ($stmt = $mysqli->prepare("INSERT INTO $table (`post_author`, `post_date`, `post_date_gmt`, `post_content`, `post_title`, `post_status`, `comment_status`, `post_name`, `post_modified`, `post_modified_gmt`) values(?,?,?,?,?,?,?,?,?,?)")) {
        $stmt->bind_param('isssssssss', $post_author, $post_date, $post_date_gmt, $post_content, $title, $post_status, $comment_status, $slug, $post_date, $post_date_gmt);
        $stmt->execute();
        $object_id = $stmt->insert_id ;
        
        // Obtain the last inserted ID
        if ($stmt->insert_id != 0) {	
        	//echo "Error adding bookmark";     
        }
        
        $stmt->close();
        
        // Create 2 rows in bm_term_relationships
        $stmt = $mysqli->prepare("INSERT INTO bm_term_relationships (`object_id`, `term_taxonomy_id`) values(?,?)");
		$stmt->bind_param('is', $object_id, $a_term_taxonomy_id[0]);
		$stmt->execute();
		
		$stmt->bind_param('is', $object_id, $a_term_taxonomy_id[1]);
		$stmt->execute();
		
		$stmt->close();
		
		// Update counts in bm_term_taxonomy
		
		$stmt = $mysqli->prepare("UPDATE `bm_term_taxonomy` SET `count`=? WHERE `term_taxonomy_id`=?");
		
		$stmt->bind_param('ii', $a_count[0], $a_term_taxonomy_id[0]);
		$stmt->execute();
		
		$stmt->bind_param('ii', $a_count[1], $a_term_taxonomy_id[1]);
		$stmt->execute();
		
		$stmt->close();
		
	}
	*/
	
	
	$queries[1]->close();
	$queries[2]->close();
	$queries[3]->close();
	$queries[4]->close();
	$queries[5]->close();
	$queries[6]->close();

	echo '<p>Bookmark added. Return to <a class="btn" href="' . $url . '" target="_self">' . $title . '</a></p><br />';
	echo '<button type="button" onclick="window.open(\'\', \'_self\', \'\'); window.close();">Close Tab</button>';
	
	function create_slug($string){
		$slug=strtolower(preg_replace('/[^A-Za-z0-9]+/', '-', $string));
	   
		// remove any hyphen from beginning of string
		if ( substr($slug, 0, 1) == "-" ) {
                $slug = substr($slug,1);
        }
        // remove any hyphen from end of string
        if ( substr($slug, -1) == "-" ) {
                $slug = substr($slug,0, (strlen($slug) - 1));
        }
        return $slug;
	} 
?>
