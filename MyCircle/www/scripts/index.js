var pageUrl = window.location.href.toString(),
	myScroll,
	totalPages, //  总页数
	totalCount, //  总条数
	hasNextPage = true, // 是否有下一页
	url = app.basePath + "TcompanyInfo/tcompanyinfo!listAjaxp.action",
	prourl = app.basePath + "TcompanyInfo/tcompanyinfo!queryProvinceAjaxp.action",
	cityurl = app.basePath + "TcompanyInfo/tcompanyinfo!queryCityAjaxp.action",
	countyurl = app.basePath + "TcompanyInfo/tcompanyinfo!queryCountyAjaxp.action",
	attrurl =  app.basePath + "TsysAttrSpec/tsysattrspec!getStaticAttrAjaxp.action",
	data = {  // 获取列表的参数
		"page.pageNo":1,    // 默认获取第一页
		"page.pageSize":10  // 每页显示条数
	},
	prodata = {
		"provinceId":''
	},
	countydata = {
		"cityId":''
	},
	attrdata = {
		"attrCode":'ATTR_COMPANY_TYPE',
		"dynamic":'false'
	};

// 刷新list UI
function updateListViewSuccess (obj, isPullDown) {
	// 设置总页数和总条数
	totalPages = obj.message.totalPages;
	totalCount = obj.message.totalCount;

	// totalPages总页数只有一页，不显示“上拉加载”
	if (totalPages == 1 || !hasNextPage) {
		$('#pullUp').hide();
	}
	
	console.log("obj.message.pageNo="+ obj.message.pageNo)
	console.log("data['page.pageNo']="+ data['page.pageNo'])
	// 返回的页码小于请求参数里的页码值时，说明没有下一页了，隐藏“上拉加载”，并跳出
	if (obj.message.pageNo < data['page.pageNo']) {
		$('#pullUp').hide();
		hasNextPage = false;
		return;
	} else {
		$('#pullUp').show();
		hasNextPage = true;
	}
	
	if ($(obj.message.result).size() < obj.message.pageSize) {
		$('#pullUp').hide();
		hasNextPage = false;
	}
	
	if (isPullDown) { // 下拉刷新
		var html = '';
		$(obj.message.result).each(function () {
			html += '<li onclick="ishow(\''+ this.id +'\', \''+ this.belongOrgId +'\', \''+ escape(this.companyName) +'\')">' + 
						'<a><img src="'+app.checkimg(this.image)+'"/></a>' +
						'<p>' +
							'<span class="title">'+app.cutstr(app.checkstr(this.companyName), 9)+'</span>' +
							'<span class="developer">'+app.cutstr(app.checkstr(this.officeAddress), 13)+'</span>' +
							'<span class="leixin">'+app.cutstr(app.checkstr(this.companyType), 13)+'</span>' +
						'</p>' +
						'<div class="list_arrow"></div>'+
					'</li>'
		});
		
		if (html == "") {
			html = '<li class="null-data" style="text-align:center">没有搜到匹配的数据。</li>';
		}
		$("#listContainer").html(html);
		$("#pullDown").hide();
		
	} else { // 上拉加载更多
		var html = '';
		$(obj.message.result).each(function () {
			html += '<li onclick="ishow(\''+ this.id +'\', \''+ this.belongOrgId +'\', \''+ this.companyName +'\')">' + 
						'<a><img src="'+app.checkimg(this.image)+'"/></a>' +
						'<p>' +
							'<span class="title">'+app.cutstr(app.checkstr(this.companyName), 9)+'</span>' +
							'<span class="developer">'+app.cutstr(app.checkstr(this.officeAddress), 13)+'</span>' +
							'<span class="leixin">'+app.cutstr(app.checkstr(this.companyType), 13)+'</span>' +
						'</p>' +
						'<div class="list_arrow"></div>'+
					'</li>'
		});
		$("#listContainer").append(html);
		myScroll.scrollTo(0, myScroll.maxScrollY - 10, 0, false);
	}
	myScroll.refresh();
}

function updateListViewFail (e) {
	myScroll.refresh();
	app.toast(e);
}

function ishow (id, belongOrgId, name) {
	localStorage.iFrom = "index.html";
	localStorage.iId = id;
	localStorage.iBelongOrgId = belongOrgId;
	localStorage.iName = name;
	window.location.href="i.html?companyId="+id+"&belongOrgId="+belongOrgId;
	return false;
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
	
	// 刷新布局
	myScroll.on("refresh", function () {
		$('#pullDown').find(".pullDownLabel").html("下拉刷新");
		$('#pullUp').find(".pullUpLabel").html("上拉显示下一页");
		
	})
	
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
			data['page.pageNo'] = 1;
			app.loadData(url, data, updateListViewSuccess, updateListViewFail, true);
		}
		
		// 滑到了底部
		if (this.y == this.maxScrollY) {
			// 总页数大于1，且存在下一页，执行上拉加载
			if (totalPages > 1 && hasNextPage) {
				data['page.pageNo'] = data['page.pageNo'] + 1;
				app.loadData(url, data, updateListViewSuccess, updateListViewFail, false);
			} else {
				$("#pullUp").hide();
				app.toast("没有下页了");
			}
		}
	});
	
	$("#searchButton").click(function () {
		var keywords = $("#searchKeywords").val();
		sessionStorage.setItem("filter_LIKES_companyName", keywords);
		data['filter_LIKES_companyName'] = keywords;
		app.loadData(url, data, updateListViewSuccess, updateListViewFail, true);
		
		return false;
	});
	
	// 设置类型
	var searchAttrName = sessionStorage.getItem("searchAttrName");
	$("#searchCategory").html(
		(searchAttrName == null || searchAttrName == "") ? "全部类型" : app.cutstr(searchAttrName, 5)
	);
	
	// 设置区域
	var areaName = sessionStorage.getItem("areaName");
	$("#searchArea").html(
		(areaName == null || areaName == "") ? "全部区域" : app.cutstr(areaName, 5)
	);
	
	var keywords = app.getParam(pageUrl, "filter_LIKES_companyName"),
		new_task = app.getParam(pageUrl, "new_task");

	// 新的session对话，清空所有参数
	if (new_task != null) {
		sessionStorage.clear();
	}
	
	// 保存android传递的关键词
	if (keywords != null) {
		$("#searchKeywords").val(keywords);
		sessionStorage.setItem("filter_LIKES_companyName", keywords);
	} else {
		$("#searchKeywords").val(sessionStorage.getItem("filter_LIKES_companyName"));
	}
}

$(function () {
	//initLayout();
	data['filter_LIKES_companyName'] = sessionStorage.getItem("filter_LIKES_companyName");
	data['filter_EQS_companyType'] = sessionStorage.getItem("filter_EQS_companyType");
	data['filter_EQS_companyMode'] = sessionStorage.getItem("filter_EQS_companyMode");
	data['filter_EQS_provinceId'] = sessionStorage.getItem("filter_EQS_provinceId");
	data['filter_EQS_cityId'] = sessionStorage.getItem("filter_EQS_cityId");
	data['filter_EQS_countyId'] = sessionStorage.getItem("filter_EQS_countyId");
	app.setParam(pageUrl, data, ["new_task"]); // 将页面url中的参数设置到请求接口参数中
	
	app.loadData(url, data, updateListViewSuccess, updateListViewFail, true);//获取默认数据列表
});