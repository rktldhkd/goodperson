package goodperson.common.util;

import egovframework.rte.ptl.mvc.tags.ui.pagination.AbstractPaginationRenderer;

public class ImagePaginationRenderer extends AbstractPaginationRenderer{
	public ImagePaginationRenderer(){
		//&#160;를 각 변수에 들어가는 값의 끝에서 제거.
		//&#160; == &nbsp
		firstPageLabel 		= "<li><a href=\"#\" class=\"board_firstPage\" onclick=\"{0}({1}); return false;\"><image src=\"/goodperson/common/images/btn/left_double_arrow.png\" border=0/></a></li>"; 
		previousPageLabel 	= "<li><a href=\"#\" class=\"board_prePage\" onclick=\"{0}({1}); return false;\"><image src=\"/goodperson/common/images/btn/left_single_arrow.png\" border=0/></a></li>";
		currentPageLabel 	= "<li><span class=\"board_currPage\">{0}</span></li>";
		otherPageLabel 		= "<li><a href=\"#\" class=\"board_page\" onclick=\"{0}({1}); return false;\">{2}</a></li>";
		nextPageLabel 		= "<li><a href=\"#\" class=\"board_nextPage\" onclick=\"{0}({1}); return false;\"><image src=\"/goodperson/common/images/btn/right_single_arrow.png\" border=0/></a></li>";
		lastPageLabel 			= "<li><a href=\"#\" class=\"board_lastPage\" onclick=\"{0}({1}); return false;\"><image src=\"/goodperson/common/images/btn/right_double_arrow.png\" border=0/></a></li>";
	}//constructor
	
	// 페이징 커스터마이징에 관한 전자정부 프레임워크 자료실 URL.
	//http://www.egovframe.go.kr/wiki/doku.php?id=egovframework:rte:ptl:view:paginationtag&s[]=%ED%8E%98&s[]=%EC%9D%B4&s[]=%EC%A7%95&s[]=%ED%8E%98%EC%9D%B4%EC%A7%95
}//class
