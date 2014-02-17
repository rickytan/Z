<?php
    define("ROOT", dirname(__FILE__));
    
	require_once "markdown_extended.php";
	
	require_once "tags.php";
    require_once "related.php";
	
	$config = array(
		"template"=>"Template/temp.html",	        // 模板文件
		"style"=>"Template/Style/Clearness.css"    // 样式文件
	);
	
	$template = @file_get_contents($config['template']);
	$style    = @file_get_contents($config['style']);
	
	$dir = ROOT. "/../Docs";
	$out_dir = ROOT. "/../HTML";
	
    echo "\nGenerate html file\n\n";
    
	$files = glob($dir. "/*.md");
    $file_tags = array();
	foreach ($files as $file) {
		echo "Processing file ". $file. "\n";
		$filename = pathinfo($file)['filename'];
		$markdown = @file_get_contents($file);
        //$content = MarkdownExtra::defaultTransform($markdown);
        $content = MarkdownExtended($markdown);
		$tags = get_tags_arr(strip_tags($content));		// 提取文章的关键词
		sort($tags);
		$tag_str = implode(",", $tags);
		
		$html = $template;
		$html = str_replace("{{title}}", $filename, $html);
		$html = str_replace("{{style}}", $style, $html);
		$html = str_replace("{{content}}", $content, $html);
		$html = str_replace("{{tags}}", $tag_str, $html);

        $htmlfile = $filename. ".html";
        $file_tags[] = array("file" => $htmlfile, "tags" => $tags);
		file_put_contents($out_dir. "/". $htmlfile, $html);
	}

    echo "\nGenerate related pages\n\n";
    
    foreach ($file_tags as $file_tag) {
        $filename = $file_tag['file'];
        $filepath = $out_dir. "/". $filename;
        echo "Processing file ". $filepath. "\n";
        echo "Tags:". implode(",", $file_tag['tags']). "\n";
        $related = get_related_pages($file_tags, $file_tag, 8);
        $related_html = "";
        foreach ($related as $value) {
            $related_html .= "<li><a href=./". $value. ">". pathinfo($value)['filename']. "</a></li>\n";
        }
        $html = @file_get_contents($filepath);
        $html = str_replace("{{related}}", $related_html, $html);
        file_put_contents($filepath, $html);
    }
    
	echo "\nDone!\n";
?>
