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
	
	// 测试会员
	//html += '<li class="module-feedback"><a href="member.html?companyId='+ data.companyId +'&belongOrgId='+ data.belongOrgId +'&weixinOpenId=oLb15t6vQVD3bGJBr_xWxDo3QI7s"><label>会员卡</label><span class="icon"></span></a></li>';
	// 测试刮刮卡
	//html += '<li class="module-feedback"><a href="guagua.html?companyId='+ data.companyId +'&belongOrgId='+ data.belongOrgId +'&weixinOpenId=oLb15t6vQVD3bGJBr_xWxDo3QI7s&activeId=4028850243291d93014329293ce4000b"><label>刮刮卡</label><span class="icon"></span></a></li>';
	
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
					'<li><label>联系电话:</label><span><a href="tel:'+ (rs.message.officePhone || "") +'">'+ (rs.message.officePhone || "") +'</a></span></li>'+
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
	if (!rs.message.content || rs.message.content == "") {
		content = "<span>没有填写内容。</span>";
	}
	
	html =  '<div class="desc">'+ content +'</div>';
				
	$("article").html(html);
	$("header hgroup h2").html(rs.message.name);
	$("header hgroup").append('<span class="date">'+ app.formatDate(rs.message.publishTime) +'</span>');
	app.initLoadPage($("#page"));
}

function setCardForm (rs, data) {
	if (rs.success) {
		for (var nodeName in rs.message) {
			if (rs.message[nodeName] == "Y") {
				$(".card-form li."+ nodeName).css("display", "-webkit-box");
				$(".card-form li."+ nodeName+" .txt").addClass("required");
			}
			
			$(".card-form li.isPassword").css("display", "-webkit-box");
			$(".card-form li.isConfirmPass").css("display", "-webkit-box");
		}
	}
	app.initLoadPage($("#page"));
}

function setMemberInfo (rs, data) {
	if (rs.success) {
		console.log(rs)
		$(".c-name").html(rs.message.memCardName);
		$("#memCardPriv").html(rs.message.memCardPriv.replaceAll("\n", "<br/>") || "暂时没有填写。");
		$("#memCardUse").html(rs.message.memCardUse.replaceAll("\n", "<br/>") || "暂时没有填写。");
		$("#memCardScore").html(rs.message.memCardScore.replaceAll("\n", "<br/>") || "暂时没有填写。");
		$("#companyName >a").html("公司："+ rs.message.companyName);
		$("#companyOfficeAddress").html(rs.message.companyOfficeAddress);
		if (rs.message.companyMobile) {
			$("#companyMobile").html('<a href="tel:'+ rs.message.companyMobile +'">手机：'+ rs.message.companyMobile +'</a>');
		} else {
			$("#companyMobile").hide();
		}
		if (rs.message.companyOfficePhone) {
			$("#companyOfficePhone").html('<a href="tel:'+ rs.message.companyOfficePhone +'">固定电话：'+ rs.message.companyOfficePhone +'</a>');
		} else {
			$("#companyOfficePhone").hide();
		}

		if (rs.message.isMember) {
			$(".c-number").show();
			$(".c-number span:last").html(rs.message.cardNo);
			$(".c-sn").html('<img src="'+ app.basePath +'TmemberCardInfo/tmembercardinfo!memberCardBarcodeAjaxp.action?weixinOpenId='+ data['weixinOpenId'] +'&belongOrgId='+ data['belongOrgId'] +'" style="height:60px"/>').show();
			
			$("#cardinfo").show();
			var cardinfo = '姓名：'+ (rs.message.name || "") +'<br/>性别：'+ (rs.message.sex == "M" ? "男" : "女") +'<br/>生日：'+ (rs.message.birthday || "") +'<br/>电话：'+ rs.message.tel +'<br/>联系地址：'+ (rs.message.address || "")+'<br/>';
			$("#cardinfoDetail").html(cardinfo);
			$("#modifyInfo >a").attr("href", "member-modify.html?companyId="+ data['companyId'] +"&belongOrgId="+ data['belongOrgId'] +"&weixinOpenId="+ data['weixinOpenId']);
			$("#modifyInfoPass >a").attr("href", "member-modifypass.html?companyId="+ data['companyId'] +"&belongOrgId="+ data['belongOrgId'] +"&weixinOpenId="+ data['weixinOpenId']);
		} else {
			$(".c-register").css("display", "block").attr("href", "member-register.html?companyId="+ data['companyId'] +"&belongOrgId="+ data['belongOrgId'] +"&weixinOpenId="+ data['weixinOpenId']);
		}
	}
	app.initLoadPage($("#page"));
}

function setModifyMemberInfo (rs, data) {
	if (rs.success && rs.message.isMember) {
		var b = new Date(rs.message.birthday || "");
		console.log(b)
		$("input[name='c-f-name']").val(rs.message.name || "");
		$("input[name='c-f-tel']").val(rs.message.tel || "");
		$("select[name='c-f-birth-year']").val(b.getFullYear());
		$("select[name='c-f-birth-month']").val((b.getMonth() + 1) > 9 ? (b.getMonth() + 1) : ("0"+ (b.getMonth() + 1)));
		$("select[name='c-f-birth-day']").val(b.getDate() > 9 ? b.getDate() : ("0"+ b.getDate()));
		$("input[name='c-f-sex'][value='"+ rs.message.sex +"']").attr("checked",true);
		$("input[name='c-f-address']").val(rs.message.address || "");
		
		$('input').iCheck({
			checkboxClass: 'icheckbox_minimal-blue',
			radioClass: 'iradio_minimal-blue'
		});
	}  else {
		alert("对不起，您还不是会员，请先申请成为会员再设置");
		window.location.href="member.html?companyId="+ data['companyId'] +"&belongOrgId="+ data['belongOrgId'] +"&weixinOpenId="+ data['weixinOpenId'];
	}
	app.initLoadPage($("#page"));
}

function setModifyMemberPass (rs) {
	if (rs.success && rs.message.isMember) {
		data["name"] = rs.message.name || "";
		data["tel"] = rs.message.tel || "";
		data["birthday"] = rs.message.birthday || "";
		data["sex"] = rs.message.sex || "M";
		data["address"] = rs.message.address || "";
	} else {
		alert("对不起，您还不是会员，请先申请成为会员再设置");
		window.location.href="member.html?companyId="+ data['companyId'] +"&belongOrgId="+ data['belongOrgId'] +"&weixinOpenId="+ data['weixinOpenId'];
	}
	app.initLoadPage($("#page"));
}

function setActiveInfo (rs) {
	if (rs.success) {
		console.log(rs)
		$("title").html(rs.message.activeName || "刮刮卡");
		$("#prize-contact-label").html(rs.message.exchangeContact+"：" || "联系方式");
		var html = '';
		$(rs.message.prizeSettings).each(function (i) {
			html += '<li class="p'+ (i + 1) +'">'+ 
						'<div class="txt">'+ 
							'<p><span>奖品数量：</span><span>'+ this.prizeItemAmount +'名</span></p>'+ 
							'<p>'+ this.prizeItemName +'</p>'+ 
						'</div>'+ 
					'</li>';
		});
		$(".prize-options").html(html);
		$(".scratch-explain .bd").html(
			'<p>'+
				'1. 活动开始时间：<font color="#dc2c2c">'+ rs.message.beginTime +'</font><br/>'+ 
				'2. 活动结束时间：<font color="#dc2c2c">'+ rs.message.endTime +'</font><br/>'+ 
				'3. 每人每天抽奖次数：<font color="#dc2c2c">'+ rs.message.dayMaxTimes + "</font> 次<br/>"+
				'4. 每人抽奖总次数：<font color="#dc2c2c">'+ rs.message.maxTimes + "</font> 次<br/>"+
				'5. 兑奖说明：'+ rs.message.exchangeRemark +
			'<p>'
		);
		$(".scratch-btn").attr("href", 'prizelist.html?companyId='+ data.companyId +'&belongOrgId='+ data.belongOrgId +'&weixinOpenId='+ data.weixinOpenId +'&activeId='+ data.activeId);
	} else {
		alert(rs.message);
	}
	app.initLoadPage($("#page"));
}

function generateMessage (isSurprise) {
	var surpriseMsg = [
		'<img src="images/icon_laugh.png" />哇塞塞，你今天真是赚大发了，快去买彩票吧。',
		'<img src="images/icon_laugh.png" />不是吧！这都被你刮到了，给别人留条活路吧。',
		'<img src="images/icon_laugh.png" />哇哈哈哈哈，哇哈哈哈哈哈，哇哈哈哈哈哈哈哈，中了个奖而已，看把你得瑟的。。。',
		'<img src="images/icon_laugh.png" />感谢××组委会、感谢××传媒、感谢喜爱支持我的观众(奔儿，一个飞吻)。',
		'<img src="images/icon_laugh.png" />来，手举手机，面向观众，双膝下跪，喜极而泣吧。',
		'<img src="images/icon_laugh.png" />恰噶，这都被你刮到了，求求你别刮了，留点机会给小编我吧',
		'<img src="images/icon_laugh.png" />大虾，你能告诉我你是怎么刮到的么，你太厉害了。',
		'<img src="images/icon_laugh.png" />不会吧，你用哪个手指刮的啊，这都中了。',
		'<img src="images/icon_laugh.png" />你属牛的吧，我对你的敬仰犹如滔滔江水连绵不绝，又如黄河泛滥一发不可收拾。。。',
		'<img src="images/icon_laugh.png" />看到你中奖，不由得精神为之一振，自觉七经八脉为之一畅，自古英雄出少年啊',
		'<img src="images/icon_laugh.png" />在你中奖之前，我对人世间是否有真正的圣人是怀疑的；而现在，我终于相信了！'
	], failedMsg = [
		'<img src="images/icon_cry.png" />小道消息，用左手无名指第二节刮中奖概率高，赶紧试试看。',
		'<img src="images/icon_cry.png" />传说，屁股刮比手指刮更容易中大奖哦。',
		'<img src="images/icon_cry.png" />很抱歉，试试换个方向，手机朝北刮刮看。',
		'<img src="images/icon_cry.png" />别灰心，下个大奖一准是你的。',
		'<img src="images/icon_cry.png" />啊哦， 刮不到不是你人品不好，而是刮的太少哦。',
		'<img src="images/icon_cry.png" />嘿，小伙伴！在没把屏幕刮花、手指戳烂之前，咱再接再厉接着刮吧！',
		'<img src="images/icon_cry.png" />据说大家一起刮，很容易中一等奖，试试看。',
		'<img src="images/icon_cry.png" />别灰心，天上正在掉馅饼，听说今天会砸到你头上哦。',
		'<img src="images/icon_cry.png" />传说，念十遍“窗前明月光，我要刮刮卡；锄禾日当午，我要刮刮卡”，中奖概率提高0.1%。',
		'<img src="images/icon_cry.png" />听说今天财神在东北方向，不拜一拜，怎么知道灵不灵！',
		'<img src="images/icon_cry.png" />加油加油，换个姿势，再试一次。',
		'<img src="images/icon_cry.png" />用小刀刮中奖率提高99%，信不信由你，反正我是不信了。',
		'<img src="images/icon_cry.png" />温馨提醒，谁不让你中奖，就把谁系统刮瘫。',
		'<img src="images/icon_cry.png" />温馨提醒，持手机原地转三圈，中奖率提高0.01%。'
	];
	
	if (isSurprise) {
		var index = parseInt(Math.random() * surpriseMsg.length);
		return surpriseMsg[index];
	} else {
		var index = parseInt(Math.random() * failedMsg.length);
		return failedMsg[index];
	}
	
	return '<img src="images/icon_cry.png" />别灰心，下个大奖一准是你的';
}

function setScratchResult () {
	app.loadData(
		app.basePath +"TmemberActiveInfo/tmemberactiveinfo!guaguaRollAjaxp.action", 
		data, 
		function (rs) {
			console.log(rs)
			if (rs.success) {
				var result = "感谢参与", message = "";
				switch (rs.message.prizeLevel) {
					case -1: 
						result = "感谢参与";
						message = generateMessage(false);
						break;
					case -9: 
						result = "感谢参与";
						message = '<img src="images/icon_cry.png" />'+ rs.message.prizeMsg;
						break;
						
					case 1:
						result = "一等奖";
						message = generateMessage(true);
						break;
						
					case 2:
						result = "二等奖";
						message = generateMessage(true);
						break;
						
					case 3:
						result = "三等奖";
						message = generateMessage(true);
						break;
						
					case 4:
						result = "四等奖";
						message = generateMessage(true);
						break;
						
					case 5:
						result = "五等奖";
						message = generateMessage(true);
						break;
						
					case 6:
						result = "六等奖";
						message = generateMessage(true);
						break;
					
					default:
						result = "感谢参与";
						result = rs.message.prizeMsg;
						break;
				}
				
				$('.scratch-view-result').html(result);
				$('.scratch-view-message').html(message);
				$('.scratch-view-message').attr("prizeLevel", rs.message.prizeLevel);
			}
		}
	);
}

function showScratchResult(e) {
	if (!$('.scratch-view').hasClass("s-loaded")) {
		$('.scratch-view').addClass("s-loaded");
		setScratchResult();
	}
}

function initScratch () {
	scratch = $('.scratch-view-overlay').wScratchPad({
		width           : $(".scratch-view").width(),
		height          : 70, 
		color           : '#ababab',
		overlay         : 'none',
		size            : 20,
		realtimePercent : false,
		scratchDown: showScratchResult,
		scratchUp: showScratchView
	});
}

function resetScratch () {
	scratch.wScratchPad('reset');
	$('.scratch-view').removeClass("s-loaded");
	$('.scratch-view-result').html("");
	$('.scratch-view-message').html("");
	$('.scratch-view-overlay').html("");
	initScratch();
}

function showScratchView (e, p) {
	if (p > 0 && $('.scratch-view-result').html() == "") {
		setScratchResult();
	}
	if (scratch && p > 40 && p < 100) {
		scratch.wScratchPad('clear');
		var dialog, prizeLevel = $('.scratch-view-message').attr("prizeLevel"), opts = {
			title: $('.scratch-view-result').html(),
			message: $('.scratch-view-message').html()
		};
		if (prizeLevel == -1) {
			opts = $.extend({
				btn: [
					{
						txt:"继续刮",
						callback: function () {
							resetScratch();
							dialog.hide();
						}
					},
					{
						txt:"不玩了",
						callback: function () {
							dialog.hide();
						}
					}
				]
			}, opts);
		} else if (prizeLevel == -9) {
			opts = $.extend({
				btn: []
			}, opts);
		} else if (prizeLevel > 0){
			opts = $.extend({
				btn: [
					{
						txt:"继续刮",
						callback: function () {
							resetScratch();
							dialog.hide();
						}
					},
					{
						txt:"中奖结果",
						callback: function () {
							window.location.href = 'prizelist.html?companyId='+ data.companyId +'&belongOrgId='+ data.belongOrgId +'&weixinOpenId='+ data.weixinOpenId +'&activeId='+ data.activeId
						}
					}
				]
			}, opts);
		}
		
		dialog = new Dialog(opts);
		dialog.show();
	}
}

function Dialog (opts) {
	var show, hide, $dialog, options = $.extend({
			selector: "#dialog", 
			title: "没有中奖",
			message: "很抱歉没有中奖",
			btn:[{
				text:"确定",
				callback: null
			},
			{
				text:"取消",
				callback: null
			}]
		}, opts || {}),
		
		show = function () {
			$dialog.show();
			$dialog.find(".dialog-overlay").show(0);
			$dialog.find(".dialog").show().animate({
				//top:($(window).height() - $dialog.height()) / 2
				top: 100
			});
			$dialog.find(".dialog").css("position", "fixed");
		},
		
		hide = function () {
			$dialog.find(".dialog").animate({
				top:1000
			}, function () {
				$(this).hide(0)
				$dialog.find(".dialog-overlay").hide(0);
				$dialog.hide();
				$dialog.find(".dialog").css("top", 0);
			});
		};
	
	$dialog = $(options.selector);
	$dialog.find(".dialog-overlay").height($("body").height());
	$dialog.find("h3").html(options.title);
	$dialog.find(".txt").html(options.message);
	$(options.btn).each(function (i) {
		$dialog.find(".btn").eq(i).html(this.txt);
		if (this.callback == null) {
			$dialog.find(".btn").eq(i).bind("click", hide);
		} else {
			$dialog.find(".btn").eq(i).bind("click", this.callback);
		}
		$dialog.find(".btn").eq(i).css("display", "block");
	});
	$dialog.find(".close").click(hide);
	return {
		options:options,
		show: show,
		hide: hide
	}
}

function setPrizeList (rs) {
	var html = '暂时没有中奖，继续努力哦。';
	if (rs.success && rs.message.length > 0) {
		html = "";
		$(rs.message).each(function () {
			var btn = '<a class="btn" href="prizedo.html?weixinOpenId='+ data.weixinOpenId +'&companyId='+ data.companyId +'&activeId='+ data.activeId +'&belongOrgId='+ data.belongOrgId +'&sn='+this.sn+'">领取</a>';
			if (this.status == "002") {
				btn = '<a class="btn btn-gray" href="javascript:void(0)">已使用</a>';
			}
			if (this.status == "001" && this.contact && this.contactName) {
				if (this.hasPwd) {
					btn = '<a class="btn btn-green" href="prizedo.html?weixinOpenId='+ data.weixinOpenId +'&companyId='+ data.companyId +'&activeId='+ data.activeId +'&belongOrgId='+ data.belongOrgId +'&sn='+this.sn+'">去兑奖</a>';
				} else {
					btn = '<a class="btn btn-green" href="prizedo.html?weixinOpenId='+ data.weixinOpenId +'&companyId='+ data.companyId +'&activeId='+ data.activeId +'&belongOrgId='+ data.belongOrgId +'&sn='+this.sn+'">已领取</a>';
				}
			}
 			html += '<li>'+
						'<p><span>'+ this.prizeName +'</span></p>'+
						'<p>'+ this.prizeItemName +'</p>'+
						'<p><font color="#FFDD00">'+ this.snName +':'+ this.sn +'</font></p>'+
						btn +
						'<span class="date">'+ this.winTime +'</span>'+
					'</li>';
		});
	} else {
		html = rs.message;
	} 
	
	$(".prize-options").html(html);
	app.initLoadPage($("#page"));
}

function setPrizeBind (rs) {
	if (rs.success) {
		alert("保存成功，请按活动说明进行奖品兑换。");
		window.location.reload();
		//window.location.href = 'prizelist.html?companyId='+ data.companyId +'&belongOrgId='+ data.belongOrgId +'&weixinOpenId='+ data.weixinOpenId +'&activeId='+ data.activeId
	} else {
		alert(rs.message);
	}
}

function setPrizeDo (rs) {
	console.log(rs)
	if (rs.success && rs.message.length > 0) {
		$(rs.message).each(function () {
			$("#prize-sn").html(this.sn || "");
			$("#prize-level").html(this.prizeName || "");
			$("#prize-item").html(this.prizeItemName || "");
			if (this.contactName && this.contact) {
				$("input[name='prize-contactName']").val(this.contactName)
				$("input[name='prize-contact']").val(this.contact)
				$("input[name='prize-contactName'], input[name='prize-contact']").addClass("eneditable").attr("readonly", "readonly");
				if (this.hasPwd) {
					$(".prize-exchange").show();
				}
			} else {
				$("input").removeClass("eneditable");
				$(".prize-bind-submit").css("display", "block");
			}
		});
		
		$(".prize-bind .prize-bind-submit").click(function () {
			var cName = $("input[name='prize-contactName']").val(),
				cNumber = $("input[name='prize-contact']").val();
				
			if (cName == "") {
				alert("姓名不能为空");
				return false;
			}
			
			if (cNumber == "") {
				alert("联系方式不能为空");
				return false;
			}
			
			data['contactName'] = cName;
			data['contact'] = cNumber;
			app.loadData(app.basePath +"TmemberActiveInfo/tmemberactiveinfo!bindSnContactAjaxp.action", data, setPrizeBind);
		});
		
		$(".prize-bind .prize-bind-exchange").click(function () {
			var cExchange = $("input[name='prize-exchange']").val();
				
			if (cExchange == "") {
				alert("兑奖密码不能为空");
				return false;
			}
			
			data['exchangePwd'] = escape(cExchange);
			app.loadData(app.basePath +"TmemberActiveInfo/tmemberactiveinfo!exchangePrizeAjaxp.action", data, function (rs) {
				if (rs.success) {
					alert("提交成功，可以兑换奖品了。");
					window.location.href = 'prizelist.html?companyId='+ data.companyId +'&belongOrgId='+ data.belongOrgId +'&weixinOpenId='+ data.weixinOpenId +'&activeId='+ data.activeId
				} else {
					alert(rs.message);
				}
			});
		});
	} else {
		
	}
	app.initLoadPage($("#page"));
}

Array.prototype.contains = function(e) {
	for(i = 0; i< this.length; i++) {
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

String.prototype.replaceAll = function (oldStr, newStr) {
	 return this.replace(new RegExp(oldStr, "gm"), newStr);
}

document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
	if (!app.getParam(window.location.href.toString(), "weixinOpenId")) {
		WeixinJSBridge.call('hideToolbar');
	}
});
