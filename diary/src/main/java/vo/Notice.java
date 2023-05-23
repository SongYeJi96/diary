package vo;
// notice 테이블의 한행(레코드)을 저장하는 용도
// Value Object or Data Transfer Object or Domain

public class Notice {
	public int noticeNo;
	public String noticeTitle;
	public String noticeContent;
	public String noticeWriter;
	public String createdate; // DB에서 날짜 타입을 가져올때는 String 타입으로 가져온다. 실무에서는 date타입 사용.
	public String updatedate;
	public String noticePw;
}
