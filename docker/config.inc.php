<?php

declare(strict_types=1);

$cfg['blowfish_secret'] = getenv('RANDOM_STRING');
$cfg['SendErrorReports'] = 'ask';

$cfg['UploadDir'] = './tmp/';
$cfg['TempDir'] = './tmp/';
$cfg['SaveDir'] = './tmp/';

$cfg['UserprefsDeveloperTab'] = true;
$cfg['PersistentConnections'] = true;
$i = 0;

$cfg['MysqlSslWarningSafeHosts'] = [];

$mariaDbVariants = [
    '10.5' => 'mariadb-105.phpmyadmin.local',
    '10.4' => 'mariadb-104.phpmyadmin.local',
    '10.3' => 'mariadb-103.phpmyadmin.local',
    '10.2' => 'mariadb-102.phpmyadmin.local',
    '10.1' => 'mariadb-101.phpmyadmin.local',
];

// MariaDB servers
foreach ($mariaDbVariants as $version => $hostname) {
    $i++;
    $cfg['Servers'][$i]['verbose'] = 'MariaDB ' . $version . ' (cookie)';
    $cfg['Servers'][$i]['auth_type'] = 'cookie';
    $cfg['Servers'][$i]['host'] = $hostname;
    $cfg['MysqlSslWarningSafeHosts'][] = $hostname;
    $cfg['Servers'][$i]['compress'] = true;
    $cfg['Servers'][$i]['AllowNoPassword'] = true;
}

// Config auths
foreach ($mariaDbVariants as $version => $hostname) {
    $i++;
    $cfg['Servers'][$i]['verbose'] = 'MariaDB ' . $version . ' (config) user: public';
    $cfg['Servers'][$i]['auth_type'] = 'config';
    $cfg['Servers'][$i]['host'] = $hostname;
    $cfg['Servers'][$i]['compress'] = true;
    $cfg['Servers'][$i]['user'] = 'public';
    $cfg['Servers'][$i]['password'] = 'public';
    $cfg['Servers'][$i]['AllowNoPassword'] = true;
}

$mysqlDbVariants = [
    '8.0' => 'mysql-8.0.phpmyadmin.local',
    '5.7' => 'mysql-5.7.phpmyadmin.local',
    '5.5' => 'mysql-5.5.phpmyadmin.local',
];

// MySQL servers
foreach ($mysqlDbVariants as $version => $hostname) {
    $i++;
    $cfg['Servers'][$i]['verbose'] = 'MySQL ' . $version . ' (cookie)';
    $cfg['Servers'][$i]['auth_type'] = 'cookie';
    $cfg['Servers'][$i]['host'] = $hostname;
    $cfg['MysqlSslWarningSafeHosts'][] = $hostname;
    $cfg['Servers'][$i]['compress'] = true;
    $cfg['Servers'][$i]['AllowNoPassword'] = true;
}

// Config auths
foreach ($mysqlDbVariants as $version => $hostname) {
    $i++;
    $cfg['Servers'][$i]['verbose'] = 'MySQL ' . $version . ' (config) user: public';
    $cfg['Servers'][$i]['auth_type'] = 'config';
    $cfg['Servers'][$i]['host'] = $hostname;
    $cfg['Servers'][$i]['compress'] = true;
    $cfg['Servers'][$i]['user'] = 'public';
    $cfg['Servers'][$i]['password'] = 'public';
    $cfg['Servers'][$i]['AllowNoPassword'] = true;
}

$perconaDbVariants = [
    '8.0' => 'percona-8.0.phpmyadmin.local',
    '5.7' => 'percona-5.7.phpmyadmin.local',
    '5.5' => 'percona-5.5.phpmyadmin.local',
];

// PerconaDB servers
foreach ($perconaDbVariants as $version => $hostname) {
    $i++;
    $cfg['Servers'][$i]['verbose'] = 'Percona ' . $version . ' (cookie)';
    $cfg['Servers'][$i]['auth_type'] = 'cookie';
    $cfg['Servers'][$i]['host'] = $hostname;
    $cfg['MysqlSslWarningSafeHosts'][] = $hostname;
    $cfg['Servers'][$i]['compress'] = true;
    $cfg['Servers'][$i]['AllowNoPassword'] = true;
}

// Config auths
foreach ($perconaDbVariants as $version => $hostname) {
    $i++;
    $cfg['Servers'][$i]['verbose'] = 'Percona ' . $version . ' (config) user: public';
    $cfg['Servers'][$i]['auth_type'] = 'config';
    $cfg['Servers'][$i]['host'] = $hostname;
    $cfg['Servers'][$i]['compress'] = true;
    $cfg['Servers'][$i]['user'] = 'public';
    $cfg['Servers'][$i]['password'] = 'public';
    $cfg['Servers'][$i]['AllowNoPassword'] = true;
}
