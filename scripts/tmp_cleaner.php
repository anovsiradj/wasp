<?php

require __DIR__ . '/../vendor/autoload.php';

$config = require __DIR__ . '/tmp_cleaner_config.php';
// dd($config);

$folder = dirname(__DIR__, 1) . '/tmp';
$folder = realpath($folder);

$excludes = $config['excludes'] ?? [];
$excludes = array_merge($excludes, [
	'.gitignore',
]);
// dd($excludes);

$iter = new DirectoryIterator($folder);
foreach ($iter as $item) {
	/** @var DirectoryIterator $item */

	if ($item->isDir() || $item->isDot()) {
		continue;
	}

	$name = $item->getFilename();
	$path = $item->getPathname();
	if (in_array($name, $excludes) || in_array($path, $excludes)) {
		continue;
	}

	$created = $item->getCTime();
	$updated = $item->getMTime();
	if (empty($created) || empty($updated)) {
		continue;
	}

	$kuren = new DateTime;
	$created = DateTime::createFromTimestamp($created);
	$updated = DateTime::createFromTimestamp($updated);

	if (
		$created->diff($kuren)->m > $config['created_month_at'] &&
		$updated->diff($kuren)->m > $config['updated_month_at']
	) {
		$status = null;
		if ($item->isWritable()) {
			unlink($path);

			$status = 'DONE';
		} else {
			$status = 'FAIL';
		}

		printf('[%s] %s', $status, $path);
	}
}
