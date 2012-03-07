
var USER_EMAIL_ONLY_FORM;
if(USER_EMAIL_ONLY_FORM == undefined) {
  USER_EMAIL_ONLY_FORM = {};
}

USER_EMAIL_ONLY_FORM.load = function() {
  this.barometer_id = 'api/v1/coupon_form';
  this.empty_url = "http://getbarometer.s3.amazonaws.com/assets/barometer/images/transparent.gif";
  this.feedback_url = '';

  this.overlay_html = '<div id="barometer_overlay" style="display: none;">' +
			'<div id="barometer_main" style="top: 130.95px;">' +
			'<a id="barometer_close" onclick="document.getElementById(\'barometer_overlay\').style.display = \'none\';return false" href="#"/></a>' +
			'<div id="overlay_header">' +
				'</div>' +
				'<iframe src="' + this.feedback_url + '" id="barometer_iframe" allowTransparency="true" scrolling="no" frameborder="0" class="loading"></iframe>' +
				'</div>' +
				'<div id="barometer_screen" onclick="document.getElementById(\'barometer_overlay\').style.display = \'none\';return false" style="height: 100%;"/>' +
				'</div>' +
	'</div>';
       
       
    document.write(this.tab_html);
    document.write(this.overlay_html);    
};

USER_EMAIL_ONLY_FORM.show = function(token, coupon_id) {
  feedback_url = 'http://0.0.0.0:3000/' + this.barometer_id + '?token='+ token +'&'+'coupon_id=' + coupon_id;
  document.getElementById('barometer_iframe').setAttribute("src", feedback_url);
  document.getElementById('barometer_overlay').style.display = "block";
  return false;
};

//gamteriser show reward controllers
function gamertiser_tmp(token, coupon_id) {
		USER_EMAIL_ONLY_FORM.show(token, coupon_id);
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
 var url = "http://0.0.0.0:3000/api/v1/" + type +".json?token=" + token
        $.getJSON(url + "&callback=?", null,		function(data){
			gamertiser_show_reward(data, type, token);
		});
	});
}
