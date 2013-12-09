var myScroll,
	prourl = app.basePath + "TcompanyInfo/tcompanyinfo!queryProvinceAjaxp.action",
	cityurl = app.basePath + "TcompanyInfo/tcompanyinfo!queryCityAjaxp.action",
	countyurl = app.basePath + "TcompanyInfo/tcompanyinfo!queryCountyAjaxp.action",
	data = {
		"provinceId": "",
		"cityId":''
	};
	
function succHanlder(obj, level) {
	var html = '';
	$(obj.message).each(function () {
		if(this.hasChild == "true") {
			html += '<li onclick="queryBy(\''+this.id+'\', \''+ (parseInt(level) + 1) +'\')">'+this.name+'</li>'
		} else {
			html += '<li onclick="select(\''+this.id+'\', \''+this.name+'\', \''+ level +'\')">'+this.name+'</li>'
		}
	});
	
	$("#listContainer").html(html);
	myScroll.refresh();
}
	
function errHanlder(e){
	app.toast("获取区域出错啦");
}

// level为省市县的深度，省为0，市为1，县为2。。。
function queryBy(id, level) {
	var path;
	switch (parseInt(level)) {
		case 0: 
			path = prourl;
			break;
			
		case 1: 
			data["provinceId"] = id;
			path = cityurl;
			break;
			
		case 2: 
			data["cityId"] = id;
			path = countyurl;
			break;
			
		default:
			path = prourl;
			break;
	}
	console.log(level)
	console.log(path)
	console.log(level)
	app.loadData(path, data, succHanlder, errHanlder, level);
	
	return false;
}

// level为省市县的深度，省为0，市为1，县为2。。。
function select (id, name, level) {
	var areaLevel = level, areaName = name, areaId = id; 
	switch (parseInt(level)) {
		case 0: 
			sessionStorage.setItem("filter_EQS_provinceId", areaId);
			break;
			
		case 1: 
			sessionStorage.setItem("filter_EQS_cityId", areaId);
			break;
			
		case 2: 
			sessionStorage.setItem("filter_EQS_countyId", areaId);
			break;
			
		default:
			break;
	}
	
	sessionStorage.setItem("areaName", areaName);
	//sessionStorage.setItem("areaId", areaId);
	
	window.location.href="index.html";
}

function initLayout () {
	myScroll = new IScroll('#wrapper', {
		useTransition: true,
		scrollbars: true,
		mouseWheel: true,
		click: false,
		interactiveScrollbars: true,
		topOffset : pullDownOffset,
		probeType: 3, 
		mouseWheel: true
	});
	
	$(".hd h1").click(function () {
		sessionStorage.setItem("areaName", "");
		sessionStorage.setItem("areaId", "");
		window.location.href="index.html";
		
		return false;
	});
	
	sessionStorage.setItem("filter_EQS_provinceId", "");
	sessionStorage.setItem("filter_EQS_cityId", "");
	sessionStorage.setItem("filter_EQS_countyId", "");
	sessionStorage.setItem("areaName", "");
	sessionStorage.setItem("areaId", "");
}

$(function () { 
	initLayout();
	app.loadData(prourl, data, succHanlder, errHanlder, 0);
});