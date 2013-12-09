var Toast = function(){};
Toast.prototype = {
	show:function(content,length){
	    return cordova.exec(null, null,"ToastPlugin","toast",[content,length]);
	}
};

/*cordova.addConstructor(function(){
    if (!window.plugins) {
        window.plugins = {};
    }
    window.plugins.ToastPlugin = new Toast();
});
*/
window.Toast = new Toast();