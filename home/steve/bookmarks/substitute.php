<?php	

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
	
	$stmt = $mysqli->prepare("UPDATE bm_posts SET post_title = REPLACE(`post_title` ,?,?)");
	if ($stmt===false) {
		echo "Failed";
	}
	
	$search = "| ã‚ªã‚¹ã‚¹ãƒ¡æ–™é‡‘ãƒ—ãƒ©ãƒ³ | æ˜¥å¾—ã‚­ãƒ£ãƒ³ãƒšãƒ¼ãƒ³ | ãŠç”³ã—è¾¼ã¿ | ã‚¤ãƒ¼ãƒ»ãƒ¢ãƒã‚¤ãƒ«å…¬å¼ã‚¹ãƒˆã‚¢";
	$replace = "| オススメ料金プラン | 春得キャンペーン | お申し込み | イー・モバイル公式ストア"; 
	
	//$search = "A";
	//$replace = "B";
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
	
	echo "Finished";
	
?>
	