package goodperson.user.service;

import java.util.Map;

public interface UserService {
	/**
	 * 아이디, 비밀번호 찾기
	 * @param map
	 * @return map(result)
	 * @throws Exception
	 */
	Map<String,Object> searchIdPw(Map<String,Object> map) throws Exception;

	/**
	 * 임시 비밀번호 발급.
	 * @param map
	 * @return String tmpPwd
	 * @throws Exception
	 */
	String issueTmpPwd(Map<String, Object> map) throws Exception;

	/**
	 * 회원의 모든 정보를 가져온다.
	 * @param map
	 * @return User's Informations
	 * @throws Exception
	 */
	Map<String, Object> getTotalUserInfo(Map<String, Object> map) throws Exception;

	/**
	 * 회원정보 확인/수정 전, 비밀번호를 재확인한다.
	 * @param map
	 * @return flag
	 * @throws Exception
	 */
	boolean reconfirmUser(Map<String, Object> map) throws Exception;

	/**
	 * 수정한 비밀번호를 업데이트. 
	 * @param pw
	 * @throws Exception
	 */
	void modifyPwd(Map<String, Object> map) throws Exception;

	/**
	 * 수정한 회원정보들을 업데이트.
	 * @param map
	 * @throws Exception
	 */
	void modifyUserInfo(Map<String, Object> map) throws Exception;
}//interface