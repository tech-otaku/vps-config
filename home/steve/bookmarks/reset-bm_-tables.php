<?php
	
	try {
		$dbh = new PDO('mysql:host=localhost;dbname=bookmarks;charset=UTF8', 'root', 'Bslippy5');
	} catch (PDOException $e) {
    	echo 'Connection failed: ' . $e->getMessage();
	}
	
	// RESET TABLES
	$sth = $dbh->prepare('DROP TABLE bm_postmeta');
	$sth->execute();
	
	$sql = file_get_contents('./db-backups/bm_postmeta.sql');
	$dbh->exec($sql);
	
	
	$sth = $dbh->prepare('DROP TABLE bm_posts');
	$sth->execute();
	
	$sql = file_get_contents('./db-backups/bm_posts.sql');
	$dbh->exec($sql);
	
	
	$sth = $dbh->prepare('DROP TABLE bm_term_relationships');
	$sth->execute();
	
	$sql = file_get_contents('./db-backups/bm_term_relationships.sql');
	$dbh->exec($sql);
	
	
	$sth = $dbh->prepare('DROP TABLE bm_term_taxonomy');
	$sth->execute();
	
	$sql = file_get_contents('./db-backups/bm_term_taxonomy.sql');
	$dbh->exec($sql);
	
	
	$sth = $dbh->prepare('DROP TABLE bm_termmeta');
	$sth->execute();
	
	$sql = file_get_contents('./db-backups/bm_termmeta.sql');
	$dbh->exec($sql);
	
	
	$sth = $dbh->prepare('DROP TABLE bm_terms');
	$sth->execute();
	
	$sql = file_get_contents('./db-backups/bm_terms.sql');
	$dbh->exec($sql);
		
?>