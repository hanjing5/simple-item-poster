	
function gamertiser_tmp(token, coupon_id) {
		USER_EMAIL_ONLY_FORM.show(token, coupon_id);
	}

	function gamertiser_click_up(coupon_id, token) {
		var my_url = 'http://0.0.0.0:3000/api/v1/coupon?token=' + token + '&coupon_id=' + coupon_id;
		$.ajax({
		    url: my_url,
		    type: 'PUT',
		    data: '',
		    success: gamertiser_tmp(token, coupon_id)
		});
	}
	function gamertiser_show_reward(data, token) {
			var func = "gamertiser_click_up('" + data.id+ "' , '"+ token+"')"	
			f = $("<a/>").attr("onclick", func).appendTo("#gamertiser_images");
			f.append($("<img/>").attr("src", data.picture_path));
	}
	function GAMERTISER_SHOW(token){
	$(document).ready(function(){
	    $.getJSON("http://0.0.0.0:3000/api/v1/coupon.json?token=" + token, 
		function(data){
			gamertiser_show_reward(data, token);
		});
	  });
}
