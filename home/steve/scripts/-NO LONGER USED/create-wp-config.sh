cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php 

cat << EOF > /tmp/wp-config.tmp
define('WP_DEBUG', false);

/**
 * CUSTOM CONFIGURATION OPTIONS
 * This code block added by invoking 'bash $0'
 */
 
    /** Enable Jetpack Development Mode */
    //define('JETPACK_DEV_DEBUG', true);

    // Define blog address and site address
    define('WP_HOME', 'http://www.dummy.com'); 	        // Source: http://digwp.com/2010/08/pimp-your-wp-config-php/
    define('WP_SITEURL', 'http://www.dummy.com');		 

    // Disable the theme and plugin editor
    define('DISALLOW_FILE_EDIT', true); 				// Source: http://wp.tutsplus.com/tutorials/security/imposing-ssl-and-other-tips-for-impenetrable-wp-security/

    // Increase post autosave to 5 minutes
    define('AUTOSAVE_INTERVAL', 300 );					// Source: http://wp.tutsplus.com/tutorials/security/imposing-ssl-and-other-tips-for-impenetrable-wp-security/

    // Disable the post-revisioning feature
    define('WP_POST_REVISIONS', false);					// Source: http://www.wpbeginner.com/wp-tutorials/how-to-disable-post-revisions-in-wordpress-and-reduce-database-size/
    
    // Disable custom HTML								// This also stops plugins from working that allow php to be run in a text widget e.g. wp-exec-php
    define('DISALLOW_UNFILTERED_HTML', true );			// Source: http://www.inkthemes.com/guide-to-secure-your-wordpress-like-a-security-professional/06/

/*
 * END: CUSTOM CONFIGURATION OPTIONS 
 **/
EOF

sed -e '/define('\''WP_DEBUG'\'', false);/ {' -e 'r /tmp/wp-config.tmp' -e 'd' -e'}' -i /tmp/wordpress/wp-config.php

cat /tmp/wordpress/wp-config.php
rm /tmp/wp-config.tmp