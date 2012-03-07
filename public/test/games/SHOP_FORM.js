
var SHOP_FORM;
if(SHOP_FORM == undefined) {
  SHOP_FORM = {};
}

SHOP_FORM.load = function(token) {
  this.gamertiser_shop_id = 'api/v1/coupon_form';
  this.empty_url = "http://getgamertiser_shop.s3.amazonaws.com/assets/gamertiser_shop/images/transparent.gif";
  this.feedback_url = '';

  this.tab_html = '<a id="gamertiser_shop_tab" onclick="GAMERTISER_DISPLAY_SHOP(\'' + token +'\');" href="#">Feedback</a>';

  this.overlay_html = '<div id="gamertiser_shop_overlay" style="display: none;">' +
			'<div id="gamertiser_shop_main" style="top: 130.95px;">' +
			'<a id="gamertiser_shop_close" onclick="document.getElementById(\'gamertiser_shop_overlay\').style.display = \'none\';return false" href="#"/></a>' +
			'<div id="overlay_header">' +
				'</div>' +
				'<iframe src="' + this.feedback_url + '" id="gamertiser_shop_iframe" allowTransparency="true" scrolling="no" frameborder="0" class="loading"></iframe>' +
				'</div>' +
				'<div id="gamertiser_shop_screen" onclick="document.getElementById(\'gamertiser_shop_overlay\').style.display = \'none\';return false" style="height: 100%;"/>' +
				'</div>' +
	'</div>';
       
    //put up the tab and over_lay 
    document.write(this.tab_html);
    document.write(this.overlay_html);    
};

SHOP_FORM.show = function() {
  //feedback_url = 'http://0.0.0.0:3000/' + this.gamertiser_shop_id + '?token='+ token +'&'+'coupon_id=' + coupon_id;
  feedback_url = 'http://0.0.0.0:3000/api/v1/product_inventory_display';
  document.getElementById('gamertiser_shop_iframe').setAttribute("src", feedback_url);
  document.getElementById('gamertiser_shop_overlay').style.display = "block";
  return false;
};

//gamteriser show reward controllers
function gamertiser_tmp(token, coupon_id) {
		SHOP_FORM.show(token, coupon_id);
}

// given type:string, token:string, id:integer
// send in the put request to increment click_through
function gamertiser_click_through(type, id, token) {
	var my_url = 'http://0.0.0.0:3000/api/v1/' + type + '?token=' + token + '&' + type + '_id=' + id;
	$.ajax({
		url: my_url,
	    type: 'PUT',
		    data: '',
		    success: gamertiser_tmp(token, id)
	});
}
// given data:json, type:string, token:string
// use jquery to append the type of product in the correct tags
function gamertiser_show_reward(data, type, token) {
	if (type == 'coupon') {
		var func = "gamertiser_click_through('"+ type +"','" + data.id+ "' , '"+ token+"')"	
		f = $("<a/>").attr("onclick", func).appendTo("#gamertiser_images");
		f.append($("<img/>").attr("src", data.picture_path));
	} else if (type == 'product'){
		var func = "gamertiser_click_through('" + type + "','" + data.id+ "' , '"+ token+"')"	
		f = $("<a/>").attr("onclick", func).appendTo("#gamertiser_products");
		f.append($("<img/>").attr("src", data.picture_path));
	}
}
function GAMERTISER_SHOW(type, token){
	$(document).ready(function(){
		$.getJSON("http://0.0.0.0:3000/api/v1/" + type +".json?token=" + token, 
		function(data){
			gamertiser_show_reward(data, type, token);
		});
	});
}

function GAMERTISER_DISPLAY_SHOP(token){
	SHOP_FORM.show();
	//re-get everything
	
//for each item, can display appropriate prompt

}
