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


Traning = [];

node = document.querySelectorAll(".zjpy_04");
for (var i = 0; i < node.length; i++) {
	var div = node[i];
	var category = div.innerText.trim();
	var table = div.nextElementSibling;
	var links = table.querySelectorAll("td a");
	var majors = [];
	for (var j = 0; j < links.length; j++) {
		var a = links[j];
		var url = a.href;
		var name = a.innerText.trim();
		majors.push({"url":url,"name":name});
	}
	Traning.push({"category":category, "majors":majors});
}
