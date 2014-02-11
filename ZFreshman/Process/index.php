<?php
header("Content-Type:text/html; charset=utf-8");
define('APP_ROOT', str_replace('\\', '/', dirname(__FILE__)));

$con = @file_get_contents("../Docs/求是潮.md");

function get_tags_arr($title)
    {
		require(APP_ROOT.'/pscws4.class.php');
        $pscws = new PSCWS4();
		$pscws->set_dict(APP_ROOT.'/scws/dict.utf8.xdb');
		$pscws->set_rule(APP_ROOT.'/scws/rules.utf8.ini');
		$pscws->set_ignore(true);
		$pscws->send_text($title);
		
		$words = $pscws->get_tops(10);
		$tags = array();
		foreach ($words as $val) {
		    $tags[] = $val['word'];
		}
		$pscws->close();
		return $tags;
}

var_dump(get_tags_arr($con));
