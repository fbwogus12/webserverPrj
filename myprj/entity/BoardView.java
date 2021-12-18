package entity;

public class BoardView extends Board {
	private int cmtCount;
	public int getCmtCount() {
		return cmtCount;
	}
	public void setCmtCount(int cmtCount) {
		this.cmtCount = cmtCount;
	}

	public BoardView() {};

	public BoardView(String title, String nickname, String files, boolean pub, int cmtCount, int reCmtCount,boolean urg) {
		super(title, nickname, files, "", pub, urg); //내용은 넘겨받지 않았으므로	빈 문자열, 기본값으로 대체
		this.cmtCount = cmtCount;//단순 리스트 출력용
	}
	
	//getBoardList를 위한 생성자.
	public BoardView(Long id, String title, String nickname, String regdate, int hit, String files, boolean pub,
			int cmtCount, boolean urg) {
		super(id, title, nickname, regdate, hit, files, "", pub, urg); // 내용은 넘겨받지 않았으므로
		this.cmtCount = cmtCount;	            	                // 빈 문자열, 기본값으로 대체
	}
}
