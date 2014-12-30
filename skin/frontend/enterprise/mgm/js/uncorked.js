var tpc = 0;
function determineVars(col_pos,col_len,target,identifier){
	var tpc = 0;
	if (col_pos == 0){
		var col_height = (col_len / 4) - 1;
		var col_max = (col_len / 4) * 2;
		var init_col_max = (col_len / 4) * 2;
		var col_top = jQuery(target+'.expand0 li').length - (Math.floor(col_len / 4) + 1);
	}
	else if (col_pos == 3) {
		var col_height = Math.floor(col_len / 4);
		var col_max = (Math.floor(col_len / 4) * 2) + 1;
		var init_col_max = (Math.floor(col_len / 4) * 2) + 2;
		var col_top = jQuery(target+'.expand0 li').length - (Math.floor(col_len / 4) + 1);
	}
	else{
		if (col_pos == 2){
			var col_height = Math.floor(col_len / 4);
			var col_max = (Math.floor(col_len / 4) * 2);
			var init_col_max = col_max + 2;
			var col_top = jQuery(target+'.expand0 li').length - (Math.floor(col_len / 4) + 1);
		}
		else{
			var col_height = Math.floor(col_len / 4);
			var col_max = (Math.floor(col_len / 4) * 2);
			var init_col_max = col_max;
			var col_top = jQuery(target+'.expand0 li').length - (Math.floor(col_len / 4) + 1);
		}
	}
	
	while (tpc < 4){
		if (tpc == 0){
			jQuery(target).after('</ul><ul class="level1" id="expand'+identifier+'1">');
			jQuery(target+' li:gt('+col_height+'):lt('+init_col_max+')').appendTo(jQuery('ul#expand'+identifier+'1'));
		}
		else if (tpc == 3){
			jQuery(target+'#expand'+identifier+(tpc-1)).after('</ul><ul class="level1" id="expand'+identifier+tpc+'">');
			jQuery(target+' li:gt('+col_top+')').appendTo(jQuery('ul#expand'+identifier+tpc));
		}
		else{
			jQuery(target+'#expand'+identifier+(tpc-1)).after('</ul><ul class="level1" id="expand'+identifier+tpc+'">');
			jQuery(target+' li:gt('+col_height+'):lt('+col_max+')').appendTo(jQuery('ul#expand'+identifier+tpc));
		}
		tpc++;
	}
}
jQuery(function(){
	Enterprise.TopCart.initialize('topCartContent');
	jQuery('#cat_brand > ul, .level1 a[href$="all-states.html"] + ul').addClass('expand0').wrap('<div/>');
	var brand_col_len = jQuery('#cat_brand div ul.expand0 li').length;
	jQuery('.level1 a[href$="all-states.html"] + div').addClass('state-flyout');
	var state_col_len = jQuery('.level1 a[href$="all-states.html"] + div ul.expand0 li').length;
	var brand_col_pos = brand_col_len % 4;
	var state_col_pos = state_col_len % 4;	
	
	determineVars(brand_col_pos,brand_col_len,'#cat_brand div > ul','brand');
	determineVars(state_col_pos,state_col_len,'.level1 a[href$="all-states.html"] + div ul','state');
	
	
	
	jQuery('#billing-address-select').change(function(){
		jQuery.ajax({
			url: '/compliance/compliance/translateAddress',
			type: 'POST',
			data: 'id='+jQuery('#billing-address-select').val(),
			success: function(data){
				var addr = data.split('|');
				$('billing:firstname').value = addr[0];
				$('billing:lastname').value = addr[1];
				$('billing:company').value = addr[2];
				$('billing:street1').value = addr[3];
				$('billing:street2').value = addr[4];
				$('billing:city').value = addr[5];
				$('billing:region_id').value = addr[6];
				$('billing:postcode').value = addr[7];
				$('billing:country_id').value = addr[8];
				$('billing:telephone').value = addr[9];
			}
		});
    });
    jQuery('#shipping-address-select').change(function(){
	    jQuery.ajax({
			url: '/compliance/compliance/translateAddress',
			type: 'POST',
			data: 'id='+jQuery('#shipping-address-select').val(),
			success: function(data){
				var addr = data.split('|');
				$('shipping:firstname').value = addr[0];
				$('shipping:lastname').value = addr[1];
				$('shipping:company').value = addr[2];
				$('shipping:street1').value = addr[3];
				$('shipping:street2').value = addr[4];
				$('shipping:city').value = addr[5];
				$('shipping:region_id').value = addr[6];
				$('shipping:postcode').value = addr[7];
				$('shipping:country_id').value = addr[8];
				$('shipping:telephone').value = addr[9];
			}
		});
	});
})