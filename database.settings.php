if (file_exists('/tmp/mysql.env')) {
    // Load environment
    $dotenv = new \Dotenv\Dotenv('/tmp', 'mysql.env');
    $dotenv->load();
}

$databases['default']['default'] = array (
    'database' =>  getenv('MYSQL_DATABASE'),
    'username' => getenv('MYSQL_USER'),
    'password' => getenv('MYSQL_PASSWORD'),
    'prefix' => '',
    'host' => getenv('MYSQL_HOST'),
    'port' => getenv('MYSQL_PORT'),
    'namespace' => 'Drupal\\Core\\Database\\Driver\\mysql',
    'driver' => 'mysql',
);
