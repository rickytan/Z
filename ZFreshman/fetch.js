Leagues = [];

$("#artph>li").each(function(i,v) {
	var a = $(v).find("a").first()[0];
	var url = a.href;
	var title = a.title;
	var item = {"name": title, "description": "", "instructor": "", "logo": ""};
	console.log("Get :"+url);
	$.get(url, function(data) {
		var description = $(data).find("div.cat-box1 div.con").text();
		var instructor = $(data).find("div.cat-box2 div.con").text().trim();
		item.description = description;
		item.instructor = instructor;
		Leagues.push(item);
		console.log("Done! "+url);
	});
});