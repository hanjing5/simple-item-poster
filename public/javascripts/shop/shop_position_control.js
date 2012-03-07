var horizontal_right = $(document).width()-$("#gamertiser_shop_main").width()-30;
var horizontal_middle =$(document).width()/2+$("#gamertiser_shop_main").width()/2;

var vertical_bottom = $(document).height()-$("#gamertiser_shop_main").height()-20;
var vertical_middle = $(document).height()/2-$("#gamertiser_shop_main").height()/2;

function initShopPosition(vertical, horizontal, shop_width, shop_height){
	var x, y;
	if (horizontal == 'left'){
		x = 0;
	} else if (horizontal == 'middle') {
		x = $(document).width()/2-shop_width/2;
	} else if (horizontal == 'right') {
		x = $(document).width()-shop_width;
	}
	if (vertical == 'top'){
		y = 0;
	} else if (vertical == 'middle') {
		y = $(document).height()/2-shop_height/2;
	} else if (vertical == 'bottom') {
		y = $(document).height()-shop_height;
	}
	//alert('shop width is ' + shop_width +' '+ shop_height);
	//alert('Page format is '+ $(document).width() +' '+$(document).height());
	//alert('final format is '+ x +' '+y);
	$("#gamertiser_shop_main").css("left",x);
	$("#gamertiser_shop_main").css("top", y);
}
