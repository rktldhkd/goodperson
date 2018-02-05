/**
 * 
 */
$(function(){
	$("#main_nav_community").hover(
		function(){
			$('#main_nav_community').toggleClass('main_nav_on');
			$('#main_nav_notice_category').addClass('main_nav_category_off');
			$('#main_nav_community_category').removeClass('main_nav_category_off');
		},//mouseenter
		function(){
			$('#main_nav_community').toggleClass('main_nav_on');
		}//mouseleave
	);
	
	$("#main_nav_notice").hover(
		function(){
			$('#main_nav_notice').toggleClass('main_nav_on');
			$('#main_nav_community_category').addClass('main_nav_category_off');
			$('#main_nav_notice_category').removeClass('main_nav_category_off');
		},//mouseenter
		function(){
			$('#main_nav_notice').toggleClass('main_nav_on');
		}//mouseleave
	);
	
	$('#main_nav_community_category a').hover(
			function(){$(this).toggleClass('main_nav_on');},
			function(){$(this).toggleClass('main_nav_on');}
	);
	$('#main_nav_notice_category a').hover(
			function(){$(this).toggleClass('main_nav_on');},
			function(){$(this).toggleClass('main_nav_on');}
	);
})