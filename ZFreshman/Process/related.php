<?php
    function myCompare($a, $b) {
        if ($a['distance'] > $b['distance']) {
            return 1;
        }
        else if ($a['distance'] == $b['distance']) {
            return 0;
        }
        return -1;
    }
	// 从 $pages 中找出与 $page 最相关的 $limit 篇文章
	// $pages 的成员 与 $page 是一样的字典数据， $page = array('file' => "...", 'tags' => "...")
	function get_related_pages($pages, $page, $limit = 5) {
        $dist = array();
		foreach ($pages as $value) {
			if ($value['file'] !== $page['file']) {    // 跳过自己
                $tag1 = $value['tags'];
                sort($tag1);
                $tag2 = $page['tags'];
                sort($tag2);
                $d = levenshtein(implode("", $tag1), implode("", $tag2));
                $dist[] = array("file" => $value['file'], 'distance' => $d);
			}
		}
        
        usort($dist, myCompare);
        $dist = array_slice($dist, 0, $limit);
        $files = array();
        foreach ($dist as $value) {
            $files[] = $value['file'];
        }
        return $files;
	}
?>