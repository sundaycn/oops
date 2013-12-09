/********导航条的滚动************/
var myScroll3;
function initscroll() {		    
	    myScroll3 = new iScroll('wrapper3', {
	        snap : true,
       		momentum : false,
        	hScrollbar : false,
        	vScrollbar : false,
        	hScroll:true,
        	vScroll:false,
        	checkDOMChanges : true   
	    });

	    /***********导航条设置***********/
		var tapnum = localStorage.getItem("ChannelCount");   //栏目的数目  这里要改
		var width2 = $(window).width();
		var tapwidth = width2 * 0.20;  //显示4个，多的话则滑动  0.25 = 1/4
		$(".main_nav li").css("width",tapwidth);
		$(".main_nav .four_li").css("width",width2*0.25);
		var three_len=$(".main_nav .three_li").length;
		$(".main_nav .four_li").css("width",width2*0.30);
		var four_len=$(".main_nav .four_li").length;
		$("#menu_ul").css("width",tapwidth*(tapnum-three_len-four_len)+four_len*width2*0.30+three_len*width2*0.25);
		/********************************/
		myScroll3.refresh();
		/************获取当前菜单的页码**************/
		var index=sessionStorage.getItem("PageIndex");
		if(index==null) index=1
		index++;
		index=index-2>0?index-2:1;
		myScroll3.scrollToElement('li:nth-child('+index+')',0);
}
document.addEventListener('DOMContentLoaded', initscroll, false);
/********************************************************************/