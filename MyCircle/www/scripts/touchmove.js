		var startx=0,starty=0,movex=0,movey=0,starttime,endtime,oldmovex=0,oldmovey=0,flag=0;
		function touchmove(event){
			movex = event.touches[0].pageX;
			movey = event.touches[0].pageY;
			if(flag==0){
				if(Math.abs(movex-oldmovex)>Math.abs(movey-oldmovey)){
					//左右滑动
					flag=1;
					myScroll.AllowScroll=false;
				}
				else{
					//上下滑动
					flag=2;
					myScroll.AllowScroll=true;
				}
			}
			if(flag==1){
				var scrollx = movex - startx;
				$("#wrapper").animate({left:scrollx},10);
			}
		}
		function touchstart(event){
			starttime=new Date();
			startx = event.touches[0].pageX;
			starty = event.touches[0].pageY;
			oldmovex=startx;
			oldmovey=starty;

		}
		function touchend(){
			$("#wrapper").animate({left:0},100);
			if(flag!=1){ 
				flag=0;
				myScroll.AllowScroll=true;
				return;
			}
			flag=0;
			myScroll.AllowScroll=true;
			/*******根据不同的情况来计算不同的leftx*******/
			endtime = new Date();
			var gaptime = endtime - starttime;
			if(gaptime>100 && gaptime<200){//快速的滑动
				if(startx-movex>40){//手指向左滑动
					touchmoveUrl(1);
				}
				else if(movex-startx>40){
					touchmoveUrl(0);
				}
			}
			else{//缓慢的滑动
				if(startx-movex>150){ //滑动超过了100px
					touchmoveUrl(1);
				}
				else if(movex-startx>150){
					touchmoveUrl(0);
				}
			}
			//alert("hScroll:"+myScroll.hScroll+">>>>vScroll:"+myScroll.vScroll);
		}
		function touchmoveUrl(flag){
			var pagenum=sessionStorage.getItem("PageIndex");
			if(pagenum==null) pagenum=1;
			pagenum=parseInt(pagenum);
			if(flag==0){//手指向右滑动，往左边加载
				switch(pagenum){
					case 1:StartChat();break;
					case 2:toUrl(0,0,0);break;
					case 3:toUrl(1,3,0);break;
				}
				if(pagenum>3){
					var channel=localStorage.getItem("Channels");
					if(channel==null || channel=="") channel="[]";
					var json=eval('('+channel+')');
					//有自定义栏目
					if(json.length>0){
						var url=window.location.href;
						if(url.indexOf("introduction")>=0){
							toUrl(pagenum-2,4,0);
						}
						else if(url.indexOf("Twointeractive")>=0){
							toUrl(pagenum-2,1,0);
						}
						else{
							toUrl(pagenum-2,json[pagenum-4].type,json[pagenum-4].id);
						}
					}
					else{
						switch(pagenum){
							case 4:toUrl(2,1,0);break;
							case 5:toUrl(3,4,0);break;
						}
					}
				}
			}
			else{//向左滑动，往右边加载
				switch(pagenum){
					case 1:toUrl(1,3,0);break;
				}
				if(pagenum>1){
					var channel=localStorage.getItem("Channels");
					if(channel==null || channel=="") channel="[]";
					var json=eval('('+channel+')');
					//有自定义栏目
					if(json.length>0){
						var url=window.location.href;
						if(url.indexOf("Twointeractive")>=0){
							toUrl(pagenum,2,0);
						}
						else if(url.indexOf("interactive")>=0){
							toUrl(pagenum,4,0);
						}
						else{
							if(pagenum==2+json.length){
								toUrl(pagenum,1,0);
							}
							else{
								toUrl(pagenum,json[pagenum-2].type,json[pagenum-2].id);
							}
						}
					}
					else{
						switch(pagenum){
							case 2:toUrl(2,1,0);break;
							case 3:toUrl(3,4,0);break;
							case 4:toUrl(4,2,0);break;
						}
					}
				}
			}
		}