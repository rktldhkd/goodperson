package goodperson.board.dao;

import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import goodperson.common.dao.AbstractDAO;

import org.springframework.stereotype.Repository;

@Repository("boardDAO")
public class BoardDAO extends AbstractDAO{
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectBoardNewest() {
		return (List<Map<String, Object>>)selectList("board.selectNewestBoardItem");
	}//selectBoardNewest()
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectBoardList(Map<String, Object> map) {
		return (Map<String, Object>)selectPagingList("board.selectBoardList", map);
	}//selectBoardList()

	@SuppressWarnings("unchecked")
	public Map<String, Object> searchBoardItem(Map<String, Object> map) {
		String query;
		String type = (String)map.get("search_type");
		log.debug("오오오오오는 값 : [" + type + "]");
		log.debug("검검검검검색 값 : [" + map.get("search_keyword") + "]");
		if(type.equals("TITLE")){
			query = "board.searchBoardItem_title";
		}else if(type.equals("CREA_ID")){
			query = "board.searchBoardItem_id";
		}else{
			query = "board.searchBoardItem_contents";
		}//end if-else
		
		return (Map<String, Object>)selectPagingList(query, map);
		//return (Map<String, Object>)selectPagingList("board.searchBoardItem", map);
	}//searchBoardItem
	
	public void insertBoard(Map<String, Object> map) {
		insert("board.insertBoard",map);
	}//insertBoard()

	public void updateHitCnt(Map<String, Object> map) {
		update("board.updateHitCnt", map);
	}//updateHitCnt

	@SuppressWarnings("unchecked")
	public Map<String, Object> selectBoardDetail(Map<String, Object> map) {
		return (Map<String, Object>)selectOne("board.selectBoardDetail", map);
	}//selectBoardDetail

	public void updateBoard(Map<String, Object> map) {
		update("board.updateBoard", map);
	}//updateBoard

	public void deleteBoard(Map<String, Object> map) {
		delete("board.deleteBoard", map);
	}//deleteBoard

	public void insertFile(Map<String, Object> map) {
		insert("board.insertFile", map);
	}//insertFile

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectFileList(Map<String, Object> map) {
		return (List<Map<String, Object>>)selectList("board.selectFileList", map);
	}//selectFileList

	public void deleteFileList(Map<String, Object> map) {
		update("board.deleteFileList",map);
	}//deleteFileList

	public void updateFile(Map<String, Object> map) {
		update("board.updateFile", map);
	}//updateFile

	public void insertComment(Map<String, Object> map) {
		log.debug("========== DAO - insertComment - Map 정보 확인 ==========");
		// Map<String, Object> testMap = (Map<String,
		// Object>)commandMap.get("map");
		Iterator<Entry<String, Object>> it = map.entrySet().iterator();
		Entry<String, Object> entry = null;
		while (it.hasNext()) {
			entry = it.next();
			log.debug("key : [" + entry.getKey() + "], value : ["
					+ entry.getValue() +"]");
		}// while
		
		
		log.debug("txtArea_val : " + map.containsKey("comment_contents"));
		insert("board.insertComment", map);
	}//insertComment

	public void insertRecomment(Map<String, Object> map) {
		insert("board.insertRecomment", map);
	}//insertRecomment
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectBoardComment(Map<String, Object> map) {
		//log.debug("DAO-selectBoardComment의 IDX 확인 : [" + map.get("IDX") + "]" );
		return (List<Map<String, Object>>)selectList("board.selectBoardComment", map);
	}//selectBoardComment
	
	/*@SuppressWarnings("unchecked")
	public Map<String, Object> selectHasInsertedComment(Map<String, Object> map) {
		//log.debug("DAO-selectHasInsertedComment의 IDX 확인 : [" + map.get("IDX") + "]" );
		return (Map<String, Object>)selectOne("board.selectHasInsertedComment", map);
	}//selectBoardComment
*/
	public void deleteComment(Map<String, Object> map) {
		log.debug("DAO COMMENT_IDX : " + map.get("COMMENT_IDX"));
		delete("board.deleteComment", map);
	}//deleteComment

	public void increaseCommCount(Map<String, Object> map) {
		update("board.increaseCommCount", map);
	}

	public void decreaseCommCount(Map<String, Object> map) {
		update("board.decreaseCommcount", map);
	}

}//class
