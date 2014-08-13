var app = {
	basePath: "http://117.21.209.204/STOA/",
	//basePath: "http://woquanquan.com/EasyOA/",
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
		data["_t"] = (new Date()).getTime();
		var params = "";
		for (var key in data) {
			if (params == "") {
				params += "?"+key+"="+data[key];
			} else {
				params += "&"+key+"="+data[key];
			}
		}
		console.log(url+params);
		
		var a = $.ajax({
			type: "post",
			data: data,
			async: false,
			traditional:true,
			url: url,
			dataType: "jsonp",
			jsonp: "jsoncallback",
			success: function (json, args1, args2) {
				if (success && typeof success == "function" ) {
					success(json, args);
				}
			},
			error: function (e) {
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
	getDate: function (timestamp) {
		if (timestamp) {
			var date = (new Date(timestamp)).getDate();
			return date > 9 ? date : "0" + date;
		} else {
			return "01";
		}
	},
	getUpperMonth: function (timestamp) {
		if (timestamp) {
			var month, upperMonth, date = new Date(timestamp);
			month = date.getMonth() || 0;
			switch(month) {
				case 0: 
					upperMonth = "一月";
					break;
				case 1: 
					upperMonth = "二月";
					break;
				case 2: 
					upperMonth = "三月";
					break;
				case 3: 
					upperMonth = "四月";
					break;
				case 4: 
					upperMonth = "五月";
					break;
				case 5: 
					upperMonth = "六月";
					break;
				case 6: 
					upperMonth = "七月";
					break;
				case 7: 
					upperMonth = "八月";
					break;
				case 8: 
					upperMonth = "九月";
					break;
				case 9: 
					upperMonth = "十月";
					break;
				case 10: 
					upperMonth = "十一";
					break;
				case 11: 
					upperMonth = "十二";
					break;
			}
			
			return upperMonth;
		} else {
			return "一月";
		}
	},
	getTimeDuration: function (timestamp, formats) {
		if (timestamp) {
			var DAY = 1440, value, duration, curDateTimestamp = new Date().getTime();
			
			duration = (curDateTimestamp - timestamp) / (1000 * 60);
			
			if (duration < 1) {
				value = "刚刚";
			} else if (duration >= 1 && duration < 60) {
				value = parseInt(duration) + "分钟前";
			} else if (duration >= 60 && duration < DAY) {
				value = parseInt((duration / 60)) + "小时前";
			} else if (duration >= DAY && duration < DAY * 2) {
				value = "昨天";
			} else if (duration >= DAY * 2 && duration < DAY * 3) {
				value = "前天";
			} else if (duration >= DAY * 3) {
				if (formats) {
					value = new Date(timestamp).format(formats);
				} else {
					value = new Date(timestamp).format("MM月dd日");
				}
			} else {
				value = parseInt((duration / DAY)) + "天前";
			}
			
			return value;
		} else {
			return "";
		}
	},
	getDistance: function (lat1, lng1, lat2, lng2) {
		var radLat1, radLat2, a, b, s, 
			EARTH_RADIUS = 6378.137; //地球半径
			rad = function (d) {
				return d * Math.PI / 180.0;
			};
		
		radLat1 = rad(lat1);
		radLat2 = rad(lat2);
		a = radLat1 - radLat2;
		b = rad(lng1) - rad(lng2);
		s = 2 * Math.asin(Math.sqrt(Math.pow(Math.sin(a / 2),2) +
			Math.cos(radLat1) * Math.cos(radLat2) * Math.pow(Math.sin(b / 2), 2)));
		s = s * EARTH_RADIUS;
		s = Math.round(s * 10000) / 10000 * 1000; // 输入为米
		
		return s;
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
	// 处理APP回传的参数，并设置到全局data中
	setData: function (pramas) {
		if (!window.data) {
			window.data = {};
		}
		if (pramas && pramas != null && pramas != "") {
			var urlparams = pramas.split("&");
			for (var i = 0; i < urlparams.length; i++) {
				var urlparam = urlparams[i].split("=");
				window.data[''+ urlparam[0] +''] = urlparam[1];
			}
		}
	},
	// 设置APP回传日期
	setInputDate: function (selector, date) {
		if (selector && date && selector != "") {
			$(selector).find(".value").val(date);
			$(selector).find(".txt").html(date);
		}
	},
	// 设置APP回传时间
	setInputTime: function (selector, time) {
		if (selector && time && selector != "") {
			$(selector).find(".value").val(time);
			$(selector).find(".txt").html(time);
		}
	},
	formValidateEmpty: function () {
		var isEmptyInput = false;
		$(".eoa-form .required input, .eoa-form .required select, .eoa-form .required textarea").each(function () {
			if ($(this).val() == "" || $(this).val() == "[]") {
				$(this).parents("li").addClass("error");
				isEmptyInput = true;
				if ($(this).parents("li").find(".label").size() > 0) {
					alert($(this).parents("li").find(".label").text().toString().split("：")[0] +"不能为空");
				} else {
					alert($(this).parents("li").data("label") +"不能为空");
				}
				return false;
			}
		});
		
		$(".error").unbind("click");
		$(".error").click(function () {
			if ($(this).hasClass("error")) {
				$(this).removeClass("error");
			}
		});
		
		return isEmptyInput;
	}
};

function setDailyAttach (rs, $target) {
	var html = "";
	if ($target.hasClass("hasAttachment")) {
		$target.find(".attachment").show();
		return false;
	}
	
	if ($(rs).size() > 0) {
		html = "<i>附件：</i>"
		$(rs).each(function () {
			var filesizestr = "0KB";
			if (this.fileSize > 0 && this.fileSize < (1000 * 1000)) {
				filesizestr = (this.fileSize / 1000).toFixed(2) +"KB";
			} else {
				filesizestr = (this.fileSize / (1000 * 1000)).toFixed(2) +"M";
			}
			html += '<li>'+
						'<span data-id="'+ this.id +'" data-name="'+ this.fileName +'" data-size="'+ filesizestr +'" class="doc">'+ this.fileName +'('+ filesizestr +')</span>'+
						'<span data-id="'+ this.id +'" data-name="'+ this.fileName +'" data-size="'+ filesizestr +'" class="download">下载</span>'+
					'</li>'
		});
		
		$target.find(".attachment ol").append(html);
		$target.find(".attachment .doc").click(function () {
			var filePath = app.basePath +"TsysFilesInfo/tsysfilesinfo!download.action?id="+ $(this).data("id"),
				fileSize = $(this).data("size"),
				fileName = $(this).data("name");
				
			if (confirm("是否下载"+fileName+"?如果您使用3G/4G网络，将消耗您"+fileSize+"流量。")) {
                if (window.APP && window.APP.isSupportDownload) {
                    window.APP.download(filePath + "@shownName=" + fileName);
                } else {
                    alert("不支持APP无法下载");
                }
			}
			return false;
		});
		$target.addClass("hasAttachment");
		$target.find(".attachment").show();
	} else {
		$target.find(".attachment").hide();
	}
}

// 工作日志首页
function showDailyIndex (rs) {
	if (rs.success) {
		var html = "";
		if (rs.message.totalCount > 0) {
			$(rs.message.result).each(function () {
				var title, //= this.diaTitle || "", 
					content = "", 
					$content = $("<div>" + this.content + "</div>");
					
				if (!title || title == "") {
					title = '<span class="n">'+ this.userName +'</span> '+ app.formatDate(this.diaDate) +' 的日志<span class="edit" data-id="'+ this.id +'">编辑</span>'
				}
					
				if ($content.find("p").size() > 1 
					|| $content.find("ol > li").size() > 1
					|| $content.find("ul > li").size() > 1) {
					content = $content.html();
				} else {
					content = this.content.replaceAll("\n", "<br class=\"space\"/>");
				}

				html += '<li class="l" data-id="'+ this.id +'" data-attach="'+ this.isAttach +'">'+
							'<div class="side">'+
								'<span>'+ app.getDate(this.diaDate) +'</span>'+
								'<span class="m">'+ app.getUpperMonth(this.diaDate) +'</span>'+
							'</div>'+
							'<div class="content-wrap">'+
								'<div class="content">'+
									'<div class="t">'+ title +'</div>'+
									'<div class="b" data-id="'+ this.id +'">'+
										'<p>'+ content +'</p>'+
									'</div>'+
									'<div class="attachment"><ol></ol></div>'+
									'<ul class="info">'+
										'<li><span class="date">'+ app.getTimeDuration(this.diaDate) +'</span></li>'+
										'<li class="link"><span class="comment" data-id="'+ this.id +'">'+ this.commentCount +'</span></li>'+
									'</ul>'+
								'</div>'+
							'</div>'+
						'</li>';
			});
		} else {
			html = '<li class="nulldata"><p>没有数据。</p></li>'
		}
		
		$(".list").append(html);
		$(".list > li.l").each(function () {
			var $self = $(this), 
				objectId = $(this).data("id"),
				isAttach = $(this).data("attach");
			if (isAttach == "Y") {
				app.loadData(app.basePath + "TsysFilesInfo/tsysfilesinfo!listAllAjax.action", {
					objectId: objectId,
					objectType: "05"
				}, function (rs) {
					setDailyAttach(rs, $self);
				});
			}
		});
		
		
		
		// 如果当前页码小于总页码数时，显示翻页
		if (rs.message.pageNo < rs.message.totalPages) {
			$(".page").show();
			data['page.pageNo'] = parseInt(rs.message.pageNo) + 1;
		} else {
			$(".page").hide();
		}
		
		$(".link .comment, .b").click(function () {
			var diaryId = $(this).data("id") || "";
			if (diaryId != "") {
				window.location.href = "comment.html?diaryId="+ diaryId +"&from=index";
			}
			return false;
		});
		
		$(".t .edit").click(function () {
			var diaryId = $(this).data("id") || "";
			if (diaryId != "") {
				window.location.href = "edit.html?diaryId="+ diaryId +"&option=edit&from=index";
			}
			return false;
		});
	}
}

// 工作日志分享
function showDailyShare (rs) {
	if (rs.success) {
		var html = "";
		if (rs.message.totalCount > 0) {
			$(rs.message.result).each(function () {
				var content = "", $content = $("<div>" + this.content + "</div>");
				if ($content.find("p").size() > 1 
					|| $content.find("ol > li").size() > 1
					|| $content.find("ul > li").size() > 1) {
					content = $content.html();
				} else {
					content = this.content.replaceAll("\n", "<br class=\"space\"/>");
				}
				
				html += '<li class="l" data-id="'+ this.id +'" data-attach="'+ this.isAttach +'">'+
							'<div class="side">'+
								'<span>'+ app.getDate(this.diaDate) +'</span>'+
								'<span class="m">'+ app.getUpperMonth(this.diaDate) +'</span>'+
							'</div>'+
							'<div class="content-wrap">'+
								'<div class="content">'+
									'<div class="t"><span class="n">'+ this.userName +'</span> '+ app.formatDate(this.diaDate) +' 的日志<span class="edit" style="display:none;">.</span></div>'+
									'<div class="b" data-id="'+ this.id +'">'+
										'<p>'+ content +'</p>'+
									'</div>'+
									'<div class="attachment"><ol></ol></div>'+
									'<ul class="info">'+
										'<li><span class="date">'+ app.getTimeDuration(this.diaDate) +'</span></li>'+
										'<li class="link"><span class="comment" data-id="'+ this.id +'">'+ this.commentCount +'</span></li>'+
									'</ul>'+
								'</div>'+
							'</div>'+
						'</li>';
			});
		} else {
			html = '<li class="nulldata"><p>没有数据。</p></li>'
		}
		
		$(".list").append(html);
		$(".list > li.l").each(function () {
			var $self = $(this), 
				objectId = $(this).data("id"),
				isAttach = $(this).data("attach");
			if (isAttach == "Y") {
				app.loadData(app.basePath + "TsysFilesInfo/tsysfilesinfo!listAllAjax.action", {
					objectId: objectId,
					objectType: "05"
				}, function (rs) {
					setDailyAttach(rs, $self);
				});
			}
		});
		
		// 如果当前页码小于总页码数时，显示翻页
		if (rs.message.pageNo < rs.message.totalPages) {
			$(".page").show();
			data['page.pageNo'] = parseInt(rs.message.pageNo) + 1;
		} else {
			$(".page").hide();
		}
		
		$(".link .comment, .b").click(function () {
			var diaryId = $(this).data("id") || "";
			if (diaryId != "") {
				window.location.href = "comment.html?diaryId="+ diaryId +"&from=share";
			}
			return false;
		});
	}
}

// 工作日志评论
function showDailyComment (rs) {
	if (rs.success) {
		var content = "", $content = $("<div>" + rs.message.content + "</div>");
		if ($content.find("p").size() > 1 
			|| $content.find("ol > li").size() > 1
			|| $content.find("ul > li").size() > 1) {
			content = $content.html();
		} else {
			content = rs.message.content.replaceAll("\n", "<br class=\"space\"/>");
		}
				
		var html = '<div class="content">'+
						'<div class="t">'+
							'<span class="n">'+ rs.message.userName +'</span> '+ app.formatDate(rs.message.diaDate)  +' 的日志'+
							'<span class="date">'+ app.getTimeDuration(rs.message.diaDate) +'</span>'+
						'</div>'+
						'<div class="b">'+
							'<p>'+ content +'</p>'+
						'</div>'+
						'<div class="attachment" data-id="'+ rs.message.id +'"><ol></ol></div>'+
					'</div>';
					
		$(".content-wrap").html(html);
		$("#diaryId").val(rs.message.id || "");
		app.loadData(app.basePath + "TsysFilesInfo/tsysfilesinfo!listAllAjax.action", {
			objectId: rs.message.id,
			objectType: "05"
		}, function (rs) {
			setDailyAttach(rs, $(".content"));
		});
		
		var commentHtml = "";
		if (rs.message.commentList && rs.message.commentList.length > 0) {
			$(rs.message.commentList).each(function () {
				var comment = this;
				commentHtml += '<li data-id="'+ this.id +'" data-cer='+ this.commentUserName +'><span class="cer">'+ this.commentUserName +'：</span><span class="b">'+ this.content +'</span></li>';
				if (this.diaryCommentReplyList && this.diaryCommentReplyList.length > 0) {
					$(this.diaryCommentReplyList).each(function () {
						commentHtml += '<li data-id="'+ comment.id +'" data-cer='+ comment.commentUserName +'><span class="reply"><span class="rer">'+ this.replyerName +'</span>回复</span><span class="cer">'+ comment.commentUserName +'：</span><span class="b">'+ this.replyComment +'</span></li>';
					});
				}
			});
			
			
		} else {
			commentHtml = "暂时没有人评论哦。";
		}
		
		$(".comment-list .bd > ul").html('<li class="nulldata">'+ commentHtml +'</li>');
		
		$(".comment-list li").click(function () {
			var cer = $(this).data("cer") || "";
			if (cer && cer != "" && from == "index") {
				$("#commentContent").addClass("reply").attr("placeholder", "回复"+ cer + ":").val("");
				$("#commentId").val($(this).data("id"));
				$(".form").show(100);
			}
			return false;
		});
	}
}

// 工作日志编辑
function showDailyEdit (rs) {
	if (rs.success) {
		var html = '<div class="content">'+
						'<div class="t">'+
							'<span class="n">'+ rs.message.userName +'</span> '+ app.formatDate(rs.message.diaDate)  +' 的日志'+
							'<span class="del" data-id="'+ rs.message.id +'" >删除</span>'+
						'</div>'+
						'<div class="b" style="display:none;">'+
							'<p>'+ (rs.message.content || "") +'</p>'+
						'</div>'+
					'</div>';
					
		$(".content-wrap").html(html);
		$("#diaryId").val(rs.message.id || "");
		$("#diaryContent").val($(".content .b").text());
		$("#diaryContent").focus();
		
		var commentHtml = "";
		if (rs.message.commentList && rs.message.commentList.length > 0) {
			$(rs.message.commentList).each(function () {
				var comment = this;
				commentHtml += '<li data-id="'+ this.id +'" data-cer='+ this.commentUserName +'><span class="cer">'+ this.commentUserName +'：</span><span class="b">'+ this.content +'</span></li>';
				if (this.diaryCommentReplyList && this.diaryCommentReplyList.length > 0) {
					$(this.diaryCommentReplyList).each(function () {
						commentHtml += '<li data-id="'+ comment.id +'" data-cer='+ comment.commentUserName +'><span class="reply"><span class="rer">'+ this.replyerName +'</span>回复</span><span class="cer">'+ comment.commentUserName +'：</span><span class="b">'+ this.replyComment +'</span></li>';
					});
				}
			});
		} else {
			commentHtml = "暂时没有人评论哦。";
		}
		
		$(".comment-list .bd > ul").html('<li class="nulldata">'+ commentHtml +'</li>');
		
		$(".t .del").click(function () {
			if (confirm("确定删除这条日志吗？")) {
				if (isAPP) {
					window.APP.showMask("正在删除...");
				}
				var diaryId = $(this).data("id") || "";
				if (diaryId != "") {
					app.loadData(app.basePath + "TdiaryWorkInfo/tdiaryworkinfo!diaryDeleteAjax.action", {
						"diaryId": diaryId,
					}, function (rs) {
						if (isAPP) {
							window.APP.hideMask();
						}
						if (!rs.success && rs.errorCode == "001") {
							if (isAPP) {
								window.APP.login();
							} else {
								alert(rs.message);
							}
						} else {
							alert("删除成功。")
							if (isAPP) {
								window.APP.finish(true);
							} else {
								window.location.href = "index.html";
							}
						}
					});
				}
			}
			return false;
		});
	}
}

/**
 * 设置定位
 * param: 纬度，经度，半径，省，市，区/县/街道，详细地址
 */
function setLocation (latitude, lontitude, radius, province, city, district, address) {		
console.log("latitude="+latitude+",lontitude="+lontitude+",radius="+radius+",province="+province+",city="+city+",district="+district+",address="+address);
	$(".tips").each(function () {
		var d, isRadius = false, latitude0, lontitude0,
			html = '<font color="#ff9d3f">定位不成功，请刷新</font>',
			radius0 = $(this).data("radius"),
			coordinates = $(this).data("coordinates");
		
		if (coordinates) {
			latitude0 = Number($(this).data("latitude"));
			lontitude0 = Number($(this).data("lontitude"));
			d = app.getDistance (latitude, lontitude, latitude0, lontitude0);

			if (address == "null") {
				address = "经度="+ parseFloat(lontitude.toString()) + ", 纬度=" + parseFloat(latitude.toString());
			}
			console.log("与考勤点距离="+ d);
			if (d <= radius0) {
				isRadius = true;
				html = '已定位在：' + address +'<br/>你在考勤范围内，可正常考勤';
			} else {
				html = '<font color="#ff9d3f">已定位在：'+ address +'<br/>你不在考勤范围内</font>'
			}
			
			$(".btn-txt").data("localLatitude", latitude)
				.data("localLontitude", lontitude)
				.data("isRadius", isRadius);
		}
		
		$("> span", this).html(html);
	});
	
	/*
	// 停止定位
	if (window.APP) {
		window.APP.stopLocation();
	}
	*/
}

function setAttendTime (rs) {
	if (rs.success) {
		var timestamp = typeof rs.message == "number" ? rs.message : (new Date(rs.message)).getTime(),
			curWeek = (new Date(timestamp)).getDay(),
			nowTime = (new Date(timestamp)).format("hh:mm:ss");
		
		// 请求考勤信息
		app.loadData(app.basePath + "TattendanceRecord/tattendancerecord!getInfoAjax.action", "", setAttendInfo, "", nowTime);
		
		// 设置星期
		switch (curWeek) {
			case 0: 
				$(".clock-week span").eq(6).addClass("selected");
				break;
				
			case 1: 
				$(".clock-week span").eq(0).addClass("selected");
				break;
				
			case 2: 
				$(".clock-week span").eq(1).addClass("selected");
				break;
				
			case 3: 
				$(".clock-week span").eq(2).addClass("selected");
				break;
				
			case 4: 
				$(".clock-week span").eq(3).addClass("selected");
				break;
				
			case 5: 
				$(".clock-week span").eq(4).addClass("selected");
				break;
				
			case 6: 
				$(".clock-week span").eq(5).addClass("selected");
				break;
		}
		
		// 设置系统时钟
		setInterval(function () {
			timestamp += 1000;
			$(".clock .time").html((new Date(timestamp)).format("hh:mm:ss"))
		}, 1000);
	}
}

// 设置工作时间进度
function initCanvas (canvas, percent) {
	if (!canvas) return;
	var loop, curPercent = 0,
		w = canvas.width,
		h = canvas.height,
		context = canvas.getContext("2d"),
		init = function () {
			context.clearRect(0, 0, w, h);
			context.fillStyle = 'rgba(223,92,90, 0)';
			context.beginPath();
			context.lineWidth = 6,
			context.strokeStyle = (curPercent < 1) ? "#ff9d3f" : "#74b693";
			context.arc(40,40,36,Math.PI, Math.PI + (Math.PI * 2 * curPercent),false);
			context.fill();
			context.stroke();
			context.closePath();
		},
		draw = function () {
			if (curPercent.toFixed(5) > percent || curPercent > 1) {
				clearInterval(loop);
			} else {
				if (curPercent > 0.8) {
					curPercent += 1 / 300;
				} else {
					curPercent += 1 / 10;
				}
			}
			//console.log(curPercent.toFixed(5))
			//console.log(percent)
			init();
		}
		
	if(typeof loop != undefined) clearInterval(loop);
	if (percent >= 1) {
		curPercent = 1;
		draw();
	} else {
		loop = setInterval(draw, 100);
	}
}

function setAttendInfo (rs, nowTime) {
	if (rs.success) {
		var html = "",
			isStartLocation = true;
			
		if ($(rs.message.tattendanceGroup).size() > 0) {
			$(rs.message.tattendanceGroup).each(function (index) {
				var wz = rs.message.tattendancePoints.coordinates.split(",")
					latitude = wz[1], 
					lontitude = wz[0], 
					isGoSelectedClass = this.goToWorkTime ? "selected" : "",
					isGoSelectedTxt = this.goToWorkTime ? "已考勤" : "上&nbsp;&nbsp;&nbsp;&nbsp;班",
					isOffSelectedClass = this.afterWorkTime ? "selected" : "",
					isOffSelectedTxt = this.afterWorkTime ? "已考勤" : "下&nbsp;&nbsp;&nbsp;&nbsp;班",
					timestampDurationGo = new Date("1970-1-1 "+ this.goToWork).getTime(),
					timestampDurationOff = new Date("1970-1-1 "+ this.afterWork).getTime(),
					timestampDurationTotal = timestampDurationOff - timestampDurationGo;
						
				html += '<li>'+
							'<div class="times">考勤时间段：'+ this.goToWork +' ~ '+ this.afterWork +'</div>'+
							'<div class="operate">'+
								'<span class="btn go '+ isGoSelectedClass +'"><a href="javascript:void(0)" class="btn-txt" data-timestampDurationGo="'+ timestampDurationGo +'" data-order="'+ index +'1" data-latitude="'+ latitude +'" data-lontitude="'+ lontitude +'" data-radius="'+ rs.message.tattendancePoints.range +'">'+ isGoSelectedTxt +'</a></span>'+
								'<span class="btn off '+ isOffSelectedClass +'"><a href="javascript:void(0)" class="btn-txt" data-timestampDurationOff="'+ timestampDurationOff +'" data-order="'+ index +'2" data-latitude="'+ latitude +'" data-lontitude="'+ lontitude +'" data-radius="'+ rs.message.tattendancePoints.range +'">'+ isOffSelectedTxt +'</a></span>'+
								'<div class="progress-wrap">'+
									'<div class="progress-bar"></div>'+
								'</div>'+
								'<canvas id="circle'+ index +'" data-go="'+ timestampDurationGo +'" data-total="'+ timestampDurationTotal +'" width="82" height="82"></canvas>'+
							'</div>'+
							'<div class="tips" data-latitude="'+ latitude +'" data-lontitude="'+ lontitude +'" data-radius="'+ rs.message.tattendancePoints.range +'" data-coordinates="'+ rs.message.tattendancePoints.coordinates +'">'+
								'<em class="arr"></em>'+
								'<span><font color="#ff9d3f">正在进行定位。。。</font></span>'+
							'</div>'+
						'</li>';
			});
			
			$(".help").show();
		} else {
			html = '<div class="nullattend"><div class="descr">咩哈哈哈哈，今日不用考勤，可以睡懒觉!<span class="arr"></span></div></div>';
			isStartLocation = false;
		}
		
		$(".attend-list ul").html(html);
		$(".progress-wrap, .operate canvas").css("left", $("#pageindex").width() / 2 
			- $(".progress-wrap").width());
		$(".tips .arr").css("left", $(".tips").width() / 2 - 5);
		
		// 进入页面开始定位
		if (window.APP && isStartLocation) {
			window.APP.startLocation();
		}
		// 点击定位图标 开始定位
		$("canvas").click(function () {
			$(".tips >span").html('<font color="#ff9d3f">正在进行定位。。。</font>');
			if (window.APP) {
				window.APP.startLocation();
			}
		});
		
		// 设置时间进度
		$("canvas").each(function (i) {
			var percent = 0, 
				nowTimestamp = (new Date("1970-1-1 "+ nowTime)).getTime(),
				goTimestamp = parseFloat($(this).data("go")),
				totalTimestamp = parseFloat($(this).data("total"));

			if ((nowTimestamp - goTimestamp) > 0) {
				// 延迟一秒设置时间进度 进度条每次增加的毫秒数可能会超过100%
				percent = (nowTimestamp - goTimestamp - 60000) / totalTimestamp;
				console.log("percent="+percent.toFixed(5))
				initCanvas($(this)[0], percent.toFixed(5));
			}
		});
		
		//console.log(app.getDistance (28.683437, 115.918858, 27.595357, 113.744961))
		
		// 绑定考勤按钮事件
		$(".btn-txt").click(function () {
			var timestamp = (new Date()).getTime(),
				curtime = (new Date()).format("hh:mm:ss"),
				timestampCurrent = new Date("1970-1-1 "+ curtime).getTime(),
				timestampDurationGo = $(this).data("timestampdurationgo"),
				timestampDurationOff = $(this).data("timestampdurationoff"),
				localLatitude = Number($(this).data("localLatitude")),
				localLontitude = Number($(this).data("localLontitude")),
				aLatitude = Number($(this).data("latitude")),
				aLontitude = Number($(this).data("lontitude")),
				isRadius = $(this).data("isRadius"), // 是否在考勤范围
				aOrder = $(this).data("order"),
				isSelected = $(this).parent().hasClass("selected"), // 是否已考勤
				isGo = parseInt(aOrder) % 2 == 0 ? false : true, // 是否为上班
				wz = localLontitude + "," + localLatitude,
				isException = false,
				confirmMessage = "";
			
			console.log(timestamp+"|"+localLatitude+"|"+localLontitude+"|"+isRadius+"|"+aOrder)
			if (isRadius == "undefined") {
				alert("定位不完全，请刷新考勤首页面。");
				return false;
			}
			
			// 不在考勤范围
			if (!isRadius && !isSelected) {
				isException = true;
				confirmMessage += "不在考勤范围\n";
			}

			// 上班迟到
			if (isGo && !isSelected && timestampCurrent > timestampDurationGo) {
				isException = true;
				confirmMessage += "上班迟到了\n";
			}
			
			// 下班早退
			if (!isGo && !isSelected && timestampCurrent < timestampDurationOff) {
				isException = true;
				confirmMessage += "还未到下班时间\n";
			}
			
			if (!isException && !isSelected) {
				saveAttend(isRadius, wz, aOrder, "");
			} else if (isSelected) {
				if (confirm("你已考勤\n\n是否继续？")) {
					saveAttend(isRadius, wz, aOrder, "");
				}
			}else {
				if (confirm(confirmMessage + "\n是否继续？")) {
					window.location.href = "exception.html?isRadius="+ isRadius +"&wz="+ wz +"&aOrder=" + aOrder;
					console.log("exception.html?isRadius="+ isRadius +"&wz="+ wz +"&aOrder="+ aOrder)
				}
			}
		});
	}
}

// 提交考勤数据
function saveAttend (isRadius, wz, aOrder, ms) {
	console.log("isRadius="+isRadius+"|wz="+wz+"|aOrder="+aOrder+"|ms="+ms);
	if (window.APP) {
		window.APP.showMask("正在提交，请稍后。");
	}

	app.loadData(app.basePath + "TattendanceRecord/tattendancerecord!saveObjAjax.action", {
		isOk: (isRadius == true ? 1 : 0),
		wz: wz, 
		lx: aOrder,
		ms: ms
	}, function (rs) {
		if (!rs.success && rs.errorCode == "001") {
			if (window.APP) {
				window.APP.login();
			} else {
				alert(rs.message);
			}
		} else {
			if (rs.success) {
				if (window.APP) {
					window.APP.hideMask();
				}
				alert("考勤结果已提交");
				if (ms != "" && window.APP) {
					window.APP.finish(true);
				} else {
					window.location.reload();
				}
			}
		}
	});
}

// 我的考勤记录
function setMyAttend (rs) {
	if (rs.success) {
		var html = "";
			
		if (rs.message.totalCount > 0) {
			$(rs.message.result).each(function () {
				var groupHtml = "",
					isGroup1 = (this.goToWork1 == undefined) ? false : true,
					isGroup2 = (this.goToWork2 == undefined) ? false : true,
					isGroup3 = (this.goToWork3 == undefined) ? false : true
					bubbleClass = this.workstatusString == "正常" ? "" : "red",
					bubbleTxt = this.workstatusString == "正常" ? "正常" : "异常";
				
				for (var i = 1; i < 4; i++) {
					if (eval("isGroup"+i)) {
						groupHtml += '<ol>'+
										'<li>考勤时间段：'+ eval("this.goToWork" + i) +' ~ '+ eval("this.afterWork" + i) +'</li>'+
										'<li>上班：'+ eval("this.goToWorkTime" + i) +'&nbsp;&nbsp;'+ eval("this.goToWorkReason" + i + "|| ''") +'</li>'+
										'<li>下班：'+ eval("this.afterWorkTime" + i) +'&nbsp;&nbsp;'+ eval("this.afterWorkReason" + i+ "|| ''") +'</li>'+
									'</ol>';
					}
				}

				html += '<li>'+
							'<a href="javascript:void(0)" class="t">'+ (this.workday || "") +' 考勤状态</a>'+
							'<span class="bubble '+ bubbleClass +'">'+ bubbleTxt +'</span>'+
							'<span class="arr">+</span>'+
							'<div class="detail">'+
								'<span class="arrow"></span>'+groupHtml+
							'</div>'+
						'</li>';
			});

		} else {
			html = '<li class="nulldata"><p>没有数据。</p></li>'
		}
		
		$(".myattend-list > ul").append(html);
		
		
		// 如果当前页码小于总页码数时，显示翻页
		if (rs.message.pageNo < rs.message.totalPages) {
			$(".page").show();
			data['page.pageNo'] = parseInt(rs.message.pageNo) + 1;
		} else {
			$(".page").hide();
		}
		
		$(".myattend-list .t").unbind();
		$(".myattend-list .t").click(function () {
			var $self = $(this).parent();
			if ($self.hasClass("selected")) {
				$self.removeClass("selected");
				$(".arr", $self).html("+");
				$(".detail", $self).slideUp(10);
			} else {
				$self.addClass("selected");
				$(".arr", $self).html("-");
				$(".detail", $self).slideDown(100);
			}
			
			return false;
		});
		$(".myattend-list .t:first").trigger("click");
		
		$(".bubble.red").click(function () {
			// TODO 提交进行审核
		});
	}
}

// 我的请假记录
function setMyLeave (rs) {
	if (rs.success) {
		var html = "";
			
		if (rs.message.totalCount > 0) {
			$(rs.message.result).each(function () {
				var groupHtml = "",
					bubbleClass = this.dostatus == "01" ? "red" : "";
					
				html += '<li>'+
							'<a href="javascript:void(0)" class="t">'+ 
								'<h3>'+ (this.leaveType || "") +'</h3>'+
								'<P>'+ (app.cutstr(this.reason, 20) || "") +'</p>'+
							'</a>'+
							'<span class="bubble '+ bubbleClass +'">'+ (this.dostatusString || "") +'</span>'+
							'<span class="arr">+</span>'+
							'<div class="detail">'+
								'<span class="arrow"></span>'+
								'<ol>'+
									'<li>请假时间：'+ this.startdateString +' '+ this.starttime +' 至 '+ this.enddateString +' '+ this.endtime +'</li>'+
									'<li>请假天数：'+ this.leaveDays +'天</li>'+
									'<li>请假类型：'+ this.leaveType +'</li>'+
									'<li>请假原因：'+ this.reason +'</li>'+
								'</ol>'+
							'</div>'+
						'</li>';
			});

		} else {
			html = '<li class="nulldata"><p>没有数据。</p></li>'
		}
		
		$(".myattend-list > ul").append(html);
		
		
		// 如果当前页码小于总页码数时，显示翻页
		if (rs.message.pageNo < rs.message.totalPages) {
			$(".page").show();
			data['page.pageNo'] = parseInt(rs.message.pageNo) + 1;
		} else {
			$(".page").hide();
		}
		
		$(".myattend-list .t").not(".add").unbind();
		$(".myattend-list .t").not(".add").click(function () {
			var $self = $(this).parent();
			if ($self.hasClass("selected")) {
				$self.removeClass("selected");
				$(".arr", $self).html("+");
				$(".detail", $self).slideUp(10);
			} else {
				$self.addClass("selected");
				$(".arr", $self).html("-");
				$(".detail", $self).slideDown(100);
			}
			
			return false;
		});
		
		$(".bubble.red").click(function () {
			// TODO 提交进行审核
		});
	}
}

// 请假审批
function setApproveLeave (rs) {
	if (rs.success) {
		var html = "";
			
		if (rs.message.totalCount > 0) {
			$(rs.message.result).each(function () {
				var groupHtml = "",
					bubbleClass = this.dostatus == "01" ? "red" : "";
					
				html += '<li>'+
							'<a href="javascript:void(0)" class="t">'+ 
								'<h3>'+  (this.applicantuserString || "") +"申请"+ (this.leaveType || "") +'</h3>'+
								'<P>'+ (app.cutstr(this.reason, 20) || "") +'</p>'+
							'</a>'+
							'<span class="bubble '+ bubbleClass +'" data-businesscode="" data-businessid="'+ this.id +'" data-nodeid="'+ this.machStatus +'">处理</span>'+
							'<span class="arr">+</span>'+
							'<div class="detail">'+
								'<span class="arrow"></span>'+
								'<ol>'+
									'<li>&nbsp;&nbsp;&nbsp;&nbsp;申请人：'+ this.applicantuserString +'</li>'+
									'<li>申请时间：'+ app.getTimeDuration(this.applicanttime) +'</li>'+
									'<li>请假时间：'+ this.startdateString +' '+ this.starttime +' 至 '+ this.enddateString +' '+ this.endtime +'</li>'+
									'<li>请假天数：'+ this.leaveDays +'天</li>'+
									'<li>请假类型：'+ this.leaveType +'</li>'+
									'<li>请假原因：'+ this.reason +'</li>'+
								'</ol>'+
							'</div>'+
						'</li>';
			});

		} else {
			html = '<li class="nulldata"><p>没有数据。</p></li>'
		}
		
		$(".myattend-list > ul").append(html);
		
		
		// 如果当前页码小于总页码数时，显示翻页
		if (rs.message.pageNo < rs.message.totalPages) {
			$(".page").show();
			data['page.pageNo'] = parseInt(rs.message.pageNo) + 1;
		} else {
			$(".page").hide();
		}
		
		$(".myattend-list .t").not(".add").unbind();
		$(".myattend-list .t").not(".add").click(function () {
			var $self = $(this).parent();
			if ($self.hasClass("selected")) {
				$self.removeClass("selected");
				$(".arr", $self).html("+");
				$(".detail", $self).slideUp(10);
			} else {
				$self.addClass("selected");
				$(".arr", $self).html("-");
				$(".detail", $self).slideDown(100);
			}
			
			return false;
		});
		
		$(".bubble.red").click(function () {
			var action = "TattendanceLeave/tattendanceleave",
				businessCode = $(this).data("businesscode"),
				businessId = $(this).data("businessid"),
				nodeId = $(this).data("nodeid");
				
			window.location.href = "../statemach/index.html?action="+ action +"&businessCode="+ businessCode +"&businessId="+ businessId +"&nodeId=" + nodeId;
		});
	}
}


// 我的出差记录
function setMyAway (rs) {
	if (rs.success) {
		var html = "";
			
		if (rs.message.totalCount > 0) {
			$(rs.message.result).each(function () {
				var groupHtml = "",
					bubbleClass = this.dostatus == "01" ? "red" : "";
					
				html += '<li>'+
							'<a href="javascript:void(0)" class="t">'+ 
								'<h3>'+ this.provenance +' - '+ this.destination + '</h3>'+
								'<P>'+ (app.cutstr(this.reason, 20) || "") +'</p>'+
							'</a>'+
							'<span class="bubble '+ bubbleClass +'">'+ (this.dostatusString || "") +'</span>'+
							'<span class="arr">+</span>'+
							'<div class="detail">'+
								'<span class="arrow"></span>'+
								'<ol>'+
									'<li>出差地点：'+ this.provenance +' 至 '+ this.destination +'</li>'+
									'<li>出差日期：'+ this.startdateString +'至'+ this.enddateString +'</li>'+
									'<li>出差原因：'+ (this.reason || "")+'</li>'+
								'</ol>'+
							'</div>'+
						'</li>';
			});

		} else {
			html = '<li class="nulldata"><p>没有数据。</p></li>'
		}
		
		$(".myattend-list > ul").append(html);
		
		
		// 如果当前页码小于总页码数时，显示翻页
		if (rs.message.pageNo < rs.message.totalPages) {
			$(".page").show();
			data['page.pageNo'] = parseInt(rs.message.pageNo) + 1;
		} else {
			$(".page").hide();
		}
		
		$(".myattend-list .t").not(".add").unbind();
		$(".myattend-list .t").not(".add").click(function () {
			var $self = $(this).parent();
			if ($self.hasClass("selected")) {
				$self.removeClass("selected");
				$(".arr", $self).html("+");
				$(".detail", $self).slideUp(10);
			} else {
				$self.addClass("selected");
				$(".arr", $self).html("-");
				$(".detail", $self).slideDown(100);
			}
			
			return false;
		});
		//$(".myattend-list .t:first").trigger("click");
	}
}

// 出差审批
function setApproveAway (rs) {
	if (rs.success) {
		var html = "";
			
		if (rs.message.totalCount > 0) {
			$(rs.message.result).each(function () {
				var groupHtml = "",
					bubbleClass = this.dostatus == "01" ? "red" : "";
					
				html += '<li>'+
							'<a href="javascript:void(0)" class="t">'+ 
								'<h3>'+ this.applicantuserString +'， '+ this.provenance +' - '+ this.destination + '</h3>'+
								'<P>'+ (app.cutstr(this.reason, 20) || "") +'</p>'+
							'</a>'+
							'<span class="bubble '+ bubbleClass +'" data-businesscode="" data-businessid="'+ this.id +'" data-nodeid="'+ this.machStatus +'">处理</span>'+
							'<span class="arr">+</span>'+
							'<div class="detail">'+
								'<span class="arrow"></span>'+
								'<ol>'+
									'<li>&nbsp;&nbsp;&nbsp;&nbsp;申请人：'+ this.applicantuserString +'</li>'+
									'<li>申请时间：'+ this.applicanttimeString +'</li>'+
									'<li>出差地点：'+ this.provenance +' 至 '+ this.destination +'</li>'+
									'<li>出差日期：'+ this.startdateString +' 至 '+ this.enddateString +'</li>'+
									'<li>出差原因：'+ (this.reason || "")+'</li>'+
								'</ol>'+
							'</div>'+
						'</li>';
			});

		} else {
			html = '<li class="nulldata"><p>没有数据。</p></li>'
		}
		
		$(".myattend-list > ul").append(html);
		
		
		// 如果当前页码小于总页码数时，显示翻页
		if (rs.message.pageNo < rs.message.totalPages) {
			$(".page").show();
			data['page.pageNo'] = parseInt(rs.message.pageNo) + 1;
		} else {
			$(".page").hide();
		}
		
		$(".myattend-list .t").not(".add").unbind();
		$(".myattend-list .t").not(".add").click(function () {
			var $self = $(this).parent();
			if ($self.hasClass("selected")) {
				$self.removeClass("selected");
				$(".arr", $self).html("+");
				$(".detail", $self).slideUp(10);
			} else {
				$self.addClass("selected");
				$(".arr", $self).html("-");
				$(".detail", $self).slideDown(100);
			}
			
			return false;
		});
		
		$(".bubble.red").click(function () {
			var action = "TattendanceTrip/tattendancetrip",
				businessCode = $(this).data("businesscode"),
				businessId = $(this).data("businessid"),
				nodeId = $(this).data("nodeid");
				
			window.location.href = "../statemach/index.html?action="+ action +"&businessCode="+ businessCode +"&businessId="+ businessId +"&nodeId=" + nodeId;
		});
	}
}


// 我的加班记录
function setMyOver (rs) {
	if (rs.success) {
		var html = "";
			
		if (rs.message.totalCount > 0) {
			$(rs.message.result).each(function () {
				var groupHtml = "",
					bubbleClass = this.dostatus == "01" ? "red" : "";
					
				html += '<li>'+
							'<a href="javascript:void(0)" class="t">'+ 
								'<h3>'+ this.startdateString +' '+ this.starttime +' 至 '+ this.enddateString +' '+ this.endtime + '</h3>'+
								'<P>'+ (app.cutstr(this.overtimeReason, 20) || "") +'</p>'+
							'</a>'+
							'<span class="bubble '+ bubbleClass +'">'+ (this.dostatusString || "") +'</span>'+
							'<span class="arr">+</span>'+
							'<div class="detail">'+
								'<span class="arrow"></span>'+
								'<ol>'+
									'<li>加班时间：'+ this.startdateString +' '+ this.starttime +' 至 '+ this.enddateString +' '+ this.endtime +'</li>'+
									'<li>加班时长：'+ this.overtimeHours +'小时</li>'+
									'<li>加班原因：'+ (this.overtimeReason || "")+'</li>'+
								'</ol>'+
							'</div>'+
						'</li>';
			});

		} else {
			html = '<li class="nulldata"><p>没有数据。</p></li>'
		}
		
		$(".myattend-list > ul").append(html);
		
		
		// 如果当前页码小于总页码数时，显示翻页
		if (rs.message.pageNo < rs.message.totalPages) {
			$(".page").show();
			data['page.pageNo'] = parseInt(rs.message.pageNo) + 1;
		} else {
			$(".page").hide();
		}
		
		$(".myattend-list .t").not(".add").unbind();
		$(".myattend-list .t").not(".add").click(function () {
			var $self = $(this).parent();
			if ($self.hasClass("selected")) {
				$self.removeClass("selected");
				$(".arr", $self).html("+");
				$(".detail", $self).slideUp(10);
			} else {
				$self.addClass("selected");
				$(".arr", $self).html("-");
				$(".detail", $self).slideDown(100);
			}
			
			return false;
		});
		//$(".myattend-list .t:first").trigger("click");
	}
}

// 加班审批
function setApproveOver (rs) {
	if (rs.success) {
		var html = "";
			
		if (rs.message.totalCount > 0) {
			$(rs.message.result).each(function () {
				var groupHtml = "",
					bubbleClass = this.dostatus == "01" ? "red" : "";
					
				html += '<li>'+
							'<a href="javascript:void(0)" class="t">'+ 
								'<h3>'+ this.applicantuserString + '申请加班'+ this.overtimeHours +'小时</h3>'+
								'<P>'+ (app.cutstr(this.overtimeReason, 20) || "") +'</p>'+
							'</a>'+
							'<span class="bubble '+ bubbleClass +'" data-businesscode="" data-businessid="'+ this.id +'" data-nodeid="'+ this.machStatus +'">处理</span>'+
							'<span class="arr">+</span>'+
							'<div class="detail">'+
								'<span class="arrow"></span>'+
								'<ol>'+
									'<li>&nbsp;&nbsp;&nbsp;&nbsp;申请人：'+ this.applicantuserString+'</li>'+
									'<li>申请时间：'+ this.applicanttimeString+'</li>'+
									'<li>加班时间：'+ this.startdateString +' '+ this.starttime +' 至 '+ this.enddateString +' '+ this.endtime +'</li>'+
									'<li>加班时长：'+ this.overtimeHours +'小时</li>'+
									'<li>加班原因：'+ (this.overtimeReason || "")+'</li>'+
								'</ol>'+
							'</div>'+
						'</li>';
			});

		} else {
			html = '<li class="nulldata"><p>没有数据。</p></li>'
		}
		
		$(".myattend-list > ul").append(html);
		
		
		// 如果当前页码小于总页码数时，显示翻页
		if (rs.message.pageNo < rs.message.totalPages) {
			$(".page").show();
			data['page.pageNo'] = parseInt(rs.message.pageNo) + 1;
		} else {
			$(".page").hide();
		}
		
		$(".myattend-list .t").not(".add").unbind();
		$(".myattend-list .t").not(".add").click(function () {
			var $self = $(this).parent();
			if ($self.hasClass("selected")) {
				$self.removeClass("selected");
				$(".arr", $self).html("+");
				$(".detail", $self).slideUp(10);
			} else {
				$self.addClass("selected");
				$(".arr", $self).html("-");
				$(".detail", $self).slideDown(100);
			}
			
			return false;
		});
		
		$(".bubble.red").click(function () {
			var action = "TattendanceOvertime/tattendanceovertime",
				businessCode = $(this).data("businesscode"),
				businessId = $(this).data("businessid"),
				nodeId = $(this).data("nodeid");
				
			window.location.href = "../statemach/index.html?action="+ action +"&businessCode="+ businessCode +"&businessId="+ businessId +"&nodeId=" + nodeId;
		});
	}
}

// 我的外出记录
function setMyOut (rs) {
	if (rs.success) {
		var html = "";
			
		if (rs.message.totalCount > 0) {
			$(rs.message.result).each(function () {
				var groupHtml = "",
					bubbleClass = this.dostatus == "01" ? "red" : "";
					
				html += '<li>'+
							'<a href="javascript:void(0)" class="t">'+ 
								'<h3>'+ this.outdateString +' '+ this.startdateString +' 至 '+ this.enddateString + '</h3>'+
								'<P>'+ (app.cutstr(this.content, 20) || "") +'</p>'+
							'</a>'+
							'<span class="bubble '+ bubbleClass +'">'+ (this.dostatusString || "") +'</span>'+
							'<span class="arr">+</span>'+
							'<div class="detail">'+
								'<span class="arrow"></span>'+
								'<ol>'+
									'<li>外出时间：'+ this.outdateString +' '+ this.startdateString +' 至 '+ this.enddateString +'</li>'+
									'<li>外出原因：'+ (this.content || "")+'</li>'+
								'</ol>'+
							'</div>'+
						'</li>';
			});

		} else {
			html = '<li class="nulldata"><p>没有数据。</p></li>'
		}
		
		$(".myattend-list > ul").append(html);
		
		
		// 如果当前页码小于总页码数时，显示翻页
		if (rs.message.pageNo < rs.message.totalPages) {
			$(".page").show();
			data['page.pageNo'] = parseInt(rs.message.pageNo) + 1;
		} else {
			$(".page").hide();
		}
		
		$(".myattend-list .t").not(".add").unbind();
		$(".myattend-list .t").not(".add").click(function () {
			var $self = $(this).parent();
			if ($self.hasClass("selected")) {
				$self.removeClass("selected");
				$(".arr", $self).html("+");
				$(".detail", $self).slideUp(10);
			} else {
				$self.addClass("selected");
				$(".arr", $self).html("-");
				$(".detail", $self).slideDown(100);
			}
			
			return false;
		});
		//$(".myattend-list .t:first").trigger("click");
	}
}

// 外出审批
function setApproveOut (rs) {
	if (rs.success) {
		var html = "";
			
		if (rs.message.totalCount > 0) {
			$(rs.message.result).each(function () {
				var groupHtml = "",
					bubbleClass = this.dostatus == "01" ? "red" : "";
					
				html += '<li>'+
							'<a href="javascript:void(0)" class="t">'+ 
								'<h3>'+ this.applicantuserString +'申请外出</h3>'+
								'<P>'+ (app.cutstr(this.content, 20) || "") +'</p>'+
							'</a>'+
							'<span class="bubble '+ bubbleClass +'" data-businesscode="" data-businessid="'+ this.id +'" data-nodeid="'+ this.machStatus +'">处理</span>'+
							'<span class="arr">+</span>'+
							'<div class="detail">'+
								'<span class="arrow"></span>'+
								'<ol>'+
									'<li>&nbsp;&nbsp;&nbsp;&nbsp;申请人：'+ this.applicantuserString +'</li>'+
									'<li>申请时间：'+ this.applicanttimeString +'</li>'+
									'<li>外出时间：'+ this.outdateString +' '+ this.startdateString +' 至 '+ this.enddateString +'</li>'+
									'<li>外出原因：'+ (this.content || "")+'</li>'+
								'</ol>'+
							'</div>'+
						'</li>';
			});

		} else {
			html = '<li class="nulldata"><p>没有数据。</p></li>'
		}
		
		$(".myattend-list > ul").append(html);
		
		
		// 如果当前页码小于总页码数时，显示翻页
		if (rs.message.pageNo < rs.message.totalPages) {
			$(".page").show();
			data['page.pageNo'] = parseInt(rs.message.pageNo) + 1;
		} else {
			$(".page").hide();
		}
		
		$(".myattend-list .t").not(".add").unbind();
		$(".myattend-list .t").not(".add").click(function () {
			var $self = $(this).parent();
			if ($self.hasClass("selected")) {
				$self.removeClass("selected");
				$(".arr", $self).html("+");
				$(".detail", $self).slideUp(10);
			} else {
				$self.addClass("selected");
				$(".arr", $self).html("-");
				$(".detail", $self).slideDown(100);
			}
			
			return false;
		});
		
		$(".bubble.red").click(function () {
			var action = "TattendanceOut/tattendanceout",
				businessCode = $(this).data("businesscode"),
				businessId = $(this).data("businessid"),
				nodeId = $(this).data("nodeid");
				
			window.location.href = "../statemach/index.html?action="+ action +"&businessCode="+ businessCode +"&businessId="+ businessId +"&nodeId=" + nodeId;
		});
	}
}

function doProcess (action, businessCode, businessId) {
	app.loadData(app.basePath + action +"!startProcessAjax.action", {
		businessCode: businessCode,
		businessId: businessId
	}, function (rs) {
		if (rs.success) {
			window.location.href = "../statemach/index.html?cleartop=true&action="+ action +"&businessCode="+ businessCode +"&businessId="+ businessId +"&nodeId=" + rs.message;
		} else {
			alert(rs.message);
		}
	});
}

// 收件箱
function setInbox (rs) {
	var setEidtMode = function (isEdit) {
			if (isEdit) {
				$(".eoa-data-list > ul > li").addClass("edit");
				$(".eoa-data-list .edit").unbind().click(function (e) {
					var $cb = $(".check", this);
					if ($cb.hasClass("checked")) {
						$cb.removeClass("checked");
					} else {
						$cb.addClass("checked");
					}
					$(".s-num").html($(".eoa-data-list .checked").size());
					return false;
				});
				
				$(".data-bar .edit").hide(0);
				$(".data-bar .selectall").show();
				$(".data-bar .readed").show();
				$(".data-bar .readed").unbind().click(setToReaded);
				$(".data-bar .forward").show();
				$(".data-bar .send").show();
				$(".data-bar .resend").show();
				$(".data-bar .cancel").show();
				$(".data-bar .cancel").unbind().click(function () {
					setEidtMode(false);
				});
				$(".data-bar .recycle").show();
				$(".data-bar .recycle").unbind().click(function () {
					var type = $(this).data("type") || "01";
					setToRecycle(type);
				});
				$(".data-bar .delete").show();
				$(".data-bar .delete").unbind().click(setToDelete);
				$(".data-bar .menu").hide();
				$(".data-bar .selectall").unbind().click(function () {
					var $all = $(".eoa-data-list .check");
					if ($(this).hasClass("selectalled")) {
						$(this).removeClass("selectalled");
						$all.removeClass("checked");
					} else {
						$(this).addClass("selectalled");
						$all.addClass("checked");
					}

					$(".s-num").html($(".eoa-data-list .checked").size());
					return false;
				});
				
			} else {
				$(".eoa-data-list .edit").removeClass("edit").unbind();
				$(".eoa-data-list .checked").removeClass("checked");
				
				$(".data-bar .edit").show(0);
				$(".data-bar .menu").show();
				$(".data-bar .selectall").hide();
				$(".data-bar .readed").hide();
				$(".data-bar .readed").unbind();
				$(".data-bar .forward").hide();
				$(".data-bar .send").hide();
				$(".data-bar .resend").hide();
				$(".data-bar .delete").hide();
				$(".data-bar .cancel").hide();
				$(".data-bar .recycle").hide();
				$(".data-bar .selectalled").removeClass("selectalled");
				
				$(".s-num").html(0);
			}
		}
	
	if (rs.success) {
		var html = "";
			
		if (rs.message.totalCount > 0) {
			$(rs.message.result).each(function () {
				var isReadStyle = this.isRead == "Y" ? "none" : "inline-block",
					isImportantStyle = this.important == "01" ? "none" : "inline-block",
					isAttachStyle = this.isAttachment == "Y" ? "inline-block" : "none";
					
				html += '<li>'+
							'<a href="detail.html?emailId='+ this.id +'" data-id="'+ this.id +'" class="t">'+
								'<h3>'+ this.fromName +'<span class="important" style="display:'+ isImportantStyle +'"></span><span class="attach" style="display:'+ isAttachStyle +'"></span></h3>'+
								'<P>'+ (this.emailTitle || "") +'</p>'+
							'</a>'+
							'<span class="read-status" style="display:'+ isReadStyle +'">•</span>'+
							'<span class="date">'+ app.getTimeDuration(this.sendTime, "yyyy-MM-dd") +'</span>'+
							'<span class="check" data-id="'+ this.id +'"></span>'+
						'</li>';
			});

		} else {
			html = '<li class="nulldata"><p>没有数据。</p></li>'
		}
		
		$(".eoa-data-list > ul").append(html);
		
		// 如果当前页码小于总页码数时，显示翻页
		if (rs.message.pageNo < rs.message.totalPages) {
			$(".page").show();
			data['page.pageNo'] = parseInt(rs.message.pageNo) + 1;
		} else {
			$(".page").hide();
		}
		
		$(".data-bar .edit").unbind("click");
		$(".data-bar .edit").click(function () {
			setEidtMode(true);
		});
		$(".data-bar .menu").unbind().click(function () {
			window.location.href="./function.html";
		});
	}
}

function setToReaded () {
	var ids = "", $cb = $(".eoa-data-list .checked");
	if ($cb.size() <= 0) {
		alert("请选择一条邮件记录");
	} else {
		$cb.each(function () {
			ids += $(this).data("id") + ",";
		});
		if (ids.length > 0) {
			app.loadData(app.basePath + "TemailBody/temailbody!confirmReadAjax.action", {
				emailIds: ids
			}, function (rs) {
				setResult(rs, function (rs) {
					if (rs.success) {
						alert("设置成功。");
						window.location.reload();
					}
				});
			});
		}
	}
}

function setToRecycle (type) {
	var ids = "", $cb = $(".eoa-data-list .checked");
	if ($cb.size() <= 0) {
		alert("请选择一条邮件记录");
	} else {
		$cb.each(function () {
			ids += $(this).data("id") + ",";
		});
		if (ids.length > 0) {
			app.loadData(app.basePath + "TemailBody/temailbody!recycleAjax.action", {
				emailIds: ids,
				type: type
			}, function (rs) {
				setResult(rs, function (rs) {
					if (rs.success) {
						alert("已放入回收站。");
						window.location.reload();
					}
				});
			});
		}
	}
}

function setToRecycleById (type, id, isFinish) {
	app.loadData(app.basePath + "TemailBody/temailbody!recycleAjax.action", {
		emailIds: id,
		type: type
	}, function (rs) {
		setResult(rs, function (rs) {
			if (rs.success) {
				alert("删除成功。");
				if (isFinish) {
					if (window.APP && window.APP.finish) {
						window.APP.finish(true);
					} else {
						window.history.go(-1);
					}
				} else {
					window.location.reload();
				}
			}
		});
	});
}

function setToDelete () {
	var ids = "", $cb = $(".eoa-data-list .checked");
	if ($cb.size() <= 0) {
		alert("请选择一条邮件记录");
	} else {
		$cb.each(function () {
			ids += $(this).data("id") + ",";
		});
		if (ids.length > 0) {
			app.loadData(app.basePath + "TemailBody/temailbody!deleteAjax.action", {
				emailIds: ids,
				type: "05"
			}, function (rs) {
				setResult(rs, function (rs) {
					if (rs.success) {
						alert("彻底删除成功。");
						window.location.reload();
					}
				});
			});
		}
	}
}

function setMailDetail (rs) {
	if (rs.success) {
		$(".detail .hd h2").html(rs.message.emailTitle || "");
		$(".detail .from").html(rs.message.fromName || rs.message.fromId || "");
		$(".detail .date").html(app.getTimeDuration(rs.message.sendTime, "yyyy-MM-dd hh:mm:ss"));
		$(".detail .important").css("display", (rs.message.important == "01" ? "none" : "inline-block"));
		$(".detail .attach").css("display", (rs.message.isAttachment == "Y" ? "inline-block" : "none"));
		$(".data-bar .recycle").data("id", rs.message.id);
		$(".data-bar .recycle").unbind().click(function () {
			setToRecycleById("01", rs.message.id, true);
		});
		
		var content = rs.message.content || "",
			toId = [], copyToId = [], secretToId = [],
			toIdHtml = "", copyToIdHtml = "", secretToIdHtml = "";
			
		if (rs.message.toId && rs.message.toId != "") {
			toId = JSON.parse(rs.message.toId.replaceAll('\"', '"'));
		}
		if (rs.message.copyToId && rs.message.copyToId != "") {
			copyToId = JSON.parse(rs.message.copyToId.replaceAll('\"', '"'));
		}
		if (rs.message.secretToId && rs.message.secretToId != "") {
			secretToId = JSON.parse(rs.message.secretToId.replaceAll('\"', '"'));
		}
		$(toId).each(function () {
			if (this.label == "") {
				toIdHtml += this.text +"; ";
			} else {
				toIdHtml += this.label + ";";
			}
			
		});
		$(copyToId).each(function () {
			if (this.label == "") {
				copyToIdHtml += this.text +"; ";
			} else {
				copyToIdHtml += this.label + ";";
			}
		});
		$(secretToId).each(function () {
			if (this.label == "") {
				secretToIdHtml += this.text +"; ";
			} else {
				secretToIdHtml += this.label + ";";
			}
		});
		$(".info-mini .box .txt").html(app.cutstr(toIdHtml, 15));
		$(".info-more .toId").html(toIdHtml);
		$(".info-more .copyToId").html(copyToIdHtml);
		$(".info-more .secretToId").html(secretToId);
		
		if (content != "" && content != "undefined") {
			content = content.replaceAll('\"', '"');
			content = content.replaceAll('\r\n', '');
			$(".bd iframe").contents().find("body").html(content);
		} else {
			$(".bd iframe").hide();
		}
		
		app.loadData(app.basePath + "TsysFilesInfo/tsysfilesinfo!listAllAjax.action", {
			objectId: rs.message.id,
			objectType: "04"
		}, function (rs) {
			setResult(rs, setAttach);
		});
		
		$(".data-bar .reply").attr("href", "./edit.html?flag=reply&emailId="+ rs.message.id);
		$(".data-bar .replyAll").attr("href", "./edit.html?flag=replyall&emailId="+ rs.message.id);
		$(".data-bar .forward").attr("href", "./edit.html?flag=forward&emailId="+ rs.message.id);
	}
}

// 显示附件
function setAttach (rs) {
	var html = "";
	if ($(rs).size() > 0) {
		$(rs).each(function () {
			var filesizestr = "0KB";
			if (this.fileSize > 0 && this.fileSize < (1000 * 1000)) {
				filesizestr = (this.fileSize / 1000).toFixed(2) +"KB";
			} else {
				filesizestr = (this.fileSize / (1000 * 1000)).toFixed(2) +"M";
			}
			html += '<li>'+
						'<span class="doc">'+ this.fileName +'('+ filesizestr +')</span>'+
						'<span data-id="'+ this.id +'" data-name="'+ this.fileName +'" data-size="'+ filesizestr +'" class="download">下载</span>'+
					'</li>'
		});
		
		$("#attachment ol").append(html);
		$("#attachment .download").click(function () {
			var filePath = app.basePath +"TsysFilesInfo/tsysfilesinfo!download.action?id="+ $(this).data("id"),
				fileSize = $(this).data("size"),
				fileName = $(this).data("name");
				
			if (confirm("是否下载"+fileName+"?如果您使用3G/4G网络，将消耗您"+fileSize+"流量。")) {
                if (window.APP && window.APP.isSupportDownload) {
                    window.APP.download(filePath + "@shownName=" + fileName);
                } else {
                    alert("不支持APP无法下载");
                }
			}
			
			return false;
		});
	} else {
		$("#attachment").hide();
	}
}

function setTreeList (rs) {
	var html = '',
		getUser = function (pid) {
			var userObj = {};
			$(rs).each(function () {
				if (pid == this.id) {
					userObj = this;
					return false;
				}
			});
			return userObj;
		};
		
	$(rs).each(function () {
		if (this.nocheck != "true") {
			if (this.isParent == "true") {
				html += '<li class="edit folder">'+
							'<a href="list.html?cleartop=true&from='+ data.from +'&selectboxid='+ data.selectboxid +'&treeId='+ this.id +'&pName='+ escape(this.name || "") +'" class="t">'+
								'<h3>'+ this.name +'</h3>'+
							'</a>'+
							'<span class="ico">></span>'+
						'</li>'
			} else {
				var self = this,
					user = getUser(this.pId),
					isChecked = $.selectbox.isChecked(data.selectboxid, {text: this.customInfo});
				
				html += '<li class="edit leaf" data-expand="'+ this.expand +'" data-customInfo="'+ this.customInfo +'" data-id="'+ this.id +'" data-name="'+ user.name +'">'+
							'<a href="javascript:void(0)" class="t">'+
								'<h3>'+ user.name +'</h3>'+
								'<P>'+ this.name +'</p>'+
							'</a>'+
							'<span class="check '+ (isChecked == true ? "checked" : "") +'"></span>'+
						'</li>'
			}
		}
	});
	
	$(".eoa-data-list ul").append(html);
	$(".eoa-data-list .leaf").unbind().click(function () {
		var $cb = $(".check", this),
			userExpand = $(this).data("expand"),
			userId = $(this).data("id"),
			userName = $(this).data("name"),
			userCustomInfo = $(this).data("custominfo") || "",
			checkedid = userExpand.split("_")[0] +"_"+ userId.split("_")[1];
			
		if ($cb.hasClass("checked")) {
			$cb.removeClass("checked");
			$.selectbox.remove(data.selectboxid, {
				//id: checkedid,
				//label: userName,
				text: userCustomInfo
				//extra: "",
				
			})
		} else {
			$cb.addClass("checked");
			$.selectbox.add(data.selectboxid, {
				id: checkedid,
				label: userName,
				text: userCustomInfo,
				extra: "2",
				belongName: data.pName
			});
		}

		$(".s-num").html($.selectbox.getTotal());
	});
	
	$(".s-num").html($.selectbox.getTotal());
}

// 人员选择
jQuery.selectbox = {
	// 判断是否选择
	isChecked: function (target, checkObj) {
		var $target = window.localStorage.getItem(target);
		
		if ($target != null) {
			return $.selectbox.contains($target.split("__"), checkObj);
		} else {
			return false;
		}
	},
	
	// 返回总数
	getTotal: function (target) {
		var num = 0, $targets, $target = window.localStorage.getItem(target || data.selectboxid);
		if ($target != null) {
			$targets = $target.split("__");
			$($targets).each(function (i) {
				if (this != "") {
					num++;
				}
			});
		}
		
		return num;
	},
	
	// 判断是否存在
	contains: function ($targets, checkObj, isRemove) {
		var isContain = false;
		if ($($targets).size() > 0) {
			$($targets).each(function (i) {
				if ($targets[i] && $targets[i] != "") {
					var $self = JSON.parse($targets[i]);
					if ($self.text === checkObj.text) {
						isContain = true;
						if (isRemove) {
							$targets.splice(i, 1);
						}
					}
				}
			});
		}
		
		return isContain;
	},
	
	// 增加
	add: function (target, checkObj) {
		var $checkstr = JSON.stringify(checkObj),
			$target = window.localStorage.getItem(target);
		
		if ($target == null) {
			var $checked = new Array();
			$checked[0] = $checkstr;
			window.localStorage.setItem(target, $checked.join("__"));
		} else {
			$targets = $target.split("__");
			console.log($($targets).size());
			if (!this.contains($targets, checkObj, false)) {
				$targets.push($checkstr);
			}
			window.localStorage.setItem(target, $targets.join("__"));
		}
	},
	
	// 移除
	remove: function (target, checkObj) {
		var $target = window.localStorage.getItem(target);
		
		if ($target != null) {	
			$targets = $target.split("__");
			if (this.contains($targets, checkObj, true)) {
				window.localStorage.setItem(target, $targets.join("__"));
			}
		}
	},
	
	// 清除指定key的值
	clear: function (target) {
		var $target = window.localStorage.getItem(target);
		if ($target != null) {
			window.localStorage.removeItem(target)
		}
	},
	
	// 清除组别内所有key的值，如email组别内的email_toid, email_secretid...
	clearGroup: function (groupTag) {
		var storage = window.localStorage;
		for (var key in storage) {
			if (key.indexOf(groupTag) >= 0) {
				window.localStorage.removeItem(key);
			}
		}
	},
	
	// 返回指定key的值
	getJsonList: function (target) {
		var obj = new Array(), checkObj, $targets, $target = window.localStorage.getItem(target);
		if ($target != null) {
			$targets = $target.split("__");
			$($targets).each(function () {
				if (this != "") {
					checkObj = JSON.parse(this);
					obj.push(checkObj);
				} 
			});
		}

		return obj;
	},
	
	// 返回指定key的值
	getJsonString: function (target) {
		return JSON.stringify(this.getJsonList(target));
	},
	
	setItem: function (key, value) {
		return window.localStorage.setItem(key, value);
	},
	
	getItem: function (key) {
		return window.localStorage.getItem(key);
	}
}

// 任务协同
function setTaskList (rs) {
	if (rs.success) {
		var html = "";
			
		if (rs.message.totalCount > 0) {
			$(rs.message.result).each(function () {
				var timestmap = new Date(this.date);
				html += '<li data-id="'+ this.id +'">'+
							'<a href="javascript:void(0)" class="t" data-id="'+ this.id +'"> '+
								'<h3>'+ this.title +'</h3>'+
								'<P><i class="date">'+ app.getTimeDuration(timestmap, "yyyy-MM-dd hh:mm:ss") +'</i>，'+ this.createUser +' 发起</p>'+
							'</a>'+
							'<span class="arr">+</span>'+
							'<span class="bubble red" data-id="'+ this.id +'">处理</span>'+
							'<div class="detail">'+
								'<span class="arrow"></span>'+
							'</div>'+
						'</li>';
			});

		} else {
			html = '<li class="nulldata"><p>没有待办内容。</p></li>'
		}
		
		$(".eoa-data-list > ul").append(html);
		
		
		// 如果当前页码小于总页码数时，显示翻页
		if (rs.message.pageNo < rs.message.totalPages) {
			$(".page").show();
			data['page.pageNo'] = parseInt(rs.message.pageNo) + 1;
		} else {
			$(".page").hide();
		}
		
		$(".eoa-data-list .t").unbind();
		$(".eoa-data-list .t").not(":first").click(function () {
			var $self = $(this).parent();
			if ($self.hasClass("selected")) {
				$self.removeClass("selected");
				$(".arr", $self).html("+");
				$(".detail", $self).slideUp(10);
			} else {
				$self.addClass("selected");
				$(".arr", $self).html("-");
				if ($self.find(".detail .hd").size() > 0) {
					$(".detail", $self).slideDown(100);
				} else {
					loadDetail($(".detail", $self), $self.data("id"));
				}
			}
			
			return false;
		});
		
		$(".bubble.red").click(function () {
			$.selectbox.clearGroup("task_");
			window.location.href="./process.html?taskId="+ $(this).data("id");
		});
	}
}


// 公文管理
function setDocumentTodo (rs) {
	if (rs.success) {
		var html = "";

		if (rs.message.totalCount > 0) {
			$(rs.message.result).each(function () {
				var link, timestmap = new Date(this.date);
				if (data.type == "send") {
					link = "./sendDetail.html?do=true&status=todo&id="+ this.id;
				} else {
					link = "./incomeDetail.html?do=true&status=todo&id="+ this.id;
				}
				html += '<li data-id="'+ this.id +'">'+
							'<a href="'+ link +'" class="t" data-id="'+ this.id +'"> '+
								'<h3>'+ this.title +'</h3>'+
								'<P><i class="date">'+ this.date +'</i>， 发起</p>'+
							'</a>'+
							'<span class="ico">></span>'+
						'</li>';
			});

		} else {
			html = '<li class="nulldata"><p>没有内容。</p></li>'
		}
		
		$(".eoa-data-list > ul").append(html);
		
		
		// 如果当前页码小于总页码数时，显示翻页
		if (rs.message.pageNo < rs.message.totalPages) {
			$(".page").show();
			data['page.pageNo'] = parseInt(rs.message.pageNo) + 1;
		} else {
			$(".page").hide();
		}
	}
}

function setDocumentDone (rs) {
	if (rs.success) {
		var html = "";

		if (rs.message.totalCount > 0) {
			$(rs.message.result).each(function () {
				var link, timestmap = new Date(this.date);
				if (data.type == "send") {
					link = "./sendDetail.html?do=false&status=todo&id="+ this.id;
				} else {
					link = "./incomeDetail.html?do=false&status=todo&id="+ this.id;
				}
				html += '<li data-id="'+ this.id +'">'+
							'<a href="'+ link +'" class="t" data-id="'+ this.id +'"> '+
								'<h3>'+ this.title +'</h3>'+
								'<P><i class="date">'+ app.getTimeDuration(timestmap, "yyyy-MM-dd hh:mm:ss") +'</i>， 发起</p>'+
							'</a>'+
							'<span class="ico">></span>'+
						'</li>';
			});

		} else {
			html = '<li class="nulldata"><p>没有内容。</p></li>'
		}
		
		$(".eoa-data-list > ul").append(html);
		
		
		// 如果当前页码小于总页码数时，显示翻页
		if (rs.message.pageNo < rs.message.totalPages) {
			$(".page").show();
			data['page.pageNo'] = parseInt(rs.message.pageNo) + 1;
		} else {
			$(".page").hide();
		}
	}
}

// 发文详细
function setSendDetail (rs) {
	if (rs.success) {
		$(".hd h2").html(rs.message.tdocDispatchdoc.docTile);
		
		$(".info-mini .from").html((rs.message.tdocDispatchdoc.postUnit || "") 
			+","+ (rs.message.tdocDispatchdoc.docNum || "") +","
			+ (rs.message.tdocDispatchdoc.secretRank || ""));
		$(".info-mini .sw").html((rs.message.tdocDispatchdoc.mainSend || "") +","
			+ (rs.message.tdocDispatchdoc.copySend || ""));
			
		$(".info-more .bh").html(rs.message.tdocDispatchdoc.docNum || "");
		$(".info-more .fwjg").html(rs.message.tdocDispatchdoc.postUnit || "");
		$(".info-more .ztc").html(rs.message.tdocDispatchdoc.keyWord || "");
		$(".info-more .zs").html(rs.message.tdocDispatchdoc.mainSend || "");
		$(".info-more .cs").html(rs.message.tdocDispatchdoc.copySend || "");
		$(".info-more .bjqx").html(rs.message.tdocDispatchdoc.secretLong || "");
		$(".info-more .jmcd").html(rs.message.tdocDispatchdoc.secretRank || "");
		$(".info-more .gkfs").html(rs.message.tdocDispatchdoc.openType || "");
		$(".info-more .qfr").html(rs.message.tdocDispatchdoc.issuer || "");
		$(".info-more .cwsj").html(rs.message.tdocDispatchdoc.overDocDateString || "");
		$(".info-more .ffsj").html(rs.message.tdocDispatchdoc.endDocDateString || "");
		$(".info-more .yfdw").html(rs.message.tdocDispatchdoc.printUnit || "");
		$(".info-more .yzfs").html(rs.message.tdocDispatchdoc.printNum || "");
		$(".info-more .yfrq").html(rs.message.tdocDispatchdoc.printDateString || "");
		$(".info-more .ngr").html(rs.message.tdocDispatchdoc.draftUserId || "");
		$(".info-more .ngsj").html(rs.message.tdocDispatchdoc.draftDateString || "");
		var zwSuffix = ".doc",
			docAdd = rs.message.tdocDispatchdoc.docAdd || "";
		if (docAdd != "") {
			zwSuffix = docAdd.substring(docAdd.lastIndexOf("."), docAdd.length);
		}
		if (docAdd != "") {
			$(".main a").html(rs.message.tdocDispatchdoc.docTile + zwSuffix);
		} else {
			$(".main a").html("未填写正文");
		}
		$(".main a").click(function () {
			if (!rs.message.tdocDispatchdoc.docAdd) return;
			var filePath = app.basePath + "TsysFilesInfo/tsysfilesinfo!downloadByPath.action?path=" +rs.message.tdocDispatchdoc.docAdd + "&f=d43&pathNoNeedOrgId=true",
				fileName = rs.message.tdocDispatchdoc.docTile + zwSuffix;
				
			if (confirm("是否下载"+fileName+"?")) {
				if (window.APP && window.APP.isSupportDownload) {
					window.APP.download(filePath + "@shownName=" + fileName);
				} else {
					alert("不支持APP无法下载");
				}
			}
			return false;
		});

		if ($(rs.message.fileList).size() > 0) {
			var html = "";
			$(rs.message.fileList).each(function () {
				var filesizestr = "0KB";
				if (this.fileSize > 0 && this.fileSize < (1000 * 1000)) {
					filesizestr = (this.fileSize / 1000).toFixed(2) +"KB";
				} else {
					filesizestr = (this.fileSize / (1000 * 1000)).toFixed(2) +"M";
				}
				html += '<li>'+
							'<span>'+ this.fileName +'('+ filesizestr +')</span>'+
							'<span data-id="'+ this.id +'" data-name="'+ this.fileName +'" data-size="'+ filesizestr +'" class="download">下载</span>'+
						'</li>';
			});
			
			$("#attachment ol").html(html);
			$("#attachment .download").click(function () {
				var filePath = app.basePath +"TsysFilesInfo/tsysfilesinfo!download.action?id="+ $(this).data("id"),
					fileSize = $(this).data("size"),
					fileName = $(this).data("name");
				console.log(filePath)
				if (confirm("是否下载"+fileName+"?如果您使用3G/4G网络，将消耗您"+fileSize+"流量。")) {
					if (window.APP && window.APP.isSupportDownload) {
						window.APP.download(filePath + "@shownName=" + fileName);
					} else {
						alert("不支持APP无法下载");
					}
				}
				return false;
			});
		} else {
			$("#attachment").hide();
		}
		
		$(".btn").click(function () {
			var businessCode = rs.message.tflowInstance.busCode,
				businessId = rs.message.tflowInstance.busId,
				nodeId = rs.message.tflowInstance.curNodeId;
				
			window.location.href = "../workflow/index.html?cleartop=true&businessCode="+ businessCode +"&businessId="+ businessId +"&nodeId=" + nodeId;
			return false;
		});
	}
}

// 收文详细
function setIncomeDetail (rs) {
	if (rs.success) {
		$(".hd h2").html(rs.message.tdocIncoming.docTitle);
		
		$(".info-mini .from").html((rs.message.tdocIncoming.docUnit || "") 
			+","+ (rs.message.tdocIncoming.incomingNum || "") +","
			+ (rs.message.tdocIncoming.secretRank || "") + ","
			+ (rs.message.tdocIncoming.timeRank || ""));
		$(".info-mini .sw").html((rs.message.tdocIncoming.mainDep || "") +","
			+ (rs.message.tdocIncoming.subDep || ""));
			
		$(".info-more .lwdw").html(rs.message.tdocIncoming.docUnit || "");
		$(".info-more .lwwh").html(rs.message.tdocIncoming.incomingNum || "");
		$(".info-more .jmcd").html(rs.message.tdocIncoming.secretRank || "");
		$(".info-more .sjx").html(rs.message.tdocIncoming.timeRank || "");
		$(".info-more .lwsj").html(rs.message.tdocIncoming.incomingDocTimeString || "");
		$(".info-more .swbh").html(rs.message.tdocIncoming.docNum || "");
		$(".info-more .zbbm").html(rs.message.tdocIncoming.mainDep || "");
		$(".info-more .xbbm").html(rs.message.tdocIncoming.subDep || "");
		$(".info-more .ffsj").html(rs.message.tdocIncoming.endDateString || "");
		$(".info-more .yzfs").html(rs.message.tdocIncoming.printNum || "");
		$(".info-more .djr").html(rs.message.tdocIncoming.createUserId || "");
		$(".info-more .djsj").html(rs.message.tdocIncoming.createDateString || "");
		
		var docFile = rs.message.tdocIncoming.docAddress || "";
		if (docFile != "") {
			var docFileSuffix = docFile.substring(docFile.lastIndexOf("."), docFile.length);
			$(".main a").html(rs.message.tdocIncoming.docTitle + docFileSuffix);
			$(".main a").click(function () {
				var filePath = app.basePath + "TsysFilesInfo/tsysfilesinfo!downloadByPath.action?path=" + docFile + "&f=d43&pathNoNeedOrgId=true",
					fileName = rs.message.tdocIncoming.docTitle + docFileSuffix;
					
				console.log(filePath);
				if (confirm("是否下载"+fileName+"？")) {
                    if (window.APP && window.APP.isSupportDownload) {
                        window.APP.download(filePath + "@shownName=" + fileName);
                    } else {
                        alert("不支持APP无法下载");
                    }
				}
				return false;
			});
		}

		if ($(rs.message.fileList).size() > 0) {
			var html = "";
			$(rs.message.fileList).each(function () {
				var filesizestr = "0KB";
				if (this.fileSize > 0 && this.fileSize < (1000 * 1000)) {
					filesizestr = (this.fileSize / 1000).toFixed(2) +"KB";
				} else {
					filesizestr = (this.fileSize / (1000 * 1000)).toFixed(2) +"M";
				}
				html += '<li>'+
							'<span>'+ this.fileName +'('+ filesizestr +')</span>'+
							'<span data-id="'+ this.id +'" data-name="'+ this.fileName +'" data-size="'+ filesizestr +'" class="download">下载</span>'+
						'</li>';
			});
			
			$("#attachment ol").html(html);
			$("#attachment .download").click(function () {
				var filePath = app.basePath +"TsysFilesInfo/tsysfilesinfo!download.action?id="+ $(this).data("id"),
					fileSize = $(this).data("size"),
					fileName = $(this).data("name");
				console.log(filePath)
				if (confirm("是否下载"+fileName+"?如果您使用3G/4G网络，将消耗您"+fileSize+"流量。")) {
                    if (window.APP && window.APP.isSupportDownload) {
                        window.APP.download(filePath + "@shownName=" + fileName);
                    } else {
                        alert("不支持APP无法下载");
                    }
				}
				return false;
			});
		} else {
			$("#attachment").hide();
		}
		
		$(".btn").click(function () {
			var businessCode = rs.message.tflowInstance.busCode,
				businessId = rs.message.tflowInstance.busId,
				nodeId = rs.message.tflowInstance.curNodeId;
				
			window.location.href = "../workflow/index.html?cleartop=true&businessCode="+ businessCode +"&businessId="+ businessId +"&nodeId=" + nodeId;
			return false;
		});
	}
}


// 通知公告
function setNotice (rs) {
	if (rs.success) {
		var html = "";
			
		if (rs.message.totalCount > 0) {
			$(rs.message.result).each(function () {
				var isImportantStyle = this.newsLevel == "普通" ? "none" : "inline-block",
					isAttachStyle = this.fileFlag == "Y" ? "inline-block" : "none";
					
				html += '<li>'+
							'<a href="detail.html?noticeId='+ this.id +'" data-id="'+ this.id +'" class="t">'+
								'<h3>'+ this.newsItem +'<span class="important" style="display:'+ isImportantStyle +'"></span><span class="attach" style="display:'+ isAttachStyle +'"></span></h3>'+
								'<P>'+ this.newsType +'，阅读'+ this.readTimes +'次</p>'+
							'</a>'+
							'<span class="date">'+ this.formatCreateDate +'</span>'+
						'</li>';
			});

		} else {
			html = '<li class="nulldata"><p>没有数据。</p></li>'
		}
		
		$(".eoa-data-list > ul").append(html);
		
		// 如果当前页码小于总页码数时，显示翻页
		if (rs.message.pageNo < rs.message.totalPages) {
			$(".page").show();
			data['page.pageNo'] = parseInt(rs.message.pageNo) + 1;
		} else {
			$(".page").hide();
		}
	}
}

// 公告详细
function setNoticeDetail (rs) {
	if (rs.success) {
		$(".detail .hd h2").html(rs.message.newsItem || "");
		$(".detail .from").html(rs.message.newsType + "，阅读"+ rs.message.readTimes +"次");
		$(".detail .date").html(rs.message.formatCreateDate);
		$(".detail .important").css("display", (rs.message.newsLevel == "普通" ? "none" : "inline-block"));
		$(".detail .attach").css("display", (rs.message.fileFlag == "Y" ? "inline-block" : "none"));
		
		var content = rs.message.newsContent || "",
			$iframe = $(".bd iframe").contents();

		if (content != "") {
			content = content.replaceAll('\"', '"');
			content = content.replaceAll('\r\n', '');
			//content += '<a href="http://apk.woquanquan.com/"><img src="http://ww2.sinaimg.cn/large/e4e2bea6jw1ea45yvwfzqj20jg0nn40y.jpg" /></a>';
			$iframe.find("html, body").css("overflow-y", "hidden");
			$iframe.find("body").attr("id", "eoa-detail").html(content);
			$iframe.find("head").append('<link rel="stylesheet" type="text/css" href="../css/global.css"/>');
			$iframe.find("img").each(function () {
				$(this).attr("align", "absmiddle").load(function () {
					$(".bd iframe").height($iframe.find("body").height() + 15);
				});
			});
			$iframe.find("a").each(function () {
				var link = $(this).attr("href");
				if (link != "") {
					$(this).attr("href", "javascript:window.parent.APP.loadUrl('"+ link +"')");
				}
			});
		} else {
			$(".bd iframe").hide();
		}
		
		if (rs.message.fileFlag == "Y") {
			app.loadData(app.basePath + "TsysFilesInfo/tsysfilesinfo!listAllAjax.action", {
				objectId: rs.message.id,
				objectType: "01"
			}, function (rs) {
				$(".detail .ft").show();
				setResult(rs, setAttach);
			});
		}
	}
}



Array.prototype.contains = function(e) {
	for(i = 0; i< this.length; i++) {
		if(this[i] == e) return true;
	}
	
	return false;
}

Array.prototype.containsJSON = function(obj) {
	for(i = 0; i< this.length; i++) {
		console.log(JSON.parse(this[i]))
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
