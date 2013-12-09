var pageUrl = window.location.href.toString(),
	from = app.getParam(pageUrl, "from") || localStorage.productFrom,
	data = {
		"belongOrgId": localStorage.iBelongOrgId || sessionStorage.getItem("belongOrgId"),
		"companyId": localStorage.companyId || sessionStorage.getItem("companyId"),
		"id": localStorage.productId || sessionStorage.getItem("productId")
	},
	name = unescape(localStorage.productName) || sessionStorage.getItem("productName"),
	myScroll, navScroll, imaegScroll,
	modules = {
		"MOD_PRODUCT_INFO": {// 产品介绍
			"api": app.basePath + "TcompanyProduct/tcompanyproduct!showAjaxp.action",
			"params": data,
			"callback": setProductInfoView
		},
		
		"MOD_PRODUCT_FEEDBACK": {//产品评论
			"api": app.basePath + "TcompanyFeedback/tcompanyfeedback!listAjaxp.action",
			"params": {
				"belongOrgId":data.belongOrgId,
				"page.pageNo": 1,
				"page.pageSize": 10,
				"feedbackType": "02",
				"objectId": data.id
			},
			"callback": setFeedbackView,
			"page": {
				totalPages: 0,
				totalCount: 0,
				hasNextPage: true
			}
		},
		
		"MOD_PRODUCT_CONTACT": {// 联系方式
			"api": app.basePath + "TcompanyInfo/tcompanyinfo!contactAjaxp.action",
			"params": {
				"belongOrgId":data.belongOrgId,
				"id": data.companyId
			},
			"callback": setContactView
		}
	};
	
// 产品介绍
function setProductInfoView (rs) {
	if (!rs.success) {
		app.toast(rs.message);
		return false;
	}
	var html = '<div id="viewport">'+
				'<div id="imageWrapper">'+
					'<div id="imageScroller">'+
						'<div class="slide">'+
							'<div class="painting"><img src="'+ app.checkimg(rs.message.image1 || "") +'"></div>'+
						'</div>'+
						'<div class="slide">'+
							'<div class="painting "><img src="'+ app.checkimg(rs.message.image2 || "") +'"></div>'+
						'</div>'+
						'<div class="slide">'+
							'<div class="painting"><img src="'+ app.checkimg(rs.message.image3 || "") +'"></div>'+
						'</div>'+
					'</div>'+
				'</div>'+
			'</div>'+
			'<div id="indicator">'+
				'<div id="dotty"></div>'+
			'</div>'+
			'<div id="productInfo">'+
				'<table width="100%">'+
					'<tr>'+
						'<td width="10%" class="key line">名称：</td>'+
						'<td class="value line">'+ rs.message.name +'</td>'+
					'</tr>'+
					'<tr>'+
						'<td class="key line">类别：</td>'+
						'<td class="value line">'+ rs.message.category +'</td>'+
					'</tr>'+
					'<tr>'+
						'<td class="key" colspan="2">介绍：</td>'+
					'</tr>'+
					'<tr>'+
						'<td class="value line c" colspan="2">'+ rs.message.introduce +'</td>'+
					'</tr>'+
				'</table>'+
				
				'<ul class="product-box">'+
					'<li id="'+ rs.message.id +'" data-module="attr"><a href="javascript:void(0)">属性</a></li>'+
					'<li id="'+ rs.message.id +'" data-module="detail"><a href="javascript:void(0)">详情</a></li>'+
				'</ul>'+
			'</div>';
			
	$("#listContainer").html(html);
	$("#scroller").find(".product-box li").unbind();
	$("#scroller").find(".product-box li").click(function () {
		var title, path, module = $(this).data("module");
		
		if (module == "attr") {
			title = "属性";
			path = "TcompanyProduct/tcompanyproduct!attrsAjaxp.action";
		}
		
		if (module == "detail") {
			title = "详情";
			path = "TcompanyProduct/tcompanyproduct!detailsAjaxp.action";
		}
		
		localStorage.productId = data.id;
		localStorage.productDetailTitle = title;
		localStorage.productDetailPath = path;
		
		window.location.href = "product-detail.html";
		return false;
	});
	
	myScroll.refresh();
	
	imaegScroll = new IScroll('#imageWrapper', {
		scrollX: true,
		scrollY: false,
		momentum: false,
		snap: true,
		snapSpeed: 400,
		keyBindings: true,
		indicators: {
			el: document.getElementById('indicator'),
			resize: false
		}
	});
}

// 产品评论
function setFeedbackView (rs, args) {
	if (typeof args != "object") return false;
	
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
		localStorage.feedbackFrom = "product.html";
		localStorage.belongOrgId = data.companyId;
		localStorage.productId = data.id;
		window.location.href = "feedback.html";
	});
	myScroll.refresh();
}

// 联系方式
function setContactView (rs, args) {
	if (!rs.success) {
		app.toast(rs.message);
		return false;
	}
	
	var html = '<div class="bit module" >'+
					'<ul class="bit_lx bit_mm">'+
						'<li>办公电话：'+ (rs.message.officePhone || "") +
							'<a href="tel:'+ (rs.message.officePhone || "") +'" id="tel" style="display:'+ ((rs.message.officePhone == "undefined") ? "none" : "block") +'"></a>'+
						'</li>'+
						'<li>手机号码：'+ (rs.message.mobile || "") +
							'<a href="sms:'+ (rs.message.mobile || "") +'" id="msg" style="display:'+ ((rs.message.mobile == "undefined") ? "none" : "block") +'"></a>'+
							'<a href="tel:'+ (rs.message.mobile || "") +'" id="tel" style="display:'+ ((rs.message.mobile == "undefined") ? "none" : "block") +'"></a>'+
						'</li>'+
						'<li>传真号码：'+ (rs.message.faxNumber || "") +'</li>'+
						'<li>电子邮箱：'+ (rs.message.email || "") +'</li>'+
						'<li>办公地址：'+ (rs.message.officeAddress || "") +'</li>'+
						'<li>邮政编码：'+ (rs.message.zipCode || "") +'</li>'+
						'<li>公司网址：<a target="_blank" href="'+ (rs.message.website || "#") +'">'+ (rs.message.website || "") +'</a></li>'+
					'</ul>'+
				'</div>';
	
	$("#listContainer").html(html);
	myScroll.refresh();
}

// 导航事件处理
function navClickHandler (e) {
	var moduleCode = $(this).data("modulecode"),
		module = modules[moduleCode];
	console.log(moduleCode)
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
		
		$('#pullDown').hide();
		$('#pullUp').hide();
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
	
	var productNavIndex = $("#nav li").index($(this)),
		el = document.querySelector('#nav li:nth-child('+ (productNavIndex) +')');
	
	$(this).siblings("li").removeClass("current");
	$(this).addClass("current");
	localStorage.setItem("productNavIndex", productNavIndex);
	//navScroll.scrollToElement(el, 500);
}

// 初始化布局
function initLayout () {
	if (name) {
		$("header h1").html(app.cutstr(name, 9));
	}
	
	sessionStorage.setItem("companyId", data.companyId);
	sessionStorage.setItem("productName", name);
	sessionStorage.setItem("productId", data.id);

	navScroll = new IScroll('#navWrap', { scrollX: true, scrollY: false, mouseWheel: true });
	
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
	
	var productNavIndex = (localStorage.getItem("productNavIndex") || 0);
	
	$("#nav li").live("click", navClickHandler);
	$("#nav li").eq(productNavIndex).trigger("click");
}

$(function () {
	initLayout();
	
	localStorage.iFrom = "product.html";
});