<?php

declare(strict_types=1);

use Psr\Container\ContainerInterface;
use Symfony\Component\Console\Application;

require __DIR__ . '/../vendor/autoload.php';

/** @var ContainerInterface $container */
$container = require __DIR__ . '/../config/container.php';

$cli = new Application('Console');

foreach ($container->get('config')['console']['commands'] as $command) {
    $cli->add($container->get($command));
}

$cli->run();