var app = {
	basePath: "http://117.21.209.104:80/EasyContact/",
	timeout: 2000,
	exit: function (h) {
		alert(h)
	},
	back: function (urls, args) {
		if (urls && urls.indexOf("?") > 0) {
			var url = urls.split("?")[0],
				search = urls.split("?")[1],
				urlparams, urlparam;
				
			urlparams = search.split("&");
			for (var i = 0; i < urlparams.length; i++) {
				urlparam = urlparams[i].split("=");
				localStorage.setItem(urlparam[0], urlparam[1]);
			}
			
			window.location.href = url;
		}
	},
	toast: function (message, timeout) {
		if (!timeout) timeout = 2000;
		alert(message);
	},
	loadData: function (url, data, success, fail, args) {
		console.log(url)
		console.log(data)
		$.ajax({
			type: "post",
			data: data,
			async: false,
			traditional:true,
			url: url,
			dataType: "jsonp",
			jsonp: "jsoncallback",
			success: function(json){
				if (success && typeof success == "function" ) {
					success(json, args)
				}
			},
			error: function(e){
				if (fail && typeof fail == "function") {
					fail(e);
				}
			}
		});
	},
	checkstr: function(str) {
		return str || "";
	},
	checkimg: function(path) {
		if (!path || path == "" || path == null) {
			return 'images/nulldata.png';
		} else {
			return this.basePath + path;
		}
	},
	cutstr: function (str, len) {
		if (str.length > len) {
			return str.substr(0, len) + "...";
		}else{
			return str;
		}
	},
	formatDate: function (timestamp) {
		if (timestamp) {
			return new Date(timestamp).format("yyyy-MM-dd");
		} else {
			return "";
		}
	},
	setParam: function  (url, data, excepParams) {
		var url = url.split("?")[1],
			urlparams, urlparam;
		if (url) {
			urlparams = url.split("&");
			for (var i = 0; i < urlparams.length; i++) {
				urlparam = urlparams[i].split("=");
				if (!excepParams.contains(urlparam[0])) {
					if (data) {
						data[''+ urlparam[0] +''] = urlparam[1];
					}
				}
			}
		}
	},
	getParam: function (url, paramName) {
		if (url.indexOf("?") > 0) {
			var urls = url.split("?")[1],
			i, val, params = urls.split("&");

			for (i = 0; i < params.length; i++) {
				val = params[i].split("="); 
				if (val[0] == paramName) {
					return unescape(val[1]); 
				}
			}
		}
		return null; 
	},
	initLoadPage: function ($page) {
		if (!$page || !data) return false;
		var pageUrl = window.location.href.toString();
		if (app.getParam(pageUrl, "isShowNav") && app.getParam(pageUrl, "isShowNav") == "false") {
			$page.find("nav").hide();
			return;
		}
		$page.find(".link-index").attr("href", "i.html?companyId="+ data.companyId +"&belongOrgId="+ data.belongOrgId);
	},
	initLoadPager:function ($page, rs) {
		if (!$page || !data || (!rs && !rs.success)) return false;
		var $pagerPrev = $page.find(".pager > .prev"),
			$pagerNext = $page.find(".pager > .next");
			
		if (data['page.pageNo'] <= 1) {
			$pagerPrev.hide();
		} else {
			$pagerPrev.show();
			$pagerPrev.attr("href", "javascript:load("+ (data['page.pageNo'] - 1) +")");
		}

		if (data['page.pageNo'] >= rs.message.totalPages) {
			$pagerNext.hide();
		} else {
			$pagerNext.show();
			$pagerNext.attr("href", "javascript:load("+ (data['page.pageNo'] + 1) +")");
		}
	}
};
function setSiteInfo (rs, data) {
	//console.log(rs);
	if (!rs.success) {
		alert(rs.message)
		return false;
	}
	
	$("header h1").html(rs.message.name);
	$(".copyright").html("&copy; "+ rs.message.name);
}
function setNavigation (rs, data) {
//console.log(rs)
	if (!rs.success) {
		alert(rs.message)
		return false;
	}
	var html = "";
	$(rs.message).each(function () {
		if (this.moduleCode == "MOD_COMPANY_INFO") {
			html += '<li class="module-about"><a href="about.html?companyId='+ data.companyId +'&belongOrgId='+ data.belongOrgId +'"><label>'+ this.moduleName +'</label><span class="icon"></span></a></li>';
		}
		
		if (this.moduleCode == "MOD_COMPANY_NEWS") {
			html += '<li class="module-news"><a href="newlist.html?companyId='+ data.companyId +'&belongOrgId='+ data.belongOrgId +'"><label>'+ this.moduleName +'</label><span class="icon"></span></a></li>';
		}
		
		if (this.moduleCode == "MOD_COMPANY_PRODUCT") {
			html += '<li class="module-product"><a href="productlist.html?companyId='+ data.companyId +'&belongOrgId='+ data.belongOrgId +'"><label>'+ this.moduleName +'</label><span class="icon"></span></a></li>';
		}
		
		if (this.moduleCode == "MOD_COMPANY_EXAMPLE") {
			html += '<li class="module-case"><a href="caselist.html?companyId='+ data.companyId +'&belongOrgId='+ data.belongOrgId +'"><label>'+ this.moduleName +'</label><span class="icon"></span></a></li>';
		}
		
		if (this.moduleCode == "MOD_COMPANY_FEEDBACK") {
			html += '<li class="module-feedback"><a href="feedback.html?companyId='+ data.companyId +'&belongOrgId='+ data.belongOrgId +'"><label>'+ this.moduleName +'</label><span class="icon"></span></a></li>';
		}
		
	});
	
	$("nav ul").html(html);
}

function setCompanyInfoView (rs, data) {
console.log(rs)
	if (!rs.success) {
		alert(rs.message)
		return false;
	}
	var html =  '<p class="desc">'+ (rs.message.expAttrs || "") +'</p>'+
				'<p class="desc">'+ (rs.message.introduce || "") +'</p>'+
				'<ul class="info">'+
					'<li><div class="qiye_ico"><span>企</span></div><div class="qiye_nr"><label>企业类型</label><span>'+ (rs.message.category || "") +'</span></div></li>'+
					'<li><div class="mosi_ico"><span>模</span></div><div class="mosi_nr"><label>经营模式</label><span>'+ (rs.message.companyMode || "") +'</span></div></li>'+
					'<li class="jy_warp"><div class="fanw_ico"><span>范</span></div><div class="fanw_nr"><label>经营范围</label><span>'+ (rs.message.companyScope || "") +'</span></div></li>'+
					'<li class="lxfs_warp"><div class="lxfs_ico"><span>联系方式</span></div><div class="lxfs_nr"><ul><li><label>所&nbsp;&nbsp;在&nbsp;&nbsp;地:</label><span>'+ (rs.message.province || "") + (rs.message.city || "") +(rs.message.county || "") +'</span></li>'+
					'<li><label>联&nbsp;&nbsp;系&nbsp;&nbsp;电&nbsp;&nbsp;话:</label><span><a href="tel:'+ (rs.message.officePhone || "") +'">'+ (rs.message.officePhone || "") +'</a></span></li>'+
					'<li><label>手机号码:</label><span><a href="tel:'+ (rs.message.mobile || "") +'">'+ (rs.message.mobile || "") +'</a></span></li>'+
					'<li><label>传真号码:</label><span>'+ (rs.message.faxNumber || "") +'</span></li>'+
					'<li><label>电子邮箱:</label><span>'+ (rs.message.email || "") +'</span></li>'+
					'<li><label>联系地址:</label><span>'+ (rs.message.officeAddress || "") +'</span></li>'+
					'<li><label>邮政编码:</label><span>'+ (rs.message.zipCode || "") +'</span></li>'+
					'<li><label>网&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;址:</label><span><a target="_blank" href="'+ (rs.message.website || "#") +'">'+ (rs.message.website || "") +'</a></span></li></ul></div></li>'+
				'</ul>';
	
	$("header img").attr("src", app.checkimg(rs.message.image));
	$("header h3").html(rs.message.name);
	$("article").html(html);
	app.initLoadPage($("#page"));
}

function setNewListView (rs, data) {
	if (!rs.success) {
		alert(rs.message)
		return false;
	}
	var html = '';
	$(rs.message.result).each(function () {
		html += '<li><a href="new.html?id='+ this.id +'&companyId='+ data['companyId'] +'&belongOrgId='+ data['belongOrgId'] +'">'+
					//'<p class="img">'+
					//	'<img src="http://www.jxtii.com/userfiles/image/29.jpg">'+
					//'</p>'+
					'<div class="txt">'+
						'<h2>'+ this.title +'</h2>'+
						'<span>'+ this.category +'</span><span>'+ app.formatDate(this.publishTime) +'</span>'+
					'</div>'+
				'</a><li>';
	});
	
	if (html == "") {
		html = '<li class="null-data" style="text-align:center">没有搜到匹配的数据。</li>';
	}
	
	$("article ul").html(html);
	app.initLoadPage($("#page"));
	app.initLoadPager($("#page"), rs);
}

function setNewView (rs, data) {
	if (!rs.success) {
		alert(rs.message)
		return false;
	}
	var html =  '<h1 class="t">'+ rs.message.title +'</h1>' +
				'<div id="newContent" class="desc">'+ rs.message.content +'</div>';
				
	$("article").html(html);
	$("header hgroup h2").html(rs.message.category);
	$("header hgroup").append('<span class="date">'+ app.formatDate(rs.message.publishTime) +'</span>');
	app.initLoadPage($("#page"));
}

function setCaseListView (rs, data) {
	if (!rs.success) {
		alert(rs.message)
		return false;
	}
	var html = '';
	$(rs.message.result).each(function () {
		html += '<li><a href="case.html?id='+ this.id +'&companyId='+ data['companyId'] +'&belongOrgId='+ data['belongOrgId'] +'">'+
					'<p class="img">'+
						'<img src="'+ app.checkimg(this.image) +'">'+
					'</p>'+
					'<div class="txt">'+
						'<h2>'+ this.name +'</h2>'+
						'<span>'+ this.category +'</span><span>'+ app.formatDate(this.publishTime) +'</span>'+
					'</div>'+
				'</a><li>';
	});
	
	if (html == "") {
		html = '<li class="null-data" style="text-align:center">没有搜到匹配的数据。</li>';
	}
	
	$("article ul").html(html);
	app.initLoadPage($("#page"));
	app.initLoadPager($("#page"), rs);
}

function setCaseView (rs, data) {
	if (!rs.success) {
		alert(rs.message)
		return false;
	}
	var html =  '<h1 class="t">'+ rs.message.name +'</h1>' +
				'<div class="desc">'+
					'<div class="case-img" style="text-align:center">' +
						(rs.message.image == "undefined" ? "" : '<img  src="'+ app.basePath + rs.message.image +'">') + 
					'</div>' +
					'<div class="subdesc">[简介]'+(rs.message.intraduct || "") + '</div>'+
					(rs.message.details || "") +
				'</div>';
				
	$("article").html(html);
	$("header hgroup h2").html(rs.message.category);
	$("header hgroup").append('<span class="date">'+ app.formatDate(rs.message.publishTime) +'</span>');
	app.initLoadPage($("#page"));
}

function setFeedbackListView (rs, data) {
	if (!rs.success) {
		alert(rs.message)
		return false;
	}
	
	var html = "", listhtml = '', listReplyHtml = '',
		button = '<p class="btn-group"><a href="javascript:void(0)" class="btn ">我要评论</a></p>';
	$(rs.message.result).each(function () {
		var month = new Date(this.feedbackTime).getMonth() + 1,
			day = new Date(this.feedbackTime).getDate();
			
		listhtml += '<li>'+
						'<div class="ly_name">'+
							'<span class="n">'+ (this.name || "移动客户端网友") +' 说:</span>'+
							'<span class="d"><i>'+ day +'</i><em>'+ month +'月</em></span>'+
							'<div class="c">'+this.content+ '</div>'+
						'</div>';
		
		if (this.replys.length > 0) {
			listReplyHtml = '<div class="ly_hf">'+
								'<div class="f_ang_t">'+
									'<div class="ang_i ang_t_d bor2"></div>'+
									'<div class="ang_i ang_t_u bor_bg"></div>'+
								'</div>'+
								'<ul class="ly_li2">';
								
			$(this.replys).each(function () {
				listReplyHtml += '<li><span class="r-n">管理员回复：</span>'+ this.content +'<span class="arr1"></span></li>';
				
			});
			
			listReplyHtml += '</ul></div>';

			listhtml += listReplyHtml;
			
		}
		listhtml += '<span class="arr"></span>';
		listhtml += '</li>';
	});
	
	if (listhtml == "") {
		listhtml = '<li class="null-data" style="text-align:center;line-height:60px;margin-left:17px;">暂时没有留言评论。<span class="arr"></span></li>';
		$("article").html(listhtml);
	} else {
		$("article ul").html(listhtml);
	}
	
	$("header hgroup h2").html("留言&评论<span>("+ (rs.message.totalCount || 0) +")</span>");
	app.initLoadPage($("#page"));
	app.initLoadPager($("#page"), rs);
}

function doFeedback (e, callback) {
	data["tcompanyFeedback.content"] = $("#fb_content").val().trim();
	data["tcompanyFeedback.name"] = $("#fb_name").val().trim();
	data["tcompanyFeedback.tel"] = $("#fb_tel").val().trim();
	data["tcompanyFeedback.email"] = $("#fb_email").val().trim();
	data["tcompanyFeedback.isPublic"] = $("#fb_public input").val();
	
	if ($("#fb_content").val() == "") {
		alert("内容不能为空。");
		return;
	}
	if ($("#fb_tel").val() == "" && $("#fb_email").val() == "") {
		alert("电话不能为空，以便我们回复您");
		return;
	}
	
	app.loadData(app.basePath + "TcompanyFeedback/tcompanyfeedback!saveAjaxp.action", data, function (rs) {
		if (rs.success) {
			if (callback && typeof callback == "function") {
				callback();
			}
			alert("保存成功");
			window.location.reload();
		}
	}, app.toast);
}

function setProductListView (rs, data) {
//console.log(rs)
	if (!rs.success) {
		alert(rs.message)
		return false;
	}
	var html = '';
	$(rs.message.result).each(function () {
		html += '<li><a href="product.html?id='+ this.id +'&companyId='+ data.companyId +'&belongOrgId='+ data['belongOrgId'] +'">'+
					'<p class="img">'+
						'<img src="'+ app.checkimg(this.image1) +'">'+
					'</p>'+
					'<div class="txt">'+
						'<h2>'+ this.name +'</h2>'+
						'<span>'+ this.category +'</span><span>'+ app.formatDate(this.publishTime) +'</span>'+
					'</div>'+
				'</a><li>';
	});
	
	if (html == "") {
		html = '<li class="null-data" style="text-align:center">没有搜到匹配的数据。</li>';
	}
	
	$("article ul").html(html);
	app.initLoadPage($("#page"));
	app.initLoadPager($("#page"), rs);
}

function setProductInfoView (rs) {
	if (!rs.success) {
		app.toast(rs.message);
		return false;
	}
	
	var gDisplay = function (str) {
			if (!str) {
				return "none"
			} else {
				return "block"
			}
		},
		html =  '<div id="productInfo">'+ rs.message.introduce +'</div>'+
				'<p style="display:'+ gDisplay(rs.message.image1) +'"><img src="'+ app.checkimg(rs.message.image1 || "") +'" /></p>'+
				'<p style="display:'+ gDisplay(rs.message.image2) +'"><img src="'+ app.checkimg(rs.message.image2 || "") +'" /></p>'+
				'<p style="display:'+ gDisplay(rs.message.image3) +'"><img src="'+ app.checkimg(rs.message.image3 || "") +'" /></p>'+
				'<ul class="product-btn">'+
					'<li id="'+ rs.message.id +'" data-module="attr"><a href="javascript:void(0)">相关属性</a></li>'+
					'<li id="'+ rs.message.id +'" data-module="detail"><a href="javascript:void(0)">更多详情</a></li>'+
				'</ul>';
			
	$("header hgroup h2").html(rs.message.name);
	$("header hgroup .feedback-btn").attr("href", "feedback.html?id="+rs.message.id+"&companyId="+ data["companyId"] +"&belongOrgId="+data.belongOrgId +"&feedbackType=02&isShowForm=true");
	$("article .product").html(html);
	$("article").find(".product-btn li").each(function () {
		var module = $(this).data("module");
		if (module == "attr") {
			$("a", this).attr("href", "product-detail.html?id="+rs.message.id+"&companyId="+ data["companyId"] +"&belongOrgId="+data.belongOrgId+"&path=TcompanyProduct/tcompanyproduct!attrsAjaxp.action&module="+ module);
			$(this).show();
		}
		
		if (module == "detail") {
			$("a", this).attr("href", "product-detail.html?id="+rs.message.id+"&companyId="+ data["companyId"] +"&belongOrgId="+data.belongOrgId+"&path=TcompanyProduct/tcompanyproduct!detailsAjaxp.action&module="+ module);
			$(this).show();
		}
	});
	app.initLoadPage($("#page"));
}

function setProudctDetailView (rs, data) {
//console.log(rs)
	if (!rs.success) {
		alert(rs.message)
		return false;
	}
	var html, content = rs.message.content; 
	if (content == "undefined" && data.module == "attr") {
		content = "<span>没有其他属性。</span>";
	}
	
	if (content == "undefined" && data.module == "detail") {
		content = "<span>没有其他详情。</span>";
	}
	
	html =  '<div class="desc">'+ content +'</div>';
				
	$("article").html(html);
	$("header hgroup h2").html(rs.message.name);
	$("header hgroup").append('<span class="date">'+ app.formatDate(rs.message.publishTime) +'</span>');
	app.initLoadPage($("#page"));
}

Array.prototype.contains = function(e) {
	for(i=0; i< this.length; i++) {
		if(this[i] == e) return true;
	}
	
	return false;
}

// (new Date()).Format("yyyy-MM-dd hh:mm:ss.S") ==> 2006-07-02 08:09:04.423 
// (new Date()).Format("yyyy-M-d h:m:s.S")      ==> 2006-7-2 8:9:4.18 
Date.prototype.format = function(fmt) {
	var o = { 
		"M+" : this.getMonth() + 1,
		"d+" : this.getDate(),
		"h+" : this.getHours(),
		"m+" : this.getMinutes(),
		"s+" : this.getSeconds(),
		"q+" : Math.floor((this.getMonth() + 3) / 3),
		"S"  : this.getMilliseconds()
	};
	if(/(y+)/.test(fmt)) {
		fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length)); 
	}
	for(var k in o) {
		if(new RegExp("("+ k +")").test(fmt)) {
			fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length))); 
		}
	}
	return fmt; 
}
