<?php

	date_default_timezone_set("Europe/London");
	
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
	
	$result = mysqli_query($mysqli, "SELECT * FROM my_bookmarks");
	
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
	$search = "Bookmark";
	//$stmt = $mysqli->prepare("SELECT name FROM bm_terms WHERE `name`=? LIMIT 1");
	$queries[1]->bind_param("s", $search);
	$queries[1]->execute();
	$queries[1]->bind_result($return_val);
	$queries[1]->fetch();
	//$queries[1]->close();
	echo $search . '<br />' . $return_val . '<br />';
	
	if ( $return_val == "" ) {
		
		// Add row to bm_terms
		$lcname = strtolower($search);
		$term_group = 0;
		//$stmt = $mysqli->prepare("INSERT INTO bm_terms (`name`, `slug`, `term_group`) values(?,?,?)");
		$queries[2]->bind_param("ssi", $search, $lcname, $term_group);
		$queries[2]->execute();
		$term_id = $queries[2]->insert_id;			// Used to create bm_term_taxonomy row
		//$queries[2]->close();
		
		// Add row to bm_term_taxonomy
		$taxonomy = "category";
		//$stmt = $mysqli->prepare("INSERT INTO bm_term_taxonomy (`term_id`,`taxonomy`) VALUES(?,?)");
		$queries[3]->bind_param("is", $term_id, $taxonomy);
		$queries[3]->execute();
		//$term_taxonomy_id = $stmt->insert_id;	// Used to create bm_term_relationships row
		//$queries[3]->close();
		
	//} else {
		//echo $return_val;
	}
	
	$queries[1]->free_result();
	
	
	// Check if 'Delicious' tag exists in bm_terms table
	$search = "delicious";
	//$stmt = $mysqli->prepare("SELECT name FROM bm_terms WHERE `name`=? LIMIT 1");
	$queries[1]->bind_param("s", $search);
	$queries[1]->execute();
	$queries[1]->bind_result($return_val);
	$queries[1]->fetch();
	//$queries[1]->close();
	echo $search . '<br />' . $return_val . '<br />';
	
	if ( $return_val == "" ) {
		
		// Add row to bm_terms
		$lcname = strtolower($search);
		$term_group = 0;
		//$stmt = $mysqli->prepare("INSERT INTO bm_terms (`name`, `slug`, `term_group`) values(?,?,?)");
		$queries[2]->bind_param("ssi", $search, $lcname, $term_group);
		$queries[2]->execute();
		$term_id = $queries[2]->insert_id;			// Used to create bm_term_taxonomy row
		//$queries[2]->close();
		
		// Add row to bm_term_taxonomy
		$taxonomy = "post_tag";
		//$stmt = $mysqli->prepare("INSERT INTO bm_term_taxonomy (`term_id`,`taxonomy`) VALUES(?,?)");
		$queries[3]->bind_param("is", $term_id, $taxonomy);
		$queries[3]->execute();
		//$term_taxonomy_id = $stmt->insert_id;	// Used to create bm_term_relationships row
		//$queries[3]->close();
		
		
	//} else {
		//echo $return_val;
	}
	
	$queries[1]->free_result();
	
	
	// Check if 'Link' post type exists in bm_terms table
	$search = "post-format-link";
	//$stmt = $mysqli->prepare("SELECT name FROM bm_terms WHERE `name`=? LIMIT 1");
	$queries[1]->bind_param("s", $search);
	$queries[1]->execute();
	$queries[1]->bind_result($return_val);
	$queries[1]->fetch();
	//$queries[1]->close();
	echo $search . '<br />' . $return_val . '<br />';
	
	if ( $return_val == "" ) {
		
		// Add row to bm_terms
		$lcname = strtolower($search);
		$term_group = 0;
		//$stmt = $mysqli->prepare("INSERT INTO bm_terms (`name`, `slug`, `term_group`) values(?,?,?)");
		$queries[2]->bind_param("ssi", $search, $lcname, $term_group);
		$queries[2]->execute();
		$term_id = $queries[2]->insert_id;			// Used to create bm_term_taxonomy row
		//$queries[2]->close();
		
		// Add row to bm_term_taxonomy
		$taxonomy = "post_format";
		//$stmt = $mysqli->prepare("INSERT INTO bm_term_taxonomy (`term_id`,`taxonomy`) VALUES(?,?)");
		$queries[3]->bind_param("is", $term_id, $taxonomy);
		$queries[3]->execute();
		//$term_taxonomy_id = $stmt->insert_id;	// Used to create bm_term_relationships row
		//$queries[3]->close();
		
		
	//} else {
		//echo $return_val;
	}
	
	$queries[1]->free_result();


	
	$i = 1;
	while ($row = mysqli_fetch_array($result, MYSQLI_ASSOC)) {
	
		echo "Processing record " . $i . "<br />";
	
		// Prepare bookmark variables
		$url = $row['href'];
		
		$post_author = 1;
		$post_date = $row['converted_add_date'];
		$post_date_gmt = gmdate('Y-m-d H:i:s', strtotime($post_date) );
		$post_content = '<a href="' . $url . '" target="_blank" rel="noopener">' . $url . '</a>';
		
		$title = $row['title'];
		$post_status = "publish";
		$comment_status = "closed";
		$slug = create_slug($row['title']);
	
		// Add row to bm_posts
		$queries[0]->bind_param('isssssssss', $post_author, $post_date, $post_date_gmt, $post_content, $title, $post_status, $comment_status, $slug, $post_date, $post_date_gmt);
        $queries[0]->execute();
        $object_id = $queries[0]->insert_id;	// Used to create row in bm_term_relationships

		$tags = explode(',', str_replace(' ', '', $row['tags']));
	
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
			
			// Get `term_taxonomy_id` and `count` for $tag from bm_term_taxonomy
			$queries[4]->bind_param("s", $tag);
			$queries[4]->execute();
			$queries[4]->bind_result($term_taxonomy_id, $count);
			$queries[4]->fetch();
			$queries[4]->free_result();
			$count++;
			
			// Create row in bm_term_relationships for tags
			$queries[5]->bind_param('is', $object_id, $term_taxonomy_id);
			$queries[5]->execute();
			
			// Update counts in bm_term_taxonomy
			$queries[6]->bind_param('ii', $count, $term_taxonomy_id);
			$queries[6]->execute();
	
		}
		
		// 'Bookmark' Category
		// Get `term_taxonomy_id` and `count` for 'Bookmark' category from bm_term_taxonomy
		$search = 'Bookmark';
		$queries[4]->bind_param("s", $search);
		$queries[4]->execute();
		$queries[4]->bind_result($term_taxonomy_id, $count);
		$queries[4]->fetch();
		$queries[4]->free_result();
		$count++;
		
		// Create row in bm_term_relationships for tags
		$queries[5]->bind_param('is', $object_id, $term_taxonomy_id);
		$queries[5]->execute();
		
		// Update counts in bm_term_taxonomy
		$queries[6]->bind_param('ii', $count, $term_taxonomy_id);
		$queries[6]->execute();
		
		
		// Get `term_taxonomy_id` and `count` for 'delicious' tag from bm_term_taxonomy
		$search = 'delicious';
		$queries[4]->bind_param("s", $search);
		$queries[4]->execute();
		$queries[4]->bind_result($term_taxonomy_id, $count);
		$queries[4]->fetch();
		$queries[4]->free_result();
		$count++;
		
		// Create row in bm_term_relationships for tags
		$queries[5]->bind_param('is', $object_id, $term_taxonomy_id);
		$queries[5]->execute();
		
		// Update counts in bm_term_taxonomy
		$queries[6]->bind_param('ii', $count, $term_taxonomy_id);
		$queries[6]->execute();


		
		// Get `term_taxonomy_id` and `count` for 'post-format-link' post type from bm_term_taxonomy
		$search = 'post-format-link';
		$queries[4]->bind_param("s", $search);
		$queries[4]->execute();
		$queries[4]->bind_result($term_taxonomy_id, $count);
		$queries[4]->fetch();
		$queries[4]->free_result();
		$count++;
		
		// Create row in bm_term_relationships for tags
		$queries[5]->bind_param('is', $object_id, $term_taxonomy_id);
		$queries[5]->execute();
		
		// Update counts in bm_term_taxonomy
		$queries[6]->bind_param('ii', $count, $term_taxonomy_id);
		$queries[6]->execute();

		
		$i++;
		
		if ($i > 100) {
			//break;
		}
		
	}
			
	$queries[1]->close();
	$queries[2]->close();
	$queries[3]->close();
	$queries[4]->close();
	$queries[5]->close();
	$queries[6]->close();
	
	
	$stmt = $mysqli->prepare("UPDATE bm_posts SET post_title = REPLACE(`post_title` ,?,?)");
	
	$search = "| ã‚ªã‚¹ã‚¹ãƒ¡æ–™é‡‘ãƒ—ãƒ©ãƒ³ | æ˜¥å¾—ã‚­ãƒ£ãƒ³ãƒšãƒ¼ãƒ³ | ãŠç”³ã—è¾¼ã¿ | ã‚¤ãƒ¼ãƒ»ãƒ¢ãƒã‚¤ãƒ«å…¬å¼ã‚¹ãƒˆã‚¢";
	$replace = "| オススメ料金プラン | 春得キャンペーン | お申し込み | イー・モバイル公式ストア";
	$stmt->bind_param('ss', $search, $replace);
	$stmt->execute();

	$search = "ãƒ‡ãƒ¼ã‚¿é€šä¿¡ã‚«ãƒ¼ãƒ‰ D12HWã€€ãƒ¦ãƒ¼ãƒ†ã‚£ãƒªãƒ†ã‚£ã‚½ãƒ•ãƒˆãƒ€ã‚¦ãƒ³ãƒ­ãƒ¼ãƒ‰ | ã‚¤ãƒ¼ãƒ»ãƒ¢ãƒã‚¤ãƒ«";
	$replace = "データ通信カード D12HW　ユーティリティソフトダウンロード | イー・モバイル";
	$stmt->bind_param('ss', $search, $replace);
	$stmt->execute();

	$search = "åº—èˆ—æ¤œç´¢ - é–¢æ±ã‚¨ãƒªã‚¢ã€€ï½œã€€Brooks Brothers Japan";
	$replace = "店舗検索 - 関東エリア｜Brooks Brothers Japan";
	$stmt->bind_param('ss', $search, $replace);
	$stmt->execute();
	
	$search = "Charles Nix éŸ³æ¥½ | ç„¡æ–™ã§è´ãã€ãƒ€ã‚¦ãƒ³ãƒ­ãƒ¼ãƒ‰ã™ã‚‹";
	$replace = "Charles Nix 音楽 | 無料で聴く、ダウンロードする"; 
	$stmt->bind_param('ss', $search, $replace);
	$stmt->execute();
	
	$search = "Twitter / Daisuke Kawano: SnowLeopardã§ã‚‚emobileä½¿ãˆãŸã€‚D0 ...";
	$replace = "Twitter / Daisuke Kawano: SnowLeopardでもemobile使えた。D0 ...";
	$stmt->bind_param('ss', $search, $replace);
	$stmt->execute();
	
	$search = "Twitter / takuma mori: Snow LeopardåŒ–ã—ãŸã‚‰ã€emobileã®U ...";
	$replace = "Twitter / takuma mori: Snow Leopard化したら、emobileのU ..."; 
	$stmt->bind_param('ss', $search, $replace);
	$stmt->execute();
	
	$search = "TBSãƒ†ãƒ¬ãƒ“ç•ªçµ„è¡¨";
	$replace = "TBSテレビ番組表"; 
	$stmt->bind_param('ss', $search, $replace);
	$stmt->execute();
	
	$search = "My SoftBankï½œã‚½ãƒ•ãƒˆãƒãƒ³ã‚¯ï½œãƒˆãƒƒãƒ—ç”»é¢";
	$replace = "My SoftBank｜ソフトバンク｜トップ画面"; 
	$stmt->bind_param('ss', $search, $replace);
	$stmt->execute();
	
	$search = "Macæ•´å‚™æ¸ˆè£½å“ - Appleï¼ˆ日本ï¼‰";
	$replace = "Mac整備済製品 - Apple（日本）"; 
	$stmt->bind_param('ss', $search, $replace);
	$stmt->execute();
	
	$search = "æ±äº¬éƒ½ã®èŠ±ç²‰æƒ…å ± - 日本æ°—è±¡å”ä¼š tenki.jp";
	$replace = "東京都の花粉情報 - 日本気象協会 tenki.jp"; 
	$stmt->bind_param('ss', $search, $replace);
	$stmt->execute();
	
	$search = "IACEãƒˆãƒ©ãƒ™ãƒ«";
	$replace = "IACEトラベル"; 
	$stmt->bind_param('ss', $search, $replace);
	$stmt->execute();

	$search = "PlayStationÂ® - PS3â„¢, PS2â„¢, PSPÂ® & PSPÂ® go Systems, Games & PlayStationÂ®Network";
	$replace = "PlayStation® - PS3™, PS2™, PSP® & PSP® go Systems, Games & PlayStation®Network"; 
	$stmt->bind_param('ss', $search, $replace);
	$stmt->execute();
	
	$search = "PS3â„¢ | User's Guide (Online Instruction Manuals)";
	$replace = "PS3™ | User's Guide (Online Instruction Manuals)"; 
	$stmt->bind_param('ss', $search, $replace);
	$stmt->execute();
	
	$search = "Amazon.com: LaCie 2.5ã‚¤ãƒ³ãƒ ãƒãƒ¼ã‚¿ãƒ–ãƒ«ãƒãƒ¼ãƒ‰ãƒ‡ã‚£ã‚¹ã‚¯ 320GB LCH-RG320T: Computer Peripherals";
	$replace = "Amazon.com: LaCie 2.5インチ ポータブルハードディスク 320GB LCH-RG320T: Computer Peripherals"; 
	$stmt->bind_param('ss', $search, $replace);
	$stmt->execute();

	$search = "ã‚ªãƒ³ãƒ©ã‚¤ãƒ³æ–™é‡‘æ¡ˆå†…";
	$replace = "オンライン料金案内"; 
	$stmt->bind_param('ss', $search, $replace);
	$stmt->execute();
	
	$search = "Conditional Tags Â« WordPress Codex";
	$replace = "Conditional Tags « WordPress Codex"; 
	$stmt->bind_param('ss', $search, $replace);
	$stmt->execute();
	
	$search = "Customizations Â« inFocus";
	$replace = "Customizations « inFocus"; 
	$stmt->bind_param('ss', $search, $replace);
	$stmt->execute();

	$search = "Blog Â« inFocus";
	$replace = "Blog « inFocus"; 
	$stmt->bind_param('ss', $search, $replace);
	$stmt->execute();
	
	$search = "ã??ã??ã?ºã?³ã?³ã?·ã?§ã?«ã?¸ã?¥ï½?mamas' concierge";
	$replace = "ママズコンシェルジュ｜mamas' concierge"; 
	$stmt->bind_param('ss', $search, $replace);
	$stmt->execute();
	
	$search = "Blog â?º patchpeters";
	$replace = "Blog › patchpeters"; 
	$stmt->bind_param('ss', $search, $replace);
	$stmt->execute();
	
	$search = "Use Smart Albums to help set iPhoto â??09 Faces and Places";
	$replace = "Use Smart Albums to help set iPhoto '09 Faces and Places "; 
	$stmt->bind_param('ss', $search, $replace);
	$stmt->execute();
	
	$search = "é??åº¦æ¸¬å®? ã?¹ã??ã?¼ã??ã??ã?¹ã?? ã??ã?­ã?¼ã??ã?ã?³ã??ã??é??åº¦æ¸¬å®? ã?¹ã??ã?¼ã??ã??ã?¹ã??ã?";
	$replace = "速度測定 スピードテスト ブロードバンド「速度測定 スピードテスト」"; 
	$stmt->bind_param('ss', $search, $replace);
	$stmt->execute();

	$search = "å¤§æ??ç?ºLC - è?±ä¼?è©±ã?»å¤?å?½èª?ã¯ã??ã?«ã?ªã??ã??ã?»ã?¸ã?£ã??ã?³";
	$replace = "大手町LC - 英会話・外国語はベルリッツ・ジャパン"; 
	$stmt->bind_param('ss', $search, $replace);
	$stmt->execute();

	$search = "ã?µã?¤ã?³ã?¤ã?³";
	$replace = "サインイン"; 
	$stmt->bind_param('ss', $search, $replace);
	$stmt->execute();

	$search = "Why do I need Passive FTP? - Help Centerâ??Knowledge Base and FAQ";
	$replace = "Why do I need Passive FTP? - Help Center—Knowledge Base and FAQ"; 
	$stmt->bind_param('ss', $search, $replace);
	$stmt->execute();

	$search = "â™«";
	$replace = "♫"; 
	$stmt->bind_param('ss', $search, $replace);
	$stmt->execute();


	$search = "Â»";
	$replace = "»"; 
	$stmt->bind_param('ss', $search, $replace);
	$stmt->execute();
	
	$search = "æ—¥æœ¬";
	$replace = "日本"; 
	$stmt->bind_param('ss', $search, $replace);
	$stmt->execute();
	
	$search = "â€™";
	$replace = "'"; 
	$stmt->bind_param('ss', $search, $replace);
	$stmt->execute();
	
	$search = "";
	$replace = ""; 
	$stmt->bind_param('ss', $search, $replace);
	$stmt->execute();
	
	$search = "";
	$replace = ""; 
	$stmt->bind_param('ss', $search, $replace);
	$stmt->execute();
	
	$search = " â€“";
	$replace = "–"; 
	$stmt->bind_param('ss', $search, $replace);
	$stmt->execute();

	$search = "â€”";
	$replace = "–"; 
	$stmt->bind_param('ss', $search, $replace);
	$stmt->execute();
	
	$search = "â€œ";
	$replace = "\""; 
	$stmt->bind_param('ss', $search, $replace);
	$stmt->execute();
	
	$search = "â€¢";
	$replace = "•"; 
	$stmt->bind_param('ss', $search, $replace);
	$stmt->execute();

	$search = "â€º";
	$replace = " "; 
	$stmt->bind_param('ss', $search, $replace);
	$stmt->execute();

	$search = "ã€€";
	$replace = " "; 
	$stmt->bind_param('ss', $search, $replace);
	$stmt->execute();

	$search = "Â Â ";
	$replace = " "; 
	$stmt->bind_param('ss', $search, $replace);
	$stmt->execute();

	$search = "Â  ";
	$replace = " "; 
	$stmt->bind_param('ss', $search, $replace);
	$stmt->execute();

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