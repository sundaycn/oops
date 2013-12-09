var myScroll,
 	pullDownEl,
 	pullDownOffset,
 	pullUpEl,
	pullUpOffset,
 	Util = {
	  	basePath:"http://117.21.209.104/EasyContact/", 
		timeout:2000,
		exit: function (h) {
			alert(h)
		},
		loadData: function (data, url, callback, error, downOrUp) {
	  	 $.ajax({
             type: "get",
			 data: data,
             async: false,
			 traditional:true,
             url: url,
             dataType: "jsonp",
             jsonp: "jsoncallback",
             success: function(json){
                 //console.log(json)
				callback(json, downOrUp)
             },
             error: function(e){
                 //console.log('fail');
				 error(e);
             }
         });
	  },
	  loaded: function () {//加载完成
                pullDownEl = document.getElementById('pullDown');
                pullDownOffset = pullDownEl.offsetHeight;
                pullUpEl = document.getElementById('pullUp');
                pullUpOffset = pullUpEl.offsetHeight;
                myScroll = new iScroll(
                                'wrapper',
                                {
                                        useTransition : true,
                                        topOffset : pullDownOffset,
                                        onRefresh : function() {
                                                if (pullDownEl.className.match('loading')) {
                                                        pullDownEl.className = '';
                                                        pullDownEl.querySelector('.pullDownLabel').innerHTML = '下拉刷新...';
                                                } else if (pullUpEl.className.match('loading')) {
                                                        pullUpEl.className = '';
                                                        pullUpEl.querySelector('.pullUpLabel').innerHTML = '显示更多...';
                                                }
                                        },
                                        onScrollMove : function() {
                                                if (this.y > 5 && !pullDownEl.className.match('flip')) {
                                                        pullDownEl.className = 'flip';
                                                        pullDownEl.querySelector('.pullDownLabel').innerHTML = '准备刷新...';
                                                        this.minScrollY = 0;
                                                } else if (this.y < 5
                                                                && pullDownEl.className.match('flip')) {
                                                        pullDownEl.className = '';
                                                        pullDownEl.querySelector('.pullDownLabel').innerHTML = '准备刷新...';
                                                        this.minScrollY = -pullDownOffset;
                                                } else if (this.y < (this.maxScrollY - 5)
                                                                && !pullUpEl.className.match('flip')) {
                                                        pullUpEl.className = 'flip';
                                                        pullUpEl.querySelector('.pullUpLabel').innerHTML = '准备刷新...';
                                                        this.maxScrollY = this.maxScrollY;
                                                } else if (this.y > (this.maxScrollY + 5)
                                                                && pullUpEl.className.match('flip')) {
                                                        pullUpEl.className = '';
                                                        pullUpEl.querySelector('.pullUpLabel').innerHTML = '上拉显示更多...';
                                                        this.maxScrollY = pullUpOffset;
                                                }
                                        },
                                        onScrollEnd : function() {
                                                if (pullDownEl.className.match('flip')) {
                                                        pullDownEl.className = 'loading';
                                                        pullDownEl.querySelector('.pullDownLabel').innerHTML = 'Loading...';
                                                        pullDownAction(); // Execute custom function (ajax call?)
                                                } else if (pullUpEl.className.match('flip')) {
                                                        pullUpEl.className = 'loading';
                                                        pullUpEl.querySelector('.pullUpLabel').innerHTML = 'Loading...';
                                                        pullUpAction(); // Execute custom function (ajax call?)
                                                }
                                        }
                                });

                setTimeout(function() {
                        document.getElementById('wrapper').style.left = '0';
                }, 800);
        },
		checkstr: function(str){
				if(str=='' || str==null || str==undefined){
					return '';
					}else{
						return str;
						}
			},
		checkimg: function(path){
			if(path=='' || path==null || path==undefined){
					return 'images/nulldata.png';
					}else{
						return this.basePath+path;
						}
			},
		cutstr: function (str, len){
			if(str.length>len){
				return str.substr(0,len)+"...";
			}else{
				return str;
			}
		},
		getP: function (url, paramName) {
			console.log("Core.getP.url：" + url);
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


document.addEventListener('touchmove', function(e) {
                e.preventDefault();
        }, false);

document.addEventListener('DOMContentLoaded', function() {
		setTimeout(Util.loaded, 200);
}, false);
	  