if (file_exists('/tmp/mysql.env')) {
    // Load environment
    $dotenv = new \Dotenv\Dotenv('/tmp', 'mysql.env');
    $dotenv->load();
}

$config_directories[CONFIG_SYNC_DIRECTORY] = "../config";
