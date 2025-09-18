<?php

require __DIR__ . '/../vendor/autoload.php';

$folder = dirname(__DIR__, 1) . '/tmp';
$folder = realpath($folder);

$excludes = __DIR__ . '/tmp_cleaner_excludes.php';
if (is_file($excludes)) {
	$excludes = include $excludes;
}
$excludes = array_merge($excludes, [
	'.gitignore',
]);

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

	if ($created->diff($kuren)->m > 5 && $updated->diff($kuren)->m > 3) {
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
