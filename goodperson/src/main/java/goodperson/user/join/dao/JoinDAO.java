package goodperson.user.join.dao;

import java.util.List;
import java.util.Map;

import goodperson.common.dao.AbstractDAO;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Repository;

@Repository("joinDAO")
public class JoinDAO extends AbstractDAO{
	Logger log = Logger.getLogger(this.getClass());
	
	public int duplicateId(String userId) {
		log.debug("DAO userId : [" + userId + "]");
		int result = (Integer)selectOne("user.selectDuplicateId", userId);
		log.debug("DB select : " + result + " 명");
		return result;
	}//duplicateId()

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectAddrList() {
		return (List<Map<String, Object>>)selectList("user.selectAddrList");
	}//selectAddrList

	public void insertUser(Map<String, Object> map) {
		insert("user.insertUser", map);
	}
	
	public void insertAuthority(Map<String, Object> map){
		insert("user.insertAuthority", map);
	}
}//class
