package goodperson.user.dao;

import goodperson.common.dao.AbstractDAO;

import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository("userDAO")
public class UserDAO extends AbstractDAO{
	@SuppressWarnings("unchecked")
	public Map<String,Object>  selectId(Map<String,Object> map) throws Exception{
		return (Map<String,Object>)selectOne("user.searchId", map);
	}//selectId
	
	@SuppressWarnings("unchecked")
	public Map<String,Object> selectPw(Map<String,Object> map) throws Exception{
		return (Map<String,Object>)selectOne("user.searchPw", map);
	}//selectPw

	public void issueTmpPwd(Map<String, Object> map) {
		log.debug("id map값 : ["+ map.get("id") +"]");
		log.debug("tmpPwd map값 : ["+ map.get("tmpPwd") +"]");
		update("user.updateTmpPwd", map);
	}//issueTmpPwd

	@SuppressWarnings("unchecked")
	public Map<String, Object> getTotalUserInfo(Map<String, Object> map) {
		return (Map<String, Object>)selectOne("user.getTotalUserInfo", map);
	}//getTotalUserInfo

	public String reconfirmUser(Map<String, Object> map) {
		return (String)selectOne("user.reconfirmUser", map);
	}

	public void updatePwd(Map<String, Object> map) {
		update("user.updatePwd", map);
	}//updatePwd

	public void updateUserInfo(Map<String, Object> map) {
		update("user.updateUserInfo", map);
	}//updateUserInfo
}//class