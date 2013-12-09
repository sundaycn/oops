var pageUrl = window.location.href.toString(),
	from = app.getParam(pageUrl, "from") || localStorage.iFrom,
	data = {
		"id": app.getParam(pageUrl, "id") || localStorage.iId || sessionStorage.getItem("id"), 
		"companyId":  app.getParam(pageUrl, "id") || localStorage.iId || sessionStorage.getItem("id"), 
		"belongOrgId": app.getParam(pageUrl, "belongOrgId") || localStorage.iBelongOrgId || sessionStorage.getItem("belongOrgId")
	},
	name = app.getParam(pageUrl, "name") || localStorage.iName,
	myScroll, navScroll,
	modules = {
		"MOD_COMPANY_INFO": {// 简介
			"api": app.basePath + "TcompanyInfo/tcompanyinfo!showAjaxp.action",
			"params": data,
			"callback": setCompanyInfoView
		},
		
		"MOD_COMPANY_NEWS": {//动态
			"api": app.basePath + "TcompanyNews/tcompanynews!listAjaxp.action",
			"params": {
				"belongOrgId":data.belongOrgId,
				"page.pageNo": 1,
				"page.pageSize": 10,
				"filter_LIKES_title": "",
				"filter_EQS_category": "",
				"filter_GED_publishTime&LTD_publishTime": ""
			},
			"callback": setNewsView,
			"page": {
				totalPages: 0,
				totalCount: 0,
				hasNextPage: true
			}
		},
		
		"MOD_COMPANY_PRODUCT": {// 服务
			"api": app.basePath + "TcompanyProduct/tcompanyproduct!listAjaxp.action",
			"params": {
				"belongOrgId":data.belongOrgId,
				"page.pageNo": 1,
				"page.pageSize": 10,
				"filter_LIKES_name": "",
				"filter_EQS_category": sessionStorage.getItem("filter_EQS_category") || ""
			},
			"callback": setCompanyProductView,
			"page": {
				totalPages: 0,
				totalCount: 0,
				hasNextPage: true
			}
		},
		
		"MOD_COMPANY_EXAMPLE": { // 公司案例
			"api": app.basePath + "TcompanyExample/tcompanyexample!listAjaxp.action",
			"params": {
				"belongOrgId":data.belongOrgId,
				"page.pageNo": 1,
				"page.pageSize": 10,
				"filter_LIKES_name": "",
				"filter_EQS_category": ""
			},
			"callback": setCaseView,
			"page": {
				totalPages: 0,
				totalCount: 0,
				hasNextPage: true
			}
		},
		
		"MOD_COMPANY_FEEDBACK": { // 公司留言
			"api": app.basePath + "TcompanyFeedback/tcompanyfeedback!listAjaxp.action",
			"params": {
				"belongOrgId":data.belongOrgId,
				"page.pageNo": 1,
				"page.pageSize": 10,
				"objectId": data.companyId,
				"feedbackType": "01"
			},
			"callback": setFeedbackView,
			"page": {
				totalPages: 0,
				totalCount: 0,
				hasNextPage: true
			}
		}
		
		
	};
	
// 公司简介
function setCompanyInfoView (rs) {
	if (!rs.success) {
		app.toast(rs.message);
		return false;
	}
	var html = '<div class="bit module" >'+
					'<div class="bit_name">'+
						'<a><img src="'+app.checkimg(rs.message.image)+'"/></a>'+
						'<p style="margin-left:10px;">'+
							'<span class="title">'+ rs.message.name +'</span>'+
							'<span class="developer">门户类型：'+ (rs.message.category || "") +'</span>'+
							//'<span class="leixin">经营模式：'+ (rs.message.companyMode || "") +'</span>'+
						'</p>'+
					'</div>'+
					'<ul class="bit_bd">'+
						'<li style="height:auto;"><span>业务范围：</span>'+ (rs.message.companyScope || "") +'</li>'+
						'<li><span>所在地：</span>'+ (rs.message.province || "") +" "+ (rs.message.city || "") +" "+ (rs.message.county || "") +'</li>'+
						'</a></li>'+
					'</ul>'+
					'<ul class="bit_lx bit_mm">'+
						'<li>联系电话：'+ (rs.message.officePhone || "") +
							'<a href="tel:'+ (rs.message.officePhone || "") +'" id="tel" style="display:'+ ((rs.message.officePhone == "undefined") ? "none" : "block") +'"></a>'+
						'</li>'+
						'<li>手机号码：'+ (rs.message.mobile || "") +
							'<a href="sms:'+ (rs.message.mobile || "") +'" id="msg" style="display:'+ ((rs.message.mobile == "undefined") ? "none" : "block") +'"></a>'+
							'<a href="tel:'+ (rs.message.mobile || "") +'" id="tel" style="display:'+ ((rs.message.mobile == "undefined") ? "none" : "block") +'"></a>'+
						'</li>'+
						'<li>传真号码：'+ (rs.message.faxNumber || "") +'</li>'+
						'<li>电子邮箱：'+ (rs.message.email || "") +'</li>'+
						'<li>联系地址：'+ (rs.message.officeAddress || "") +'</li>'+
						'<li>邮政编码：'+ (rs.message.zipCode || "") +'</li>'+
						'<li>网址：<a target="_blank" href="'+ (rs.message.website || "#") +'">'+ (rs.message.website || "") +'</a></li>'+
					'</ul>'+
					'<article class="bit_mm">'+
						'<h1>简介</h1>'+
						'<p>'+ (rs.message.introduce || "") +'</p>'+
					'</article >'+
					'<article class="bit_mm">'+
						'<h1>更多</h1>'+
						'<p>'+ (rs.message.expAttrs || "") +'</p>'+
					'</article >'+
				'</div>';
				
	$("header h1").html(app.cutstr(rs.message.name, 9));
	$("#listContainer").html(html);
	$("#productSearchForm").hide();

	myScroll.refresh();
	if (myScroll) {
		myScroll.scrollTo(0, 0);
	}
}

// 公司动态
function setNewsView (rs, args) {
	if (typeof args != "object") return false;
	$("#productSearchForm").hide();
	
	var module = args.module,
		isPullDown = args.isPullDown;
	
	module.page.totalPages = rs.message.totalPages;
	module.page.totalCount = rs.message.totalCount;
	
	// totalPages总页数只有一页，不显示“上拉加载”
	if (module.page.totalPages == 1 || !module.page.hasNextPage) {
		$('#pullUp').hide();
	}
	
	// 返回的页码小于请求参数里的页码值时，说明没有下一页了，隐藏“上拉加载”，并跳出
	if (rs.message.pageNo < module.params['page.pageNo']) {
		$('#pullUp').hide();
		module.page.hasNextPage = false;
		return;
	} else {
		$('#pullUp').show();
		module.page.hasNextPage = true;
	}
	
	if ($(rs.message.result).size() < rs.message.pageSize) {
		$('#pullUp').hide();
		module.page.hasNextPage = false;
	}
	
	var html = '';
	$(rs.message.result).each(function () {
		html += '<li onclick="showNew(\''+ this.id +'\', \''+ escape(this.name) +'\')">' + 
					'<p style="width:auto;">' +
						'<span class="title">'+app.cutstr(app.checkstr(this.title), 13)+'</span>' +
						'<span class="category">资讯类型：'+app.cutstr(app.checkstr(this.category), 13)+'</span>' +
						'<span class="date">发布时间：'+app.cutstr(app.formatDate(this.publishTime))+'</span>' +
					'</p>' +
					'<div class="list_arrow"></div>'+
				'</li>'
	});
	
	if (html == "") {
		html = '<li class="null-data" style="text-align:center">没有搜到匹配的数据。</li>';
	}
	
	if (isPullDown) { // 下拉刷新
		$("#listContainer").html(html);
		$("#pullDown").hide();
	} else { // 上拉加载更多
		$("#listContainer").append(html);
		myScroll.scrollTo(0, myScroll.maxScrollY - 10, 0, false);
	}
	
	$("#listContainer").html(html);
	myScroll.refresh();
	if (myScroll) {
		myScroll.scrollTo(0, 0);
	}
}

function showNew (id, name) {
	localStorage.newId = id;
	localStorage.newName = name;
	window.location.href = "new.html";
}

// 公司产品
function setCompanyProductView (rs, args) {
	if (typeof args != "object") return false;
	$("#productSearchForm").hide();
	
	var module = args.module,
		isPullDown = args.isPullDown;
	
	module.page.totalPages = rs.message.totalPages;
	module.page.totalCount = rs.message.totalCount;
	
	// totalPages总页数只有一页，不显示“上拉加载”
	if (module.page.totalPages == 1 || !module.page.hasNextPage) {
		$('#pullUp').hide();
	}
	
	// 返回的页码小于请求参数里的页码值时，说明没有下一页了，隐藏“上拉加载”，并跳出
	if (rs.message.pageNo < module.params['page.pageNo']) {
		$('#pullUp').hide();
		module.page.hasNextPage = false;
		return;
	} else {
		$('#pullUp').show();
		module.page.hasNextPage = true;
	}
	
	if ($(rs.message.result).size() < rs.message.pageSize) {
		$('#pullUp').hide();
		module.page.hasNextPage = false;
	}
	
	var html = '';
	$(rs.message.result).each(function () {
		html += '<li onclick="showProduct(\''+ this.id +'\', \''+ escape(this.name) +'\')">' + 
					'<a><img src="'+app.checkimg(this.image1)+'"/></a>' +
					'<p>' +
						'<span class="title">'+app.cutstr(app.checkstr(this.name), 9)+'</span>' +
						'<span class="category">类别：'+app.cutstr(app.checkstr(this.category), 13)+'</span>' +
						'<span class="date">时间：'+app.cutstr(app.formatDate(this.publishTime))+'</span>' +
					'</p>' +
					'<div class="list_arrow"></div>'+
				'</li>'
	});
	
	if (html == "") {
		html = '<li class="null-data" style="text-align:center">没有搜到匹配的数据。</li>';
	}
	
	if (isPullDown) { // 下拉刷新
		$("#listContainer").html(html);
		$("#pullDown").hide();
	} else { // 上拉加载更多
		$("#listContainer").append(html);
		myScroll.scrollTo(0, myScroll.maxScrollY - 10, 0, false);
	}
	
	$("#listContainer").html(html);
	myScroll.refresh();
	
	// 设置类别链接和名称
	$("#productSearchForm #searchCategory").attr(
		"href",
		"category.html?from=i.html&categoryType=02&belongOrgId="+data.belongOrgId
	);
	$("#productSearchForm #searchCategory").html(sessionStorage.getItem("searchCategoryName") || "全部类别");
	
	// 绑定搜索按钮事件
	$("#productSearchForm #searchButton").unbind();
	$("#productSearchForm #searchButton").click(function () {
		module.params["filter_LIKES_name"] = $("#productSearchForm #searchKeywords").val();
		app.loadData(module.api, (module.params || data), module.callback, app.toast, module);
	});
	
	localStorage.setItem("productNavIndex", 0);
	
	if (myScroll) {
		myScroll.scrollTo(0, 0);
	}
}

// 公司案例
function setCaseView (rs, args) {
	if (typeof args != "object") return false;
	$("#productSearchForm").hide();
	
	var module = args.module,
		isPullDown = args.isPullDown;
	
	module.page.totalPages = rs.message.totalPages;
	module.page.totalCount = rs.message.totalCount;
	
	// totalPages总页数只有一页，不显示“上拉加载”
	if (module.page.totalPages == 1 || !module.page.hasNextPage) {
		$('#pullUp').hide();
	}
	
	// 返回的页码小于请求参数里的页码值时，说明没有下一页了，隐藏“上拉加载”，并跳出
	if (rs.message.pageNo < module.params['page.pageNo']) {
		$('#pullUp').hide();
		module.page.hasNextPage = false;
		return;
	} else {
		$('#pullUp').show();
		module.page.hasNextPage = true;
	}
	
	if ($(rs.message.result).size() < rs.message.pageSize) {
		$('#pullUp').hide();
		module.page.hasNextPage = false;
	}
	
	var html = '';
	$(rs.message.result).each(function () {
		html += '<li onclick="showCase(\''+ this.id +'\', \''+ escape(this.name) +'\')">' + 
					'<a><img src="'+app.checkimg(this.image)+'"/></a>' +
					'<p>' +
						'<span class="title">'+app.cutstr(app.checkstr(this.name), 10)+'</span>' +
						'<span class="category">案例类型：'+app.cutstr(app.checkstr(this.category), 13)+'</span>' +
					'</p>' +
					'<div class="list_arrow"></div>'+
				'</li>'
	});
	
	if (html == "") {
		html = '<li class="null-data" style="text-align:center">没有搜到匹配的数据。</li>';
	}
	
	if (isPullDown) { // 下拉刷新
		$("#listContainer").html(html);
		$("#pullDown").hide();
	} else { // 上拉加载更多
		$("#listContainer").append(html);
		myScroll.scrollTo(0, myScroll.maxScrollY - 10, 0, false);
	}
	
	$("#listContainer").html(html);
	myScroll.refresh();
	
	if (myScroll) {
		myScroll.scrollTo(0, 0);
	}
}

function showCase (id, name) {
	localStorage.caseId = id;
	localStorage.caseName = name;
	window.location.href = "case.html";
}

// 公司留言
function setFeedbackView (rs, args) {
	if (typeof args != "object") return false;
	$("#productSearchForm").hide();
	
	var module = args.module,
		isPullDown = args.isPullDown;
	
	module.page.totalPages = rs.message.totalPages;
	module.page.totalCount = rs.message.totalCount;
	
	// totalPages总页数只有一页，不显示“上拉加载”
	if (module.page.totalPages == 1 || !module.page.hasNextPage) {
		$('#pullUp').hide();
	}
	
	// 返回的页码小于请求参数里的页码值时，说明没有下一页了，隐藏“上拉加载”，并跳出
	if (rs.message.pageNo < module.params['page.pageNo']) {
		$('#pullUp').hide();
		module.page.hasNextPage = false;
		return;
	} else {
		//$('#pullUp').show();
		module.page.hasNextPage = true;
	}
	
	var html = "", listhtml = '', listReplyHtml = '',
		button = '<p class="btn-group"><a href="javascript:void(0)" class="btn ">我要评论</a></p>';
	$(rs.message.result).each(function () {
		
		listhtml += '<li>'+
						'<div class="ly_name">'+
							'<span>'+ (this.name || "匿名") +' 说:</span>'+
							'<span>'+ app.formatDate(this.feedbackTime) +'</span>'+
							'<div style="font-size:16px;color:#666;line-height:24px;">'+this.content+ '</div>'+
						'</div>';
		
		if (this.replys.length > 0) {
			listReplyHtml = '<div class="ly_hf">'+
								'<div class="f_ang_t">'+
									'<div class="ang_i ang_t_d bor2"></div>'+
									'<div class="ang_i ang_t_u bor_bg"></div>'+
								'</div>'+
								'<ul class="ly_li2">';
								
			$(this.replys).each(function () {
				listReplyHtml += '<li>'+ this.content +'</li>';
				
			});
			
			listReplyHtml += '</ul></div>';

			listhtml += listReplyHtml;
			
		}
		
		listhtml += '</li>';
	});
	
	if (listhtml == "") {
		$('#pullDown').hide();
		$('#pullUp').hide();
		listhtml = '<li class="null-data" style="text-align:center">暂时没有评论。</li>';
	}
	
	if (rs.message.pageNo == 1) {
		html = '<div class="ly_new time">'+
					'<h2>最新留言<span>('+ (rs.message.totalCount || 0) +')</span></h2>'+
					button +
					listhtml + 
				'</div>';
	} else {
		html = listhtml;
	}
			
	if (isPullDown) { // 下拉刷新
		$("#listContainer").html(html);
		$("#pullDown").hide();
	} else { // 上拉加载更多
		$("#listContainer .ly_new").append(html);
		myScroll.scrollTo(0, myScroll.maxScrollY - 10, 0, false);
	}
	
	$("#listContainer").find(".btn").click(function () {
		localStorage.feedbackFrom = "i.html";
		localStorage.belongOrgId = data.companyId;
		localStorage.companyId = data.id;
		window.location.href = "feedback.html";
	});
	myScroll.refresh();
	
	if (myScroll) {
		myScroll.scrollTo(0, 0);
	}
}

function showProduct (id, name) {
	localStorage.companyId = data.companyId;
	localStorage.productId = id;
	localStorage.productName = name;
	window.location.href = "./product.html";
	return false;
}

// 导航事件处理
function navClickHandler (e) {
	var moduleCode = $(this).data("modulecode"),
		module = modules[moduleCode];
	
	$("#listContainer").html("");
	// 模块不存在，内容显示为空
	if (!module) {
		$("#listContainer").html("");
		$("#listContainer").siblings().hide();
		myScroll.refresh();
	}
	
	// 模块存在，没有翻页
	if (module && !module.page) {
		app.loadData(module.api, (module.params || data), module.callback, app.toast, module);
		
		myScroll._events = {};
		/*
		// 刷新布局
		myScroll.on("refresh", function () {
			$('#pullDown').hide();
			$('#pullUp').hide();
		});
		console.log(myScroll)
		// 绑定拖动事件
		myScroll.on("scrollMove", function () {console.log("move")});
		myScroll.on("scrollEnd", function () {});
		*/
	}
	
	// 模块存在，存在翻页
	if (module && module.page) {
		var args = {
			module: module,
			isPullDown: true
		}
		app.loadData(module.api, (module.params || data), module.callback, app.toast, args);
		// 刷新布局
		myScroll.on("refresh", function () {
			$('#pullDown').find(".pullDownLabel").html("下拉刷新");
			$('#pullUp').find(".pullUpLabel").html("上拉显示下一页");
		});
		
		// 绑定拖动事件
		myScroll.on("scrollMove", function () {
			if (this.y > 0) {
				$("#pullDown").show();
				$("#pullDown").addClass("loading");
				$('#pullDown').find(".pullDownLabel").html("松开刷新");
			}
		})

		myScroll.on("scrollEnd", function () {
			if (this.y == 0) { // 执行下拉刷新
				module.params['page.pageNo'] = 1;
				args.isPullDown = true;
				app.loadData(module.api, (module.params || data), module.callback, app.toast, args);
			}
			
			// 滑到了底部
			if (this.y == this.maxScrollY) {
				// 总页数大于1，且存在下一页，执行上拉加载
				if (module.page.totalPages > 1 && module.page.hasNextPage) {
					module.params['page.pageNo'] = module.params['page.pageNo'] + 1;
					args.isPullDown = false;
					app.loadData(module.api, (module.params || data), module.callback, app.toast, args);
				} else {
					$("#pullUp").hide();
					app.toast("没有下页了");
				}
			}
		});
	}
	
	var navIndex = $("#nav li").index($(this)),
		el = document.querySelector('#nav li:nth-child('+ (navIndex) +')');
	
	$(this).siblings("li").removeClass("current");
	$(this).addClass("current");
	localStorage.setItem("navIndex", navIndex);
	localStorage.setItem("iFrom", "");
	navScroll.scrollToElement(el, 500);
}

// 初始化布局
function initLayout () {
	var navIndex = (localStorage.getItem("navIndex") || 0);
	
	if (name && from == "activity" ) {
		$("header h1").html(app.cutstr(name, 9));
		navIndex = 0;
	}
	
	if (from == "activity") {
		$(".back").attr("href", "javascript:navigator.app.exitApp()");
	}
	
	localStorage.setItem("iName", name);
	sessionStorage.setItem("id", data.id);
	sessionStorage.setItem("belongOrgId", data.belongOrgId);
	
	// 获取导航数据，并初始化界面
	app.loadData(app.basePath +"TcompanyModuleConfigMy/tcompanymoduleconfigmy!listAjaxp.action", data, function (result) {
		var html = "";
		if (result.success) {
			$(result.message).each(function (i) {
				html += '<li class="'+ (i == 0 ? "current" : "") +'"data-moduleId="'+ this.moduleId +'" data-moduleCode="'+ this.moduleCode +'" ><span>'+ this.moduleName +'</span></li>';
			});
			
			$("#nav").width($(result.message).size() * 100 + 20);
			$("#nav ul").html(html);
			
			if (from == "index.html") {
				navIndex = 0;
			}
			
			navScroll = new IScroll('#navWrap', { scrollX: true, scrollY: false, mouseWheel: true });
			$("#nav li").eq(navIndex).trigger("click");
			if (navIndex != 0) {
				$("header h1").html(app.cutstr($("#nav li").eq(navIndex).text(), 9));
			}
		} else {
			app.toast(result.message);
		}
	});
	
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
	
	$("#nav li").live("click", navClickHandler);
	
	$("#wrapper").swipe({
		swipe:function(event, direction, distance, duration, fingerCount) {
			//console.log("你用"+fingerCount+"个手指以"+duration+"秒的速度向" + direction + "滑动了" +distance+ "像素 " );
			
			var index = $("#nav li").index($("#nav li.current"));
			if (direction == "left") {
				index++;
				if (index < $("#nav li").size()) {
					$("#nav li").eq(index).trigger("click");
				}
			}
			
			if (direction == "right") {
				
				index--;
				if (index >= 0) {
					$("#nav li").eq(index).trigger("click");
				}
			}
		}
	});
}

function onDeviceReady() {
	// 注册回退按钮事件监听器
	if (pageUrl.indexOf("i.html")) {
		document.addEventListener("backbutton", onBackKeyDown, false)
	}
} 
function onBackKeyDown() {
	navigator.app.exitApp();
}

$(function () {
	initLayout();
	//document.addEventListener("deviceready", onDeviceReady, false);
});


