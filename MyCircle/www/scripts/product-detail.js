var pageUrl = window.location.href.toString(),
	data = {
		"companyId": localStorage.companyId || sessionStorage.getItem("companyId"),
		"id": localStorage.productId || sessionStorage.getItem("productId")
	},
	name = unescape(localStorage.productName) || sessionStorage.getItem("productName"),
	title = unescape(localStorage.productDetailTitle) || sessionStorage.getItem("productDetailTitle"),
	path = app.basePath + (localStorage.productDetailPath || sessionStorage.getItem("productDetailPath")),
	myScroll;
	
// 产品介绍
function setProductDetailView (rs) {
	if (!rs.success) {
		app.toast(rs.message);
		return false;
	}

	$("#productDetail").html(rs.message.prodAttrs || rs.message.details);
	myScroll.refresh();
}

// 初始化布局
function initLayout () {
	if (name) {
		$("header h1").html(app.cutstr(title, 9));
	}
	
	sessionStorage.setItem("companyId", data.companyId);
	sessionStorage.setItem("productName", name);
	sessionStorage.setItem("productId", data.id);

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

	app.loadData(path, data, setProductDetailView, app.toast);
}

$(function () {
	initLayout();
	localStorage.iFrom = "product.html";
});