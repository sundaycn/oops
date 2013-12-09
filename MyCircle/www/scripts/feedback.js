var pageUrl = window.location.href.toString(),
	from = localStorage.feedbackFrom,
	data = {
		"tcompanyFeedback.belongOrgId": localStorage.iBelongOrgId || sessionStorage.getItem("belongOrgId"),
		"tcompanyFeedback.objectId": "",
		"tcompanyFeedback.feedbackType": "",
		"tcompanyFeedback.content": "",
		"tcompanyFeedback.name": "",
		"tcompanyFeedback.tel": "",
		"tcompanyFeedback.email": "",	
		"tcompanyFeedback.isPublic": "Y"
	},
	myScroll;
	
// 提交留言
function doFeedback (e) {
	
	data["tcompanyFeedback.content"] = $("#fb_content").val().trim();
	data["tcompanyFeedback.name"] = $("#fb_name").val().trim();
	data["tcompanyFeedback.tel"] = $("#fb_tel").val().trim();
	data["tcompanyFeedback.email"] = $("#fb_email").val().trim();
	data["tcompanyFeedback.isPublic"] = $("#fb_public input").val();
	
	if ($("#fb_content").val() == "") {
		app.toast("内容不能为空。");
		return;
	}
	if ($("#fb_tel").val() == "" && $("#fb_email").val() == "") {
		app.toast("电话或邮箱至少填写一项，以便我们回复您");
		return;
	}
	
	app.loadData(app.basePath + "TcompanyFeedback/tcompanyfeedback!saveAjaxp.action", data, function (rs) {
		if (rs.success) {
			app.toast("保存成功");
			window.location.href = from;
		}
	}, app.toast);
}

// 初始化布局
function initLayout () {
	if (from == "i.html") {
		$("header h1").html("我要留言");
		data["tcompanyFeedback.feedbackType"] = "01";
		data["tcompanyFeedback.objectId"] = localStorage.companyId || "";
	}
	
	if (from == "product.html") {
		$("header h1").html("产品评论");
		data["tcompanyFeedback.feedbackType"] = "02";
		data["tcompanyFeedback.objectId"] = localStorage.productId || "";
	}
	
	$(".back").attr("href", from);
	
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
	
	$('.mwui-switch-btn').each(function() {
		$(this).bind("click", function() {
			var btn = $(this).find("span");
			var change = btn.attr("change");
			btn.toggleClass('off');

			if(btn.attr("class") == 'off') {
				$(this).find("input").val("N");
					btn.attr("change", btn.html());
					btn.html(change);
				} else {
					$(this).find("input").val("Y");
					btn.attr("change", btn.html());
					btn.html(change);
				} 
			return false;
		});
	});
	$('.mwui-switch-btn').trigger("click");
	$(".btn").click(doFeedback);
});