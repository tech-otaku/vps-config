<?php

$file = 'people.txt';
$current = '';
$return = array( 'email' => '' );
if( file_exists( $file ) ) {
    $current = file_get_contents($file);
}

if( isset( $_POST['email'] ) ) {
    if( !empty( $_POST['email'] ) ) {
        $return['email'] = $_POST['email'];
        if( filter_var( $_POST['email'], FILTER_VALIDATE_EMAIL ) !== false ) {
            // The new person to add to the file
            $current .= $_POST['email'] . "\n";

            $return['bytes_added'] = file_put_contents($file, $current, LOCK_EX);
        }
        else {
            $return['error'] = 'Invalid Email';
        }
    }
    else {
        $return['error'] = 'No Email Sent';
    }
}
else {
    $return['error'] = 'No Email Sent';
}

echo json_encode( $return );
