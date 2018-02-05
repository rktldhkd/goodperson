package goodperson.user.join.service;

import goodperson.user.join.dao.JoinDAO;

import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

@Service("JoinService")
public class JoinServiceImpl implements JoinService{
	Logger log = Logger.getLogger(this.getClass());
	
	@Resource(name="joinDAO")
    private JoinDAO joinDAO;
	
	@Autowired
	private BCryptPasswordEncoder passwordEncoder;
	
	/* (non-Javadoc)
	 * 아이디 중복 체크
	 * @see goodperson.user.join.service.JoinService#chkUserId(java.lang.String)
	 */
	@Override
	public int duplicateUserId(String userId) throws Exception {
		log.debug("serviceImpl userId : [" + userId + "]");
		return joinDAO.duplicateId(userId);
	}//duplicateUserId

	/* (non-Javadoc)
	 * 주소찾기 창에 보여줄 주소값 리스트 조회. -> 다음 API 사용으로 인한 주석처리.
	 * @see goodperson.user.join.service.JoinService#selectAddrList()
	 
	@Override
	public List<Map<String, Object>> selectAddrList() {
		return joinDAO.selectAddrList();
	}*/
	
	
	/* (non-Javadoc)
	 * 회원가입 처리. 회원 등록.
	 * @see goodperson.user.join.service.JoinService#insertUser(java.util.Map)
	 */
	@Override
	public void insertUser(Map<String, Object> map) throws Exception {
		String tmpPwd 		= (String)map.get("pwd");
		
		if(passwordEncoder == null){log.debug("pwde is null");}//인코더 생성여부 검사.

		log.debug("암호화 하기 전, 비밀번호 : [" + tmpPwd + "]");
		String encodedPwd 	= passwordEncoder.encode(tmpPwd);
		log.debug("암호화 결과 : [" + encodedPwd + "]");
		map.put("pwd", encodedPwd);
		log.debug("map에 들어간 데이터 확인 : [" + map.get("pwd") + "]" );
		
		//사용자 추가. 파라미터 값 처리.(폼으로 넘긴 일반 데이터들 insert 작업)
		joinDAO.insertUser(map);
		//사용자 권한 테이블에 정보 추가.
		joinDAO.insertAuthority(map);
	}//insertBoard
}//class