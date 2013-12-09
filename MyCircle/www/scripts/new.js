var pageUrl = window.location.href.toString(),
	data = {
		"id": localStorage.newId || sessionStorage.getItem("newId")
	},
	name = unescape(localStorage.newName) || sessionStorage.getItem("newName"),
	myScroll, navScroll;
	
// 公司简介
function setNewView (rs) {
	if (!rs.success) {
		app.toast(rs.message);
		return false;
	}
	var html = '<div id="new">' +
					'<h2 class="new-title">'+ rs.message.title +'</h2>' +
					'<div class="new-info">' +	
						'<span class="new-category">类别：'+ rs.message.category +'</span>' +
						'<span class="new-date">更新时间：'+ app.formatDate(rs.message.publishTime) +'</span>' +
					'</div>' +
					'<div id="newContent">'+ rs.message.content +'</div>' +
				'</div>';
				
	$("#scroller").html(html);
	myScroll.refresh();
}


// 初始化布局
function initLayout () {
	sessionStorage.setItem("newName", name);
	sessionStorage.setItem("newId", data.id);
	
	app.loadData(app.basePath+ "TcompanyNews/tcompanynews!showAjaxp.action", data, setNewView, app.toast, null);

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