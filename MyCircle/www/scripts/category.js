var myScroll,
	pageUrl = window.location.href.toString(),
	from = app.getParam(pageUrl, "from"),
	categoryUrl =  app.basePath + "TcompanyCategory/tcompanycategory!listAjaxp.action",
	categoryData = {
		"belongOrgId": app.getParam(pageUrl, "belongOrgId"),
		"categoryType": app.getParam(pageUrl, "categoryType"),
		"filter_LIKES_categoryName": app.getParam(pageUrl, "filter_LIKES_categoryName")
	};
	
function succHanlder(obj) {
	var html = '';
	
	$(obj.message).each(function () {
		html += '<li data-value="'+ this.id +'">' + this.categoryName+ '</li>'
	});
	
	$("#listContainer").html(html);
	myScroll.refresh();
}

function errHanlder(e) {
	app.toast("获取类别出错了");
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
	
	$("#listContainer li").live("click", function () {
		sessionStorage.setItem("searchCategoryName", $(this).html());
		sessionStorage.setItem("filter_EQS_category", $(this).data("value"));
		window.location.href = from;
		
		return false;
	});
	
	$(".hd h1").click(function () {
		sessionStorage.setItem("searchCategoryName", "");
		sessionStorage.setItem("filter_EQS_category", "");
		window.location.href = from;
		
		return false;
	});
}

$(function () { 
	initLayout();
	app.loadData(categoryUrl, categoryData, succHanlder, errHanlder);
});