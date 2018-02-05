package goodperson.board.controller;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import goodperson.board.service.BoardService;
import goodperson.common.common.CommandMap;

import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class BoardController {
	Logger log = Logger.getLogger(this.getClass());

	@Resource(name = "boardService")
	private BoardService boardService;

	@RequestMapping(value = "/board/openBoardList.do")
	public ModelAndView openBoardList(CommandMap commandMap) throws Exception {
		ModelAndView mv = new ModelAndView("/board/boardList");

		log.debug("컨트롤러 currentPageNo 값 : [" + commandMap.get("currentPageNo") + "]");
		
		//List<Map<String, Object>> list = boardService.selectBoardList(commandMap);
		Map<String, Object> resultMap =	boardService.selectBoardList(commandMap.getMap());
		
		mv.addObject("paginationInfo", (PaginationInfo)resultMap.get("paginationInfo"));
		mv.addObject("list", resultMap.get("result"));

		return mv;
	}//openBoardList()

	@RequestMapping(value = "/board/searchBoardItem.do")
	public ModelAndView searchBoardItem(CommandMap commandMap) throws Exception {
		ModelAndView mv = new ModelAndView("/board/boardList");
		
		//log.debug("Is there keyword param? : "+commandMap.getMap().containsKey("search_keyword"));
		//log.debug("컨트롤러, searchBoardItem, keyword 값 : [" + commandMap.get("search_keyword") + "]");
		
		Map<String, Object> resultMap =	boardService.searcbBoardItem(commandMap.getMap());
		
		mv.addObject("paginationInfo", (PaginationInfo)resultMap.get("paginationInfo"));
		mv.addObject("list", resultMap.get("result"));
		mv.addObject("search_keyword", commandMap.get("search_keyword"));
		
		return mv;
	}//searchBoardItem()
	
	@RequestMapping(value="/board/openBoardWrite.do")
    public ModelAndView openBoardWrite(CommandMap commandMap) throws Exception{
    	ModelAndView mv = new ModelAndView("/board/boardWrite");
    	
    	return mv;
    }//openBoardWrite()
	
	
	/*
	 * 우리가 화면에서 전송한 모든 데이터는 HttpServletRequest에 담겨서 전송되고, 그것을 
	 * HandlerMethodArgumentResolver를 이용하여 CommandMap에 담아주었다.
	 * 그렇지만 첨부파일은 CommandMap에서 처리를 하지 않았기때문에 HttpServletRequest를 추가로 받도록 하였다.
	 *  HttpServletRequest에는 모든 텍스트 데이터 뿐만이 아니라 화면에서 전송된 파일정보도 함께 담겨있다. 
	 *  우리는 CommandMap을 이용하여 텍스트 데이터는 처리하기 때문에, HttpServletRequest는 파일정보만 활용할 계획
	*/
	@RequestMapping(value="/board/insertBoard.do")
	public ModelAndView insertBoard(CommandMap commandMap, HttpServletRequest request) throws Exception{
		//forward : URL이 유지되면서 a->b로 이동된다. 넘어가는 파라메타값유지
		//redirect : URL이 변경되면서 a->b로 이동된다. 넘어가는 파라메타 초기화
	    ModelAndView mv = new ModelAndView("redirect:/board/openBoardList.do");
	     
	    Authentication authentication 	=	 SecurityContextHolder.getContext().getAuthentication();//시큐리티 로그인 사용자 정보
		Object pricipal 						=	 authentication.getPrincipal();
		String id									= 	 ((UserDetails)pricipal).getUsername();
		
		commandMap.put("ID", id);
	    
		log.debug("========== boardController - 게시글 정보 확인 ==========");
		// Map<String, Object> testMap = (Map<String,
		// Object>)commandMap.get("map");
		Iterator<Entry<String, Object>> it = commandMap.entrySet().iterator();
		Entry<String, Object> entry = null;
		while (it.hasNext()) {
			entry = it.next();
			log.debug("key : [" + entry.getKey() + "], value : ["
					+ entry.getValue() +"]");
		}// while
		
	    boardService.insertBoard(commandMap.getMap(), request);
	     
	    return mv;
	}//insertBoard()
	
	
	@RequestMapping(value="/board/openBoardDetail.do")
	public ModelAndView openBoardDetail(CommandMap commandMap) throws Exception{
	    ModelAndView mv = new ModelAndView("/board/boardDetail");
	    
	    mv.addObject("TotalComments", commandMap.get("TotalComments"));
	    
	    log.debug("========== boardController - openboardDetail commandMap 정보 ==========");
		// Map<String, Object> testMap = (Map<String,
		// Object>)commandMap.get("map");
		Iterator<Entry<String, Object>> it 	= commandMap.entrySet().iterator();
		Entry<String, Object> entry 				= null;
		while (it.hasNext()) {
			entry = it.next();
			log.debug("key : [" + entry.getKey() + "], value : ["
					+ entry.getValue() +"]");
		}// while
	    
	    
	    Map<String,Object> map = boardService.selectBoardDetail(commandMap.getMap());
	    //map.get()의 'map'과 'list' 객체는 serviceImpl에서 데이터 조회 후, 결과값을 저장한 객체.
	    //게시글의 상세정보(게시글에 대한 기본 텍스트들 등의 정보)
	    mv.addObject("map", map.get("map"));
	    
	    //첨부파일 목록.
	    mv.addObject("list", map.get("list"));
	    
	    //댓글 목록.
	    mv.addObject("comments", map.get("result"));
	    
	    log.debug("========== boardController - 게시글에 대한 댓글 정보 확인 ==========");
		log.debug("댓글 json데이터 출력 : [" + map.get("result").toString() + "]");
		// Map<String, Object> testMap = (Map<String,
		// Object>)commandMap.get("map");
		/*Iterator<Entry<String, Object>>*/ it 	= map.entrySet().iterator();
		/*Entry<String, Object> */entry 				= null;
		while (it.hasNext()) {
			entry = it.next();
			log.debug("key : [" + entry.getKey() + "], value : ["
					+ entry.getValue() +"]");
		}// while	    
	    
	    return mv;
	}//openBoardDetail()
	
	
	@RequestMapping(value="/board/openBoardUpdate.do")
	public ModelAndView openBoardUpdate(CommandMap commandMap) throws Exception{
	    ModelAndView mv = new ModelAndView("/board/boardUpdate");
	     
	    Map<String,Object> map = boardService.selectBoardDetail(commandMap.getMap());
	    //게시글 상세 내용
	    mv.addObject("map", map.get("map"));
	    
	  /* DB에서 제대로 값을 가져와서 map 객체에 값이 제대로 담겨서 오는지 체크.
	    log.debug("Controller");
  		@SuppressWarnings("unchecked")
  		Map<String, Object> testMap = (Map<String, Object>)map.get("map");
  		Iterator<Entry<String,Object>> it = testMap.entrySet().iterator();
  		Entry<String,Object> entry = null;
  		while(it.hasNext())
  		{
  			entry = it.next();
              log.debug("key : "+entry.getKey()+", value : "+entry.getValue());
  		}//while
  		*/
	    
	    //첨부파일 목록
	    mv.addObject("list", map.get("list"));
	     
	    return mv;
	}//openBoardUpdate()
	 
	
	//openBoardUpdate.do의 뷰에서 수정 작업 완료 후, 다시 상세정보 화면으로 넘어가는 것.
	@RequestMapping(value="/board/updateBoard.do")
	public ModelAndView updateBoard(CommandMap commandMap, HttpServletRequest request) throws Exception{
		//forward : URL이 유지되면서 a->b로 이동된다. 넘어가는 파라메타값유지
		//redirect : URL이 변경되면서 a->b로 이동된다. 넘어가는 파라메타 초기화
	    ModelAndView mv = new ModelAndView("redirect:/board/openBoardDetail.do");
	     
	    boardService.updateBoard(commandMap.getMap(), request);
	     
	    mv.addObject("IDX", commandMap.get("IDX"));
	    return mv;
	}//updateBoard()
	
	
	@RequestMapping(value="/board/deleteBoard.do")
	public ModelAndView deleteBoard(CommandMap commandMap) throws Exception{
	    ModelAndView mv = new ModelAndView("redirect:/board/openBoardList.do");
	     
	    boardService.deleteBoard(commandMap.getMap());
	     
	    return mv;
	}//deleteBoard()
	
	/**
	 * 댓글 달기. 
	 * ajax, json 사용 시, @ResponseBody 애노테이션 사용 요망. Unknown return value type [java.lang.Integer] 등의 에러 발생방지.
	 * @return The number of duplicated ID
	 */
	@RequestMapping(value="/board/writeComment.do", method=RequestMethod.POST)
	public ModelAndView writeComment(CommandMap commandMap) throws Exception{
		ModelAndView mv = new ModelAndView("redirect:/board/openBoardDetail.do");
		
		Authentication authentication 	=	 SecurityContextHolder.getContext().getAuthentication();//시큐리티 로그인 사용자 정보
		Object pricipal 						=	 authentication.getPrincipal();
		String id									= 	 ((UserDetails)pricipal).getUsername();
		
		commandMap.put("ID", id);
		
		/*log.debug("========== boardController - writeComment - commandMap 정보 확인 ==========");
		// Map<String, Object> testMap = (Map<String,
		// Object>)commandMap.get("map");
		Iterator<Entry<String, Object>> it = commandMap.entrySet().iterator();
		Entry<String, Object> entry = null;
		while (it.hasNext()) {
			entry = it.next();
			log.debug("key : [" + entry.getKey() + "], value : ["
					+ entry.getValue() +"]");
		}// while*/		
		
		boardService.writeComment(commandMap.getMap());
		/*log.debug("========== boardController - 댓글등록 정보 확인 ==========");
		// Map<String, Object> testMap = (Map<String,
		// Object>)commandMap.get("map");
		Iterator<Entry<String, Object>> it = resultMap.entrySet().iterator();
		Entry<String, Object> entry = null;
		while (it.hasNext()) {
			entry = it.next();
			log.debug("key : [" + entry.getKey() + "], value : ["
					+ entry.getValue() +"]");
		}// while
*/		
		mv.addObject("IDX", commandMap.get("IDX"));
		
		return mv;
	}//writeComment
	
	@RequestMapping(value="/board/deleteComment.do")
	public ModelAndView deleteComment(CommandMap commandMap) throws Exception{
	    ModelAndView mv = new ModelAndView("redirect:/board/openBoardDetail.do");
	     
	    log.debug("controller COMMENT_IDX : "+commandMap.get("COMMENT_IDX"));
	    boardService.deleteComment(commandMap.getMap());
	    
	    //redirect로 openBoardDetail.do와 매핑된 메소드로 가서 작업 수행 시,
	    //거기서 파라미터 받아서 사용할 값, ModelAndView 객체에 저장 후, 파라미터 전송.
	    //이동한 메소드의 commandMap이 파라미터를 받아서 저장.
	    mv.addObject("IDX", commandMap.get("IDX"));
	    
	    return mv;
	}//deleteBoard()
	
}//class