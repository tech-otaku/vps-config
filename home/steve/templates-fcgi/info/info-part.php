<?php
	$exclude = array("HTTP_AUTHORIZATION","PHP_AUTH_USER", "PHP_AUTH_PW", "REMOTE_USER");
	foreach ( $_SERVER as $key=>$value ) {
		if ( ! in_array($key, $exclude)) {
			print "\$_SERVER[\"$key\"] == $value<br/>";
		}
	}
?>
