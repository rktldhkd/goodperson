/**
 * 
 */
$(function(){
	$('.comment_btn_del').on('click', function(e){
		e.preventDefault();
		fn_deleteComment($(this));
	});
	
	
	$("#list").on("click", function(e){ //목록으로 버튼
        e.preventDefault();
        fn_openBoardList();
    });//#list
	
});//jQuery