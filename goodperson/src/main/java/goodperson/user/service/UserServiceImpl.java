package goodperson.user.service;

import goodperson.common.util.TmpPasswordUtil;
import goodperson.user.dao.UserDAO;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

@Service("UserService")
public class UserServiceImpl implements UserService{
	Logger log = Logger.getLogger(this.getClass());
	
	@Resource(name="userDAO")
    private UserDAO userDAO;

	@Resource(name="tmpPasswordUtils")
	private TmpPasswordUtil tmpPasswordUtils;
	
	@Autowired
	private BCryptPasswordEncoder passwordEncoder;
	
	@Override
	public Map<String,Object> searchIdPw(Map<String,Object> map) throws Exception {
		Map<String,Object> result = null;
		
		//정보에 해당하는 계정이 존재하면, 레코드가 하나가 나온다.
		if(map.size()<3){
			//아이디찾기
			result 	=  userDAO.selectId(map);
		}else{
			//비밀번호 찾기
			result		=  userDAO.selectPw(map);
		}//end if-else
		
		//null일때 인스턴스 생성 안하고, 객체 사용(.size(), .put() 같은 메소드 사용 등..)하면,
		//NullPointerException 이 발생하므로, null일때 인스턴스를 생성해줘야 한다.
		//여기서 null은 DB에서 select된 레코드가 하나도 없어서, DB단에서 생성되서 온 map 인스턴스가 없기때문에,
		//null 상태가 된 것 같다. 그래서 인위적으로 서비스에서 생성.
		if(result == null)		result = new HashMap<String, Object>();
		if(result.size() < 2){
			result.put("fail", true);
		}else{
			result.put("fail", false);
		}
		log.debug("result의 size : " + result.size());
		
		return result;
	}//searchIdPw

	@Override
	public String issueTmpPwd(Map<String, Object> map) throws Exception {
		String tmpPwd  =  tmpPasswordUtils.issueTmpPwd(); //임시비밀번호 생성.
		String encodedPwd;//view에 뿌려줄 임시비밀번호.
		
		log.debug("임시 비밀번호 : ["+tmpPwd+"]");
		encodedPwd = passwordEncoder.encode(tmpPwd); //임시 비밀번호 암호화.
		log.debug("암호화한 임시 비밀번호 : ["+encodedPwd+"]");
		
		map.put("encodedPwd", encodedPwd);
		log.debug("map값 : " + map.get("tmpPwd"));
		userDAO.issueTmpPwd(map); //암호화한 임시비밀번호 DB에 입력.
		
		return tmpPwd;
	}//issueTmpPwd

	@Override
	public Map<String, Object> getTotalUserInfo(Map<String, Object> map)throws Exception {
		Map<String, Object> resultMap = userDAO.getTotalUserInfo(map);
		return resultMap;
	}//getTotalUserInfo

	@Override
	public boolean reconfirmUser(Map<String, Object> map) throws Exception {
		String result = userDAO.reconfirmUser(map);
		log.debug("dao에서 뽑은 비밀번호 값 : ["+result+"]");
		
		boolean flag = passwordEncoder.matches((String)map.get("pwd"), result);
		
		return flag;
	}

	@Override
	public void modifyPwd(Map<String, Object> map) throws Exception {
		log.debug("수정된 비밀번호 업데이트");
		String encodedPwd = (String)map.get("pwd");
		map.put("pwd", passwordEncoder.encode(encodedPwd));
		
		userDAO.updatePwd(map);
	}//modifyPwd

	@Override
	public void modifyUserInfo(Map<String, Object> map) throws Exception {
		log.debug("수정된 회원정보들 업데이트");
		userDAO.updateUserInfo(map);
	}//modifyUserInfo
}//class
