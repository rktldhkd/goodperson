package goodperson.common.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;


public class AbstractDAO {
	protected Log log = LogFactory.getLog(AbstractDAO.class);
    
    @Autowired
    private SqlSessionTemplate sqlSession;
     
    protected void printQueryId(String queryId) {
        if(log.isDebugEnabled()){
            log.debug("\t QueryId  \t:  " + queryId);
        }
    }
     
    public Object insert(String queryId, Object params){
        printQueryId(queryId);
        return sqlSession.insert(queryId, params);
    }
     
    public Object update(String queryId, Object params){
        printQueryId(queryId);
        return sqlSession.update(queryId, params);
    }
     
    public Object delete(String queryId, Object params){
        printQueryId(queryId);
        return sqlSession.delete(queryId, params);
    }
     
    public Object selectOne(String queryId){
        printQueryId(queryId);
        return sqlSession.selectOne(queryId);
    }
     
    public Object selectOne(String queryId, Object params){
        printQueryId(queryId);
        return sqlSession.selectOne(queryId, params);
    }
     
    @SuppressWarnings("rawtypes")
    public List selectList(String queryId){
        printQueryId(queryId);
        return sqlSession.selectList(queryId);
    }
     
    @SuppressWarnings("rawtypes")
    public List selectList(String queryId, Object params){
        printQueryId(queryId);
        return sqlSession.selectList(queryId,params);
    }
    
    /**
     * 게시판 페이징의 기능 수행.
     * @param queryId
     * @param params
     * @return
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
    public Map selectPagingList(String queryId, Object params){
        printQueryId(queryId);
         
        Map<String,Object> map = (Map<String,Object>)params;
        PaginationInfo paginationInfo = null;
        
        // currentPageNo : 현재 페이지 번호.
        // 예상치 못한 상황에서 값이 없을 경우, 에러가 나는 것을 방지.
        if(map.containsKey("currentPageNo") == false || StringUtils.isEmpty(map.get("currentPageNo")) == true)
            map.put("currentPageNo","1");
        
        // PaginationInfo 클래스 : 페이징에 필요한 정보를 가지고 있는 전자정부 프레임워크의 클래스.
        // 이 클래스에 여러가지 값을 설정, 그 값을 이용하여 화면에 출력할 것을 계산하기도 한다.
        paginationInfo = new PaginationInfo();

        // 한 페이지에 몇개의 행을 보여줄 것인지 설정.
        // 만약 화면에서 특정 값을 보내준다면 그에 맞는 행을 보여주고, 그 값이 아니면 default로 15개를 보여주도록 함.
        log.debug("currentPageNo : [" + Integer.parseInt(map.get("currentPageNo").toString()) + "]");
        paginationInfo.setCurrentPageNo(Integer.parseInt(map.get("currentPageNo").toString()));
        if(map.containsKey("PAGE_ROW") == false || StringUtils.isEmpty(map.get("PAGE_ROW")) == true){
            paginationInfo.setRecordCountPerPage(15);
        }
        else{
            paginationInfo.setRecordCountPerPage(Integer.parseInt(map.get("PAGE_ROW").toString()));
        }
        // 한 번에 표시할 페이지의 개수 ([이전] 1~10 [다음] 의 개수) 
        paginationInfo.setPageSize(10);
         
        int start = paginationInfo.getFirstRecordIndex();
        int end = start + paginationInfo.getRecordCountPerPage();
        map.put("START",start+1);
        map.put("END",end);
         
        params = map;
         
        Map<String,Object> returnMap = new HashMap<String,Object>();
        // 실제 DB에서 게시판 행 데이터를 가져오는 부분.
        List<Map<String,Object>> list = sqlSession.selectList(queryId,params); // 게시판 모든 행을 리턴.
        log.debug("게시판 페이징 행 수 : [" + list.size() + "]");
        
        for(int i=0; i<list.size(); i++){
        	log.debug(list.get(i));
        }
        
        // 게시판에 데이터가 없을 시, TOTAL_COUNT가 0. 
        // 조회된 값이 없다면 그에 해당하는 결과를 표시할 수 있도록 0으로 설정.
        if(list.size() == 0){
            map = new HashMap<String,Object>();
            map.put("TOTAL_COUNT",0);  
            list.add(map);
             
            if(paginationInfo != null){
                paginationInfo.setTotalRecordCount(0);
                returnMap.put("paginationInfo", paginationInfo);
            }
        }
        else{
            if(paginationInfo != null){
                paginationInfo.setTotalRecordCount(Integer.parseInt(list.get(0).get("TOTAL_COUNT").toString()));
                returnMap.put("paginationInfo", paginationInfo);
            }
        }
        returnMap.put("result", list);
        return returnMap;
    }//selectPagingList
    
}//class
