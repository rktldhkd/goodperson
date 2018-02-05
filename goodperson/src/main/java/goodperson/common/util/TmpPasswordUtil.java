package goodperson.common.util;

import org.springframework.stereotype.Component;

@Component("tmpPasswordUtils")
public class TmpPasswordUtil{
	public String issueTmpPwd()  throws Exception{
		int index = 0;
		char[] charSet	= new char[]{
														'0','1','2','3','4','5','6','7','8','9',
														'A','B','C','D','E','F','G','H','I','J','K','L','M','N',
														'O','P','Q','R','S','T','U','V','W','X','Y','Z','a','b',
														'c','d','e','f','g','h','i','j','k','l','m','n','o','p',
														'q','r','s','t','u','v','w','x','y','z','!', '@', '#', '$', '%',
														'^', '&', '*', '+' ,'_',
													};
		
		StringBuffer sb 		= new StringBuffer(); // 임시비밀번호 저장할 변수.
		int numberFigures	= 15; // 자리수
		for(int i=0; i<numberFigures; i++){
			index = (int)(Math.random()*charSet.length);
			sb.append(charSet[index]);
		}//end for
		
		return sb.toString();
	}//issueTmpPwd
}//class
