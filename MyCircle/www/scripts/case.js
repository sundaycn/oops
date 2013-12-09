var pageUrl = window.location.href.toString(),
	data = {
		"id": localStorage.caseId || sessionStorage.getItem("caseId")
	},
	name = unescape(localStorage.caseName) || sessionStorage.getItem("caseName"),
	myScroll, navScroll;
	
// 案例
function setCaseView (rs) {
	if (!rs.success) {
		app.toast(rs.message);
		return false;
	}
				
	var html = '<div id="case" style="padding-bottom:300px;">' +
				'<h2 class="case-title">'+ rs.message.name +'</h2>' +
				'<div class="case-info">' +
					'<span class="case-category">类别：'+ rs.message.category +'</span>' +
					'<span class="case-date">更新时间：'+ app.formatDate(rs.message.publishTime) +'</span>' +
				'</div>' +
				'<div class="case-img" style="text-align:center">' +
					(rs.message.image == "undefined" ? "" : '<img  src="'+ app.basePath + rs.message.image +'">') + 
				'</div>' +
				'<h3 class="case-subtitle">产品简介：</h3>'+ 
				'<div id="caseContent">'+ (rs.message.intraduct || "") +'</div>' +
				'<br/><h3 class="case-subtitle">产品详情：</h3>'+ 
				'<div id="caseContent">'+ (rs.message.details || "") +'</div>' +
			'</div>';

	$("#scroller").html(html);
	myScroll.refresh();
}


// 初始化布局
function initLayout () {
	sessionStorage.setItem("caseName", name);
	sessionStorage.setItem("caseId", data.id);
	
	app.loadData(app.basePath+ "TcompanyExample/tcompanyexample!showAjaxp.action", data, setCaseView, app.toast, null);

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
}

$(function () {
	initLayout();
});