!function($) {

	// Readied
	$(function() {

		/*
		 *	Global cookie function set
		 *	For use with Demo Panel Dropdown - Remove for prod package
		 */
		function createCookie(name,value,days) {
			if (days) {
				var date = new Date();
				date.setTime(date.getTime()+(days*24*60*60*1000));
				var expires = "; expires="+date.toGMTString();
			}
			else var expires = "";

			document.cookie = name+"="+value+expires+"; path=/";
		}

		function readCookie(name) {
			var nameEQ = name + "=";
			var ca = document.cookie.split(';');

			for(var i=0;i < ca.length;i++) {
				var c = ca[i];
				while (c.charAt(0)==' ') c = c.substring(1,c.length);
				if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
			}
			return null;
		}

		function eraseCookie(name) {
			createCookie(name,"",-1);
		}


		var kioskMode = readCookie('_kioskMode');

		if(!kioskMode) {
			createCookie('_kioskMode', window.location, 7);
		};

		/**
		 *	Countdown timer & Modal
		 *	@params
		 */

		var countdownTimer = {

			autoLogout: function() {

				var $modalMask = $('div#mask'),
					$autoLapse = $($modalMask).attr('data-autologout');

				var autoLogout = setTimeout(function () {
					$modalMask.fadeOut(300, function () {
						setLocation('customer/account/logout');
					});
				}, $autoLapse);
			},


			// start ticking - badabang!
			startTimer: function() {
				var $modalMask = $('div#mask'),
					$timerLapse = $($modalMask).attr('data-timerlapse');

				var timer = setTimeout(function(){
					$modalMask.fadeIn(300).addClass('active');
					countdownTimer.autoLogout();
				}, $timerLapse);

				countdownTimer.userChoice();
			},


			// delegate users choice
			userChoice: function () {
				var $modalButton = $('div.modal-dialog a.button'),
					$modalMask = $('div#mask'),
					$timerLapse = $($modalMask).attr('data-timerlapse');

				$modalButton.click(function (e) {
					e.preventDefault();

					var $this = $(this),
						$thisRel = $this.attr('rel');

					if($thisRel === 'stay') {
						// stay on current page
						$modalMask.fadeOut(300).removeClass('active');

						window.clearTimeout(timer);
						window.clearTimeout(autoLogout);

						var timer = setTimeout(function(){
							$modalMask.fadeIn(300).addClass('active');
							countdownTimer.autoLogout();
						}, $timerLapse);
					}

					if($thisRel === 'leave') {
						$modalMask.fadeOut(300, function () {
							setLocation('customer/account/logout');
						});
					}
				});
			}
		}
		countdownTimer.startTimer();
	});

}(window.jQuery);