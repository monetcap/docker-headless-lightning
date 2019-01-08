if (file_exists('/environment/mysql.env')) {
    // Load environment
    $dotenv = Dotenv\Dotenv::create('/environment', 'mysql.env');
    $dotenv->load();
}

$config_directories[CONFIG_SYNC_DIRECTORY] = "../config";

$settings['trusted_host_patterns'] = array(
    '^example\.com$',
    '^.+\.example\.com$',
    '^127\.0\.0\.1$',
    '^localhost$',
);
