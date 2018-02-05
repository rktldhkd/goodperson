package goodperson.board.service;

import goodperson.board.dao.BoardDAO;
import goodperson.common.util.FileUtils;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;


@Service("boardService")
public class BoardServiceImpl implements BoardService{
	Logger log = Logger.getLogger(this.getClass());
	
	@Resource(name="boardDAO")
    private BoardDAO boardDAO;
	
	@Resource(name="fileUtils")
	private FileUtils fileUtils;
	

	/* (non-Javadoc)
	 * main의 newest board Items 구역을 채울 데이터 검색
	 * @see goodperson.board.service.BoardService#getNewestBoardItems()
	 */
	@Override
	public Map<String, Object> getNewestBoardItems() throws Exception {
		Map<String, Object> returnMap = new HashMap<String,Object>();
		List<Map<String,Object>> list=  boardDAO.selectBoardNewest();
		
		returnMap.put("result", list);
		
		return returnMap;
	}
	
	@Override
	public Map<String, Object> selectBoardList(Map<String, Object> map) throws Exception {
		return boardDAO.selectBoardList(map);
	}//selectBoardList

	@Override
	public Map<String, Object> searcbBoardItem(Map<String, Object> map) throws Exception {
		return boardDAO.searchBoardItem(map);
	}//searcbBoardItem
	
	@Override
	public void insertBoard(Map<String, Object> map, HttpServletRequest request) throws Exception {
		// 파라미터 값 처리.(폼으로 넘긴 일반 데이터들 insert 작업)
		boardDAO.insertBoard(map);
		
		List<Map<String,Object>> list = fileUtils.parseInsertFileInfo(map, request);
        for(int i=0, size=list.size(); i<size; i++){
            boardDAO.insertFile(list.get(i));
        }//end for
	}//insertBoard

	@Override
	public Map<String, Object> selectBoardDetail(Map<String, Object> map) throws Exception {
		boardDAO.updateHitCnt(map);
	   /* Map<String, Object> resultMap = boardDAO.selectBoardDetail(map);
	    return resultMap;*/
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		//view단의 javascript에 던져줄 ID 값.
		Authentication authentication 	=	 SecurityContextHolder.getContext().getAuthentication();//시큐리티 로그인 사용자 정보
		Object principal 						=	 authentication.getPrincipal();
		String id 								=	 null;
		log.debug(principal);
		if(principal != "anonymousUser"){ //비로그인 사용자인 경우, principal 값이 anonymouseUser 이다.
			id	= ((UserDetails) principal).getUsername();
		}//end if
		
		//게시글 상세정보 조회
		Map<String, Object> tempMap = boardDAO.selectBoardDetail(map);
		tempMap.put("ID", id);
		resultMap.put("map", tempMap);

		/* DB에서 제대로 값을 가져와서 map 객체에 값이 제대로 담겨서 오는지 체크.
		@SuppressWarnings("unchecked")
		Map<String, Object> testMap = (Map<String, Object>)resultMap.get("map");
		Iterator<Entry<String,Object>> it = testMap.entrySet().iterator();
		Entry<String,Object> entry = null;
		while(it.hasNext())
		{
			entry = it.next();
            log.debug("key : "+entry.getKey()+", value : "+entry.getValue());
		}//while
		*/
		//첨부파일 리스트 조회
		List<Map<String, Object>> list = boardDAO.selectFileList(map);
		resultMap.put("list", list);
		
		
		//log.debug("serviceImple IDX : [" + map.get("IDX") + "]");
		//해당 게시글의 댓글들 조회
		List<Map<String, Object>> commentList = boardDAO.selectBoardComment(map);
		//log.debug("commentList의 길이 : [" + commentList.size() + "]");
		//log.debug("날짜 형식 : [" + commentList.get(0).get("CREA_DTM")+"]");
		
		resultMap.put("result", commentList);

		return resultMap;
	}//selectBoardDetail

	@Override
	public void updateBoard(Map<String, Object> map, HttpServletRequest request) throws Exception {
		boardDAO.updateBoard(map);
		
		// 해당 게시글에 해당하는 첨부파일을 전부 삭제처리(DEL_GB = 'Y')
		boardDAO.deleteFileList(map);
		//request에 담겨있는 파일 정보를 list로 변환. 
		//기존에 저장된 파일 중, 삭제되지  않은 파일정보도 포함.
		List<Map<String,Object>> list = fileUtils.parseUpdateFileInfo(map, request);
	    Map<String,Object> tempMap = null;
	    for(int i=0, size=list.size(); i<size; i++){
	        tempMap = list.get(i);
	        log.debug("board_idx : " + tempMap.get("BOARD_IDX"));
	        log.debug("origin__fileName : " + tempMap.get("ORIGINAL_FILE_NAME"));
	        if(tempMap.get("IS_NEW").equals("Y")){
	            boardDAO.insertFile(tempMap);
	        }
	        else{
	            boardDAO.updateFile(tempMap);
	        }
	    }//for
	}//updateBoard

	@Override
	public void deleteBoard(Map<String, Object> map) throws Exception {
		boardDAO.deleteBoard(map);
	}//deleteBoard

	/* (non-Javadoc)
	 * 1. 댓글 등록 기능
	 * @see goodperson.board.service.BoardService#writeComment(java.lang.String)
	 */
	@Override
	public void writeComment(Map<String, Object> map) throws Exception {
		boardDAO.increaseCommCount(map);
		
		log.debug("========== Service - writeComment - Map 정보 확인 ==========");
		// Map<String, Object> testMap = (Map<String,
		// Object>)commandMap.get("map");
		Iterator<Entry<String, Object>> it = map.entrySet().iterator();
		Entry<String, Object> entry = null;
		while (it.hasNext()) {
			entry = it.next();
			log.debug("key : [" + entry.getKey() + "], value : ["
					+ entry.getValue() +"]");
		}// while
		
		
		//1번 기능
		log.debug("service-writeComment-Do the map have PARENT_IDX ? [" + map.containsKey("PARENTS_IDX") + "]");
		log.debug("service-writeComment-check PARENTS_IDX : [" + map.get("PARENTS_IDX") + "]");
		if(map.containsKey("PARENTS_IDX")){
			boardDAO.insertRecomment(map);
		}else{
			boardDAO.insertComment(map);
		}//end if-else
	}//writeComment

	/* (non-Javadoc)
	 * 댓글 삭제
	 * @see goodperson.board.service.BoardService#deleteComment(java.util.Map)
	 */
	@Override
	public void deleteComment(Map<String, Object> map) throws Exception {
		boardDAO.decreaseCommCount(map);
		
		log.debug("service COMMENT_IDX : "+map.get("COMMENT_IDX"));
		boardDAO.deleteComment(map);
	}//deleteComment
}//class
