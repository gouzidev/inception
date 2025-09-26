<?php
// tools/wp-config.php
/** The name of the database for WordPress */
define( 'DB_USER', getenv('WORDPRESS_USER_NAME'));
define( 'DB_NAME', getenv('WORDPRESS_DB_NAME'));
define( 'DB_PASSWORD', getenv('WORDPRESS_USER_PASSWORD'));
define( 'DB_HOST', getenv('WORDPRESS_DB_HOST'));
define( 'DB_CHARSET', 'utf8mb4' );
define( 'DB_COLLATE', '' );

/** WordPress unique keys and salts */
define('AUTH_KEY',         'your-unique-auth-key-here');
define('SECURE_AUTH_KEY',  'your-unique-secure-auth-key-here');
define('LOGGED_IN_KEY',    'your-unique-logged-in-key-here');
define('NONCE_KEY',        'your-unique-nonce-key-here');
define('AUTH_SALT',        'your-unique-auth-salt-here');
define('SECURE_AUTH_SALT', 'your-unique-secure-auth-salt-here');
define('LOGGED_IN_SALT',   'your-unique-logged-in-salt-here');
define('NONCE_SALT',       'your-unique-nonce-salt-here');

/** WordPress database table prefix */
$table_prefix = 'wp_';

/** WordPress debugging mode */
define( 'WP_DEBUG', false );

/* That's all, stop editing! */
if ( ! defined( 'ABSPATH' ) ) {
    define( 'ABSPATH', __DIR__ . '/' );
}

require_once ABSPATH . 'wp-settings.php';