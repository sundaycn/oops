var myScroll,
	pageUrl = window.location.href.toString(),
	from = app.getParam(pageUrl, "from"),
	attrurl =  app.basePath + "TsysAttrSpec/tsysattrspec!getStaticAttrAjaxp.action",
	attrdata = {
		"attrCode":'ATTR_COMPANY_TYPE',
		"dynamic":'false'
	};
	
function attrSuccHanlder(obj) {
	var html = '';
	
	$(obj.message).each(function () {
		html += '<li data-value="'+ this.attrValue +'">' + this.attrValueName+ '</li>'
	});
	
	$("#listContainer").html(html);
	myScroll.refresh();
}

function attrErrHanlder(e) {
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
		sessionStorage.setItem("searchAttrName", $(this).html());
		sessionStorage.setItem("filter_EQS_companyType", $(this).data("value"));
		window.location.href = from;
		
		return false;
	});
	
	$(".hd h1").click(function () {
		sessionStorage.setItem("searchAttrName", "");
		sessionStorage.setItem("filter_EQS_companyType", "");
		window.location.href = from;
		
		return false;
	});
}

$(function () { 
	initLayout();
	app.loadData(attrurl, attrdata, attrSuccHanlder, attrErrHanlder);//获取通用属性
});