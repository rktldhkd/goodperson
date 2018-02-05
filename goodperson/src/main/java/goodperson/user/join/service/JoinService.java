package goodperson.user.join.service;

import java.util.Map;

public interface JoinService {
	/*
	 * 뒤에 throws Exception을 붙였다. 이는 추후 에러처리를 위한것으로, 원래 자바에서는 에러처리를 위하여 try,
	 * catch 문을 이용하여 적절한 에러처리를 해야한다. 그렇지만 모든곳에서 동일한 에러처리를 하는것은 현실적으로 힘들고, 예상하지
	 * 못한 에러도 발생할 수 있다. 그래서 모든 메서드에서는 에러가 발생하면 Exception을 날리고, 공통으로 이 Exception을
	 * 처리하는 로직을 추후 추가하려고 한다. 이는 나중에 에러처리 포스팅을 하면서 설명하겠다.
	 */
	int duplicateUserId(String userId) throws Exception;
	
	//다음 API 사용으로 인한 주석 처리
	//List<Map<String, Object>> selectAddrList() throws Exception;
	
	void insertUser(Map<String, Object> map) throws Exception;
}// interface