var Toast = function(){};
Toast.prototype = {
	show:function(content,length){
	    return cordova.exec(null, null,"ToastPlugin","toast",[content,length]);
	}
};
window.Toast = new Toast();

var myScroll, pullDownEl, pullDownOffset, pullUpEl, pullUpOffset;
var app = {
	basePath:"http://59.52.226.85:8888/EasyContactFY/", 
	//basePath: "http://134.224.53.51:19090/EasyContact/",
	//basePath: "http://134.225.52.65:9090/EasyContact/",
	timeout:2000,

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
				//console.log(urlparam[0])
				//console.log(urlparam[1])
				localStorage.setItem(urlparam[0], urlparam[1]);
			}
			
			window.location.href = url;
		}
	},
	
	// 显示提醒信息
	toast: function (message, timeout) {
		// TODO 利用phonegap插件 调用android的Toast方法show出提醒
		if (!timeout) timeout = 2000;
		//alert(message);
		if (Toast) {
			Toast.show(message, timeout);
		}
	},
	
	// 加载数据通用方法
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
				//console.log(json)
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
	
	// format空串
	checkstr: function(str) {
		if (str=='' || str==null || str==undefined) {
			return '';
		} else {
			return str;
		}
	},
	
	// 对空图片路径设置默认图片
	checkimg: function(path) {
		if (path=='' || path==null || path==undefined) {
			return 'images/nulldata.png';
		} else {
			return this.basePath+path;
		}
	},
	
	// 截取字符串，补省略号
	cutstr: function (str, len) {
		if(str.length > len){
			return str.substr(0, len) + "...";
		}else{
			return str;
		}
	},
	
	// 转换时间
	formatDate: function (timestamp) {
		if (timestamp) {
			//return new Date(timestamp).format("yyyy-MM-dd HH:mm:ss");
			return new Date(timestamp).format("yyyy-MM-dd");
		} else {
			return "";
		}
	},
	
	// 根据url重设参数, excepParams为需移除的参数数组
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
	
	// 根据url获取参数
	getParam: function (url, paramName) {
		//console.log("Core.getP.url：" + url);
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
	}
}

Array.prototype.contains = function(e) {
	//console.log(e);
	for(i=0; i< this.length; i++) {
		if(this[i] == e) return true;
	}
	
	return false;
}

// 对Date的扩展，将 Date 转化为指定格式的String 
// 月(M)、日(d)、小时(h)、分(m)、秒(s)、季度(q) 可以用 1-2 个占位符， 
// 年(y)可以用 1-4 个占位符，毫秒(S)只能用 1 个占位符(是 1-3 位的数字) 
// 例子： 
// (new Date()).Format("yyyy-MM-dd hh:mm:ss.S") ==> 2006-07-02 08:09:04.423 
// (new Date()).Format("yyyy-M-d h:m:s.S")      ==> 2006-7-2 8:9:4.18 
Date.prototype.format = function(fmt) {
	var o = { 
		"M+" : this.getMonth()+1,                 //月份 
		"d+" : this.getDate(),                    //日 
		"h+" : this.getHours(),                   //小时 
		"m+" : this.getMinutes(),                 //分 
		"s+" : this.getSeconds(),                 //秒 
		"q+" : Math.floor((this.getMonth()+3)/3), //季度 
		"S"  : this.getMilliseconds()             //毫秒 
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


document.addEventListener('touchmove', function(e) {
	e.preventDefault();
}, false);


	  