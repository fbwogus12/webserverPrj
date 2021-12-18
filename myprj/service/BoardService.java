package service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import entity.Board;
import entity.BoardView;
import entity.ChildBoardInfo;
import entity.CmtBody;
import entity.Comment;
import entity.ParentBoardInfo;
import entity.ReComment;
import util.DatabaseUtil;

@SuppressWarnings("finally")
public class BoardService {// 게시판 글 등록, 관리자만 urg를 통해 상단 위치시키거나, pub = 0 을통해 숨김처리할 수 있음.
	public int insertCmt(Comment cmt) {
		int result = 0; // 기본값 0, 최종적으로는 몇 개가 삽입되었는지 저장
		long lastNum = 0;
		String findLastNum = "select max(id) as id from board_comment where category = ? and board_id = ?;";
		String sql = "insert into board_comment(id, nickname, content, writer, ip, board_id, category) values(?,?,?,?,?,?,?);";
		Connection conn = DatabaseUtil.getConnection();
		try {
			PreparedStatement findPstmt = conn.prepareStatement(findLastNum);
			findPstmt.setInt(1, cmt.getCategory());
			findPstmt.setLong(2, cmt.getBoardId());
			ResultSet rs = findPstmt.executeQuery();

			if (rs.next())
				lastNum = rs.getLong("id");

			conn.setAutoCommit(false);
			PreparedStatement pstmt = conn.prepareStatement(sql);

			pstmt.setLong(1, lastNum + 1);
			pstmt.setString(2, cmt.getNickname());
			pstmt.setString(3, cmt.getContent());
			pstmt.setString(4, cmt.getWriterId());
			pstmt.setString(5, cmt.getWriterIp());
			pstmt.setLong(6, cmt.getBoardId());
			pstmt.setInt(7, cmt.getCategory());

			result = pstmt.executeUpdate();

			conn.commit();
			rs.close();
			findPstmt.close();
			pstmt.close();

		} catch (SQLException e) {
			if (conn != null)
				conn.rollback();
			e.printStackTrace();
		} finally {
			if (conn != null)
				try {
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			return result; // 오류 발생 시 0 반환
		}
	}

	public int insertReCmt(ReComment reCmt) {
		int result = 0; // 기본값 0, 최종적으로는 몇 개가 삽입되었는지 저장
		long lastNum = 0;
		String findLastNum = "select max(id) as id from re_comment where category = ? and board_id = ? and cmt_id = ?;";
		String sql = "insert into re_comment(id, nickname, content, writer, ip, cmt_id, board_id, category) values(?,?,?,?,?,?,?,?);";
		Connection conn = DatabaseUtil.getConnection();
		try {
			PreparedStatement findPstmt = conn.prepareStatement(findLastNum);
			findPstmt.setInt(1, reCmt.getCategory());
			findPstmt.setLong(2, reCmt.getBoardId());
			findPstmt.setLong(3, reCmt.getCmtId());
			ResultSet rs = findPstmt.executeQuery();

			if (rs.next())
				lastNum = rs.getLong("id");

			conn.setAutoCommit(false);
			PreparedStatement pstmt = conn.prepareStatement(sql);

			pstmt.setLong(1, lastNum + 1);
			pstmt.setString(2, reCmt.getNickname());
			pstmt.setString(3, reCmt.getContent());
			pstmt.setString(4, reCmt.getWriterId());
			pstmt.setString(5, reCmt.getWriterIp());
			pstmt.setLong(6, reCmt.getCmtId());
			pstmt.setLong(7, reCmt.getBoardId());
			pstmt.setInt(8, reCmt.getCategory());

			result = pstmt.executeUpdate();

			conn.commit();
			rs.close();
			findPstmt.close();
			pstmt.close();

		} catch (SQLException e) {
			if (conn != null)
				conn.rollback();
			e.printStackTrace();
		} finally {
			if (conn != null)
				try {
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			return result; // 오류 발생 시 0 반환
		}
	}

	public int insertBoard(Board board) {
		int result = -1;
		long lastNum = 0;
		String findLastNum = "select max(id) as id from board where category = ?;";
		String sql = "insert into board(id, title, content, nickname, files, pub, urg, writer, ip, category, regdate) values(?,?,?,?,?,?,?,?,?,?,?);";
		Connection conn = DatabaseUtil.getConnection();
		try {
			PreparedStatement findPstmt = conn.prepareStatement(findLastNum);
			findPstmt.setInt(1, board.getCategory());
			ResultSet rs = findPstmt.executeQuery();

			if (rs.next())
				lastNum = rs.getLong("id");

			conn.setAutoCommit(false);
			PreparedStatement pstmt = conn.prepareStatement(sql);

			pstmt.setLong(1, ++lastNum);
			pstmt.setString(2, board.getTitle());
			pstmt.setString(3, board.getContent());
			pstmt.setString(4, board.getNickname());
			pstmt.setString(5, board.getFiles());
			pstmt.setBoolean(6, board.isPub());
			pstmt.setBoolean(7, board.isUrg());
			pstmt.setString(8, board.getWriterId());
			pstmt.setString(9, board.getWriterIp());
			pstmt.setInt(10, board.getCategory());
			pstmt.setString(11, board.getRegdate());

			pstmt.executeUpdate();

			conn.commit();
			rs.close();
			findPstmt.close();
			pstmt.close();

			// 에러 발생 시, result에 lastNum 저장 x
			result = (int) lastNum;
		} catch (SQLException e) {
			if (conn != null)
				conn.rollback();
			e.printStackTrace();
		} finally {
			if (conn != null)
				try {
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			return result; // 오류 발생 시 0을 반환함.
		}
	}

	// list에 뿌려줄 게시판 일반 글 가져오기, 일반 사용자 pubCheck == false
	public List<BoardView> getBoardUrgList(boolean isAdmin, int category) {
		List<BoardView> list = new ArrayList<>();
		// sql문 만들 때 띄어쓰기 하나하나 주의하자.
		String normSql = "select id from(select *, ROW_NUMBER() over(order by regdate desc)"
				+ "as rnum from board where pub = true and urg = true and category = ?)N";
		String adminSql = "select id from(select *, ROW_NUMBER() over(order by regdate desc)"
				+ "as rnum from board where category = ? and urg = true)N;";

		String sql = (isAdmin ? adminSql : normSql);

		String sql2 = "select * from board_view where id = ? and category = ?";
		Connection conn = DatabaseUtil.getConnection();
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			PreparedStatement pstmt2 = null;
			ResultSet rs2 = null;
			pstmt.setInt(1, category);

			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {
				long id = rs.getLong("id");
				pstmt2 = conn.prepareStatement(sql2);
				pstmt2.setLong(1, id);
				pstmt2.setInt(2, category);

				rs2 = pstmt2.executeQuery();
				rs2.next();
				String title = rs2.getString("title");
				String nickname = rs2.getString("nickname");
				String regdate = rs2.getString("regdate");
				int hit = rs2.getInt("hit");
				String files = rs2.getString("files");
				int cmtCount = rs2.getInt("cmt_count");
				boolean urg = rs2.getBoolean("urg");
				boolean pub = rs2.getBoolean("pub");
				BoardView board = new BoardView(id, title, nickname, regdate, hit, files, pub, cmtCount, urg);
				list.add(board);
			}

			rs.close();
			rs2.close();
			pstmt.close();
			pstmt2.close();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (conn != null)
				try {
					conn.close();
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
			return list;
		}
	}

	public List<BoardView> getBoardNormList(boolean isAdmin, int category) {
		return getBoardNormList("title", "", 1, isAdmin, category);
	}

	public List<BoardView> getBoardNormList(int page, boolean isAdmin, int category) {
		return getBoardNormList("title", "", page, isAdmin, category);
	}

	// list에 뿌려줄 게시판 강조 글 가져오기, 일반 사용자 pubCheck == false
	public List<BoardView> getBoardNormList(String field, String query, int page, boolean isAdmin, int category) {
		List<BoardView> list = new ArrayList<>();
		// sql문 만들 때 띄어쓰기 하나하나 주의하자.
		String normSql = "select id from(select *, ROW_NUMBER() over(order by regdate desc)"
				+ "as rnum from board where " + field + " like ? and pub = true and urg = false and category = ?) "
				+ "N where rnum between ? and ?;";
		String adminSql = "select id from(select *, ROW_NUMBER() over(order by regdate desc)"
				+ "as rnum from board where " + field + " like ? and category = ? and urg = false) "
				+ "N where rnum between ? and ?;";

		String sql = (isAdmin ? adminSql : normSql);

		String sql2 = "select * from board_view where id = ? and category = ?";
		Connection conn = DatabaseUtil.getConnection();
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			PreparedStatement pstmt2 = null;
			ResultSet rs2 = null;
			pstmt.setString(1, "%" + query + "%");
			pstmt.setInt(2, category);
			pstmt.setInt(3, 1 + (page - 1) * 10); // 전달된 페이지의 시작 번호, 한 페이지당 10개의 페이저를 갖는다.
			pstmt.setInt(4, page * 10);// 페이저의 끝 번호, 1~10 / 11~20 ...
			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {
				long id = rs.getLong("id");
				pstmt2 = conn.prepareStatement(sql2);
				pstmt2.setLong(1, id);
				pstmt2.setInt(2, category);

				rs2 = pstmt2.executeQuery();
				rs2.next();
				String title = rs2.getString("title");
				String nickname = rs2.getString("nickname");
				String regdate = rs2.getString("regdate");
				int hit = rs2.getInt("hit");
				String files = rs2.getString("files");
				int cmtCount = rs2.getInt("cmt_count");
				boolean urg = rs2.getBoolean("urg");
				boolean pub = rs2.getBoolean("pub");
				BoardView board = new BoardView(id, title, nickname, regdate, hit, files, pub, cmtCount, urg);
				list.add(board);
			}

			rs.close();
			rs2.close();
			pstmt.close();
			pstmt2.close();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (conn != null)
				try {
					conn.close();
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
			return (list.isEmpty()) ? null : list;
		}
	}

	// 댓글 페이저용 카운트
	public long getCmtCount(long boardId, int category) {
		String sql = "select count(id) from board_comment where board_id = ? and category = ?;";
		long count = 0;
		Connection conn = DatabaseUtil.getConnection();

		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setLong(1, boardId);
			pstmt.setInt(2, category);
			ResultSet rs = pstmt.executeQuery();
			if (rs.next())
				count = rs.getInt(1);

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (conn != null)
				try {
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			return count;
		}
	}

	// 검색어 없이, 처음 공지사항 목록 페이지에 들어왔을 때,
	public int getBoardCount(boolean isAdmin, int category) {
		return getBoardCount("title", "", isAdmin, category);
	}

	public int getBoardCount(String field, String query, boolean isAdmin, int category) {
		int count = 0; // 해당 검색 분류/검색어로 찾지 못하면 0을 반환
		String normSql = "select count(*) from (select * from(select *, ROW_NUMBER() "
				+ "over(order by regdate desc) as rnum from board where " + field
				+ " like ? and pub = true and urg = false and category = ?)N)N1;";

		String adminSql = "select count(*) from (select * from(select *, ROW_NUMBER() "
				+ "over(order by regdate desc) as rnum from board where " + field
				+ " like ? and category = ? and urg = false)N)N1;";

		String sql = (isAdmin ? adminSql : normSql);

		Connection conn = DatabaseUtil.getConnection();
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, "%" + query + "%");
			pstmt.setInt(2, category);
			ResultSet rs = pstmt.executeQuery();
			if (rs.next())
				count = rs.getInt(1);

			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (conn != null)
				try {
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			return count;
		}
	}

	public CmtBody getCmt(CmtBody cmt, boolean isAdmin) {
		String getCmt = "select writer from board_comment where id = ? and board_id = ? and category = ?;";
		String getRcmt = "select writer from re_comment where id = ? and cmt_id = ? and board_id = ? and category = ?;";
		CmtBody tmp = null;
		PreparedStatement pstmt = null;
		Connection conn = DatabaseUtil.getConnection();
		ResultSet rs = null;
		try {
			if (cmt instanceof Comment) {
				pstmt = conn.prepareStatement(getCmt);
				pstmt.setLong(1, ((Comment) cmt).getId());
				pstmt.setLong(2, ((Comment) cmt).getBoardId());
				pstmt.setInt(3, ((Comment) cmt).getCategory());

				rs = pstmt.executeQuery();
				if (rs.next()) {
					Comment cmtPlate = new Comment();
					cmtPlate.setWriterId(rs.getString("writer"));
					tmp = cmtPlate;
				}
			} else {
				pstmt = conn.prepareStatement(getRcmt);
				pstmt.setLong(1, ((ReComment) cmt).getId());
				pstmt.setLong(2, ((ReComment) cmt).getCmtId());
				pstmt.setLong(3, ((ReComment) cmt).getBoardId());
				pstmt.setInt(4, ((ReComment) cmt).getCategory());

				rs = pstmt.executeQuery();
				if (rs.next()) {
					ReComment rCmtPlate = new ReComment();
					rCmtPlate.setWriterId(rs.getString("writer"));
					tmp = rCmtPlate;
				}
			}

			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			if (conn != null)
				conn.rollback();
			e.printStackTrace();
		} finally {
			if (conn != null)
				try {
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			return tmp;
		}
	}

	public Board getBoard(long id, int category, boolean isAdmin) {
		Board board = null;
		String normSql = "select * from board where id = ? and pub = true and category = ?;";
		String adminSql = "select * from board where id = ? and category = ?;";

		String sql = (isAdmin ? adminSql : normSql);

		String hitUpdate = "update board set hit = ? where id = ? and category = ?;";
		int hit = 0;
		Connection conn = DatabaseUtil.getConnection();
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setLong(1, id);
			pstmt.setInt(2, category);

			ResultSet rs = pstmt.executeQuery();
			if (rs.next()) {
				String title = rs.getString("title");
				String content = rs.getString("content");
				String nickname = rs.getString("nickname");
				String ip = rs.getString("ip");
				String regdate = rs.getString("regdate");
				String files = rs.getString("files");
				String writerId = rs.getString("writer");
				boolean pub = rs.getBoolean("pub");
				boolean urg = rs.getBoolean("urg");
				hit = rs.getInt("hit");
				hit++;

				// 조회수 작업-------------------
				conn.setAutoCommit(false);
				PreparedStatement updatePstmt = conn.prepareCall(hitUpdate);
				updatePstmt.setInt(1, hit);
				updatePstmt.setLong(2, id);
				updatePstmt.setInt(3, category);
				updatePstmt.executeUpdate();
				conn.commit();
				updatePstmt.close();
				// -----------------------------

				board = new Board(id, title, nickname, writerId, ip, regdate, hit, files, content, pub, urg);
				board.setCategory(category);
			}

			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			if (conn != null)
				conn.rollback();
			e.printStackTrace();
		} finally {
			if (conn != null)
				try {
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			return board;
		}
	}

	// 일반 사용자나 admin의 detail에서 다음 글로 넘어갈 수 있게 id와 title을 넘겨준다. 일반 사용자 pubCheck ==
	// true, urg = false는 맨위로 옮겨질 강조글이 아닌 일반글을 가져오기 위함.. urg = true는 게시판 상단에 노출시킬
	// 강조글을 가져오기 위함.
	public Board getNextBoard(long id, int category, boolean isAdmin, boolean urg) {
		// String sql = "select id, title, pub from board where id = (select id from
		// (select id, @rownum:=@rownum+1 as rnum from board, (select @rownum:=0) as R
		// where regdate >(select regdate from board where id=? and category = ? and pub
		// = true))N where
		// rnum =1) and category = ?;";
		String normSql = "select id, title from board where id = (select min(id) as id from board where regdate > (select regdate from board where id = ? and category = ?) and category = ? and pub = true and urg = ?) and category = ?;";
		String adminSql = "select id, title, pub from board where id = (select min(id) as id from board where regdate > (select regdate from board where id = ? and category = ?) and category = ? and urg = ?) and category = ?;";

		String sql = (isAdmin ? adminSql : normSql);

		Board board = null;

		Connection conn = DatabaseUtil.getConnection();
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setLong(1, id);
			pstmt.setInt(2, category);
			pstmt.setInt(3, category);
			pstmt.setBoolean(4, urg);
			pstmt.setInt(5, category);
			ResultSet rs = pstmt.executeQuery();
			if (rs.next()) {
				long nextId = rs.getLong("id");
				String title = rs.getString("title");
				boolean pub = (isAdmin ? rs.getBoolean("pub") : true);

				board = new Board(nextId, title, pub);
			}

			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (conn != null)
				try {
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			return board;
		}
	}

	public Board getPrevBoard(long id, int category, boolean isAdmin, boolean urg) {
		String normSql = "select id, title from board where id = (select max(id) as id from board where regdate < (select regdate from board where id = ? and category = ?) and category = ? and pub = true and urg = ?) and category = ?;";
		String adminSql = "select id, title, pub from board where id = (select max(id) as id from board where regdate < (select regdate from board where id = ? and category = ?) and category = ? and urg = ?) and category = ?;";
		String sql = (isAdmin ? adminSql : normSql);
		Board board = null;

		Connection conn = DatabaseUtil.getConnection();
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setLong(1, id);
			pstmt.setInt(2, category);
			pstmt.setInt(3, category);
			pstmt.setBoolean(4, urg);
			pstmt.setInt(5, category);

			ResultSet rs = pstmt.executeQuery();
			if (rs.next()) {
				long prevId = rs.getLong("id");
				String title = rs.getString("title");
				boolean pub = (isAdmin ? rs.getBoolean("pub") : true);
				board = new Board(prevId, title, pub);
			}

			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (conn != null)
				try {
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			return board;
		}
	}

	// 1개의 게시글 공개, 비공개 설정
	public int updatePubBoard(Board board) {
		int result = 0; // 업데이트 완료된 튜플 개수 저장
		String sql = "update board set pub = ? where id = ? and category = ?;";
		Connection conn = DatabaseUtil.getConnection();

		try {// 공개 목록은 -1이 들어가므로 따로 조건 처리 안 해줘도 됨.
			conn.setAutoCommit(false);
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setBoolean(1, board.isPub());
			pstmt.setLong(2, board.getId());
			pstmt.setInt(3, board.getCategory());
			result = pstmt.executeUpdate();
			conn.commit();
			pstmt.close();
		} catch (SQLException e) {
			if (conn != null)
				try {
					conn.rollback();
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
			e.printStackTrace();
		} finally {
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			return result; // 업데이트된 총 튜플 개수 반환.
		}
	}

	// 게시글 공개, 비공개 설정
	public int updatePubInBoard(List<String> oids, List<String> cids, int category) {
		String oidsJoin = String.join(",", oids); // 리스트에 담아놓은 id들을 DB가 이해할 수 있도록 1,2,3... 으로 변경해줌
		String cidsJoin = String.join(",", cids);
		int result = 0; // 업데이트 완료된 튜플 개수 저장

		String updateOpen = "update board set pub = true where id in(" + oidsJoin + ") and category = ?";
		String updateClose = "update board set pub = false where id in(" + cidsJoin + ") and category = ?;";
		Connection conn = DatabaseUtil.getConnection();

		try {// 공개 목록은 -1이 들어가므로 따로 조건 처리 안 해줘도 됨.
			conn.setAutoCommit(false);
			PreparedStatement pstmtOpen = conn.prepareStatement(updateOpen);
			pstmtOpen.setInt(1, category);
			result += pstmtOpen.executeUpdate();
			if (!cidsJoin.equals("")) { // 비공개 목록이 아무것도 없으면 []이 전달되므로 DB 문법상 오류 발생
				PreparedStatement pstmtClose = conn.prepareStatement(updateClose);
				pstmtClose.setInt(1, category);
				result += pstmtClose.executeUpdate();
				pstmtClose.close();
			}
			conn.commit();
			pstmtOpen.close();
		} catch (SQLException e) {
			if (conn != null)
				try {
					conn.rollback();
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
			e.printStackTrace();
		} finally {
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			return result; // 업데이트된 총 튜플 개수 반환.
		}
	}

	// 1개의 게시글 공개, 비공개 설정
	public int updateBoardFiles(Board board) {
		int result = 0; // 업데이트 완료된 튜플 개수 저장
		String sql = "update board set files = ? where id = ? and category = ?;";
		Connection conn = DatabaseUtil.getConnection();

		try {// 공개 목록은 -1이 들어가므로 따로 조건 처리 안 해줘도 됨.
			conn.setAutoCommit(false);
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, board.getFiles());
			pstmt.setLong(2, board.getId());
			pstmt.setInt(3, board.getCategory());
			result = pstmt.executeUpdate();
			conn.commit();
			pstmt.close();
		} catch (SQLException e) {
			if (conn != null)
				try {
					conn.rollback();
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
			e.printStackTrace();
		} finally {
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			return result; // 업데이트된 총 튜플 개수 반환.
		}
	}

	// 하나의 댓글,대댓글 삭제 (주로 일반 사용자들, 신고 게시판에서도 이용)
	public int delCmt(CmtBody cmt) {
		int result = 0;
		String delCmt = "update board_comment set del = 1, ip = ? where id = ? and board_id =? and category = ?";
		String delReCmt = "update re_comment set del = 1, ip = ? where id = ? and cmt_id = ? and board_id =? and category = ?";
		Connection conn = DatabaseUtil.getConnection();
		try {
			PreparedStatement pstmt = null;
			if (cmt instanceof Comment) {
				conn.setAutoCommit(false);
				pstmt = conn.prepareStatement(delCmt);
				pstmt.setString(1, ((Comment) cmt).getWriterIp());
				pstmt.setLong(2, ((Comment) cmt).getId());
				pstmt.setLong(3, ((Comment) cmt).getBoardId());
				pstmt.setInt(4, ((Comment) cmt).getCategory());
				result = pstmt.executeUpdate();
				conn.commit();
			} else if (cmt instanceof ReComment) {
				conn.setAutoCommit(false);
				pstmt = conn.prepareStatement(delReCmt);
				pstmt.setString(1, ((ReComment) cmt).getWriterIp());
				pstmt.setLong(2, ((ReComment) cmt).getId());
				pstmt.setLong(3, ((ReComment) cmt).getCmtId());
				pstmt.setLong(4, ((ReComment) cmt).getBoardId());
				pstmt.setInt(5, ((ReComment) cmt).getCategory());
				result = pstmt.executeUpdate();
				conn.commit();
			}
			pstmt.close();
		} catch (SQLException e) {
			if (conn != null)
				try {
					conn.rollback();
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
			e.printStackTrace();
		} finally {
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			return result;
		}
	}

	// 하나의 댓글 삭제 (관리자용)
	public int perDelCmt(CmtBody cmt) {
		int result = 0;
		String perDelCmt = "delete from board_comment where id = ? and board_id = ? and category = ? and del = true";
		String perDelReCmt = "delete from re_comment where id = ? and cmt_id = ? and board_id = ? and category = ? and del = true";
		Connection conn = DatabaseUtil.getConnection();
		try {
			PreparedStatement pstmt = null;
			if (cmt instanceof Comment) {
				conn.setAutoCommit(false);
				pstmt = conn.prepareStatement(perDelCmt);
				pstmt.setLong(1, ((Comment) cmt).getId());
				pstmt.setLong(2, ((Comment) cmt).getBoardId());
				pstmt.setInt(3, ((Comment) cmt).getCategory());
				result = pstmt.executeUpdate();
				conn.commit();
			} else if (cmt instanceof ReComment) {
				conn.setAutoCommit(false);
				pstmt = conn.prepareStatement(perDelReCmt);
				pstmt.setLong(1, ((ReComment) cmt).getId());
				pstmt.setLong(2, ((ReComment) cmt).getCmtId());
				pstmt.setLong(3, ((ReComment) cmt).getBoardId());
				pstmt.setInt(4, ((ReComment) cmt).getCategory());
				result = pstmt.executeUpdate();
				conn.commit();
			}
			pstmt.close();
		} catch (SQLException e) {
			if (conn != null)
				try {
					conn.rollback();
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
			e.printStackTrace();
		} finally {
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			return result;
		}
	}

	// 하나의 게시글만 삭제할 때 사용
	public int deleteBoard(long id, int category) {
		long[] onlyone = new long[1];
		onlyone[0] = id;

		return deleteBoard(onlyone, category);
	}

	// 체크박스를 통해 여러 개의 공지사항 글을 삭제해야 할 때 사용
	public int deleteBoard(long[] dids, int category) {
		int result = 0;
		String didsForDB = "";
		for (int i = 0; i < dids.length; i++) {
			if (i < dids.length - 1) {
				didsForDB += dids[i];
				didsForDB += ",";
			} else
				didsForDB += dids[i];
		}

		String sql = "delete from board where id in(" + didsForDB + ") and category = ?;";

		// 해당 게시글의 모든 댓글과 대댓글 삭제
		String delAllCmt = "delete from board_comment where board_id in(" + didsForDB + ") and category = ?;";
		String delAllReCmt = "delete from re_comment where board_id in(" + didsForDB + ") and category = ?;";
		Connection conn = DatabaseUtil.getConnection();
		try {
			conn.setAutoCommit(false);
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, category);
			result += pstmt.executeUpdate();

			PreparedStatement pstmt2 = conn.prepareStatement(delAllCmt);
			pstmt2.setInt(1, category);
			pstmt2.executeUpdate();

			PreparedStatement pstmt3 = conn.prepareStatement(delAllReCmt);
			pstmt3.setInt(1, category);
			pstmt3.executeUpdate();
			conn.commit();

			pstmt.close();
			pstmt2.close();
			pstmt3.close();
		} catch (SQLException e) {
			result = 0;
			if (conn != null)
				try {
					conn.rollback();
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
			e.printStackTrace();
		} finally {
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			return result;
		}
	}

	// 1개의 게시글 공개, 비공개 설정
	public int updateUrgBoard(Board board) {
		int result = 0; // 업데이트 완료된 튜플 개수 저장
		String sql = "update board set urg = ? where id = ? and category = ?;";
		Connection conn = DatabaseUtil.getConnection();

		try {// 공개 목록은 -1이 들어가므로 따로 조건 처리 안 해줘도 됨.
			conn.setAutoCommit(false);
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setBoolean(1, board.isUrg());
			pstmt.setLong(2, board.getId());
			pstmt.setInt(3, board.getCategory());
			result = pstmt.executeUpdate();
			conn.commit();
			pstmt.close();
		} catch (SQLException e) {
			if (conn != null)
				try {
					conn.rollback();
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
			e.printStackTrace();
		} finally {
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			return result; // 업데이트된 총 튜플 개수 반환.
		}
	}

	public int updateUrgInBoard(List<String> uids, List<String> nids, int category) {
		String uidsJoin = String.join(",", uids); // 리스트에 담아놓은 id들을 DB가 이해할 수 있도록 1,2,3... 으로 변경해줌
		String nidsJoin = String.join(",", nids);

		int result = 0; // 업데이트 완료된 튜플 개수 저장

		String updateUrgent = "update board set urg = true where id in(" + uidsJoin + ") and category = ?;";
		String updateNormal = "update board set urg = false where id in(" + nidsJoin + ") and category = ?;";
		Connection conn = DatabaseUtil.getConnection();

		try {// 공개목록은 -1이 들어가게 되므로 따로 조건 처리 안 해줘도 됨.
			conn.setAutoCommit(false);
			PreparedStatement urgent = conn.prepareStatement(updateUrgent);
			urgent.setInt(1, category);
			result += urgent.executeUpdate();

			if (!nidsJoin.equals("")) {
				PreparedStatement normal = conn.prepareStatement(updateNormal);
				normal.setInt(1, category);
				result += normal.executeUpdate();
				normal.close();
			}
			conn.commit();
			urgent.close();
		} catch (SQLException e) {
			if (conn != null)
				try {
					conn.rollback();
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
			e.printStackTrace();
		} finally {
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			return result; // 업데이트된 총 튜플 개수 반환.
		}
	}

	public int modifyCmt(CmtBody cmt, boolean admin) {
		int result = 0;
		String updateCmt = "update board_comment set content = ?, ip = ? where id = ? and board_id = ? and category = ?;";
		String updateRcmt = "update re_comment set content = ?, ip = ? where id = ? and cmt_id = ? and board_id = ? and category = ?;";
		Connection conn = DatabaseUtil.getConnection();

		try {// 공개 목록은 -1이 들어가므로 따로 조건 처리 안 해줘도 됨.
			conn.setAutoCommit(false);
			PreparedStatement pstmt = null;
			if (cmt instanceof Comment) {
				pstmt = conn.prepareStatement(updateCmt);
				pstmt.setString(1, ((Comment) cmt).getContent());
				pstmt.setString(2, ((Comment) cmt).getWriterIp());
				pstmt.setLong(3, ((Comment) cmt).getId());
				pstmt.setLong(4, ((Comment) cmt).getBoardId());
				pstmt.setInt(5, ((Comment) cmt).getCategory());
				result = pstmt.executeUpdate();
			} else if (cmt instanceof ReComment) {
				pstmt = conn.prepareStatement(updateRcmt);
				pstmt.setString(1, ((ReComment) cmt).getContent());
				pstmt.setString(2, ((ReComment) cmt).getWriterIp());
				pstmt.setLong(3, ((ReComment) cmt).getId());
				pstmt.setLong(4, ((ReComment) cmt).getCmtId());
				pstmt.setLong(5, ((ReComment) cmt).getBoardId());
				pstmt.setInt(6, ((ReComment) cmt).getCategory());
				result = pstmt.executeUpdate();
			}
			conn.commit();
			pstmt.close();
		} catch (SQLException e) {
			if (conn != null)
				try {
					conn.rollback();
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
			e.printStackTrace();
		} finally {
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			return result; // 업데이트된 총 튜플 개수 반환.
		}
	}

	public int modifyBoard(Board board) {
		int result = 0;
		String sql = "update board set title= ?, content = ?, files = ?, ip = ? where id = ? and category = ?;";
		Connection conn = DatabaseUtil.getConnection();

		try {// 공개 목록은 -1이 들어가므로 따로 조건 처리 안 해줘도 됨.
			conn.setAutoCommit(false);
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, board.getTitle());
			pstmt.setString(2, board.getContent());
			pstmt.setString(3, board.getFiles());
			pstmt.setString(4, board.getWriterIp());
			pstmt.setLong(5, board.getId());
			pstmt.setInt(6, board.getCategory());

			result = pstmt.executeUpdate();

			conn.commit();
			pstmt.close();
		} catch (

		SQLException e) {
			if (conn != null)
				try {
					conn.rollback();
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
			e.printStackTrace();
		} finally {
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			return result; // 업데이트된 총 튜플 개수 반환.
		}
	}

	// 게시글 댓글 가져오기 위함.
	public List<Comment> getBoardComment(long boardId, int category, int page) {
		List<Comment> list = new ArrayList<>();
		List<ReComment> rList = new ArrayList<>();
		// sql문 만들 때 띄어쓰기 하나하나 주의하자.
		String sql = "select * from(select *, ROW_NUMBER() over(order by regdate asc) as rnum from board_comment where board_id = ? and category = ?)N where rnum between ? and ?";
		String rCmtSql = "select * from re_comment where cmt_id = ? and board_id = ? and category = ? order by regdate asc";

		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		ResultSet rs2 = null;
		Connection conn = DatabaseUtil.getConnection();
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setLong(1, boardId);
			pstmt.setInt(2, category);
			pstmt.setInt(3, 1 + (page - 1) * 10); // 전달된 페이지의 시작 번호, 한 페이지당 10개의 페이저를 갖는다.
			pstmt.setInt(4, page * 10);// 페이저의 끝 번호, 1~10 / 11~20 ...
			rs = pstmt.executeQuery();

			while (rs.next()) {
				long id = rs.getLong("id");
				String nickname = rs.getString("nickname");
				String content = rs.getString("content");
				String regdate = rs.getString("regdate");
				String writerId = rs.getString("writer");
				String writerIp = rs.getString("ip");
				boolean del = rs.getBoolean("del");

				pstmt2 = conn.prepareStatement(rCmtSql);
				pstmt2.setLong(1, id);
				pstmt2.setLong(2, boardId);
				pstmt2.setInt(3, category);
				rs2 = pstmt2.executeQuery();

				while (rs2.next()) {
					long rId = rs2.getLong("id");
					String rNickname = rs2.getString("nickname");
					String rContent = rs2.getString("content");
					String rRegdate = rs2.getString("regdate");
					String rWriterId = rs2.getString("writer");
					String rWriterIp = rs2.getString("ip");
					long targetCmt = rs2.getLong("cmt_id");
					boolean del2 = rs2.getBoolean("del");
					rList.add(new ReComment(rId, rNickname, rContent, rRegdate, rWriterId, rWriterIp, targetCmt, del2));
				}

				Comment cm = new Comment(id, nickname, content, regdate, writerId, writerIp, rList, del);
				list.add(cm);
			}
			rs.close();
			rs2.close();
			pstmt.close();
			pstmt2.close();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (conn != null)
				try {
					conn.close();
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
			return list;
		}
	}

	public Comment getCommentForReport(int category, long boardId, long cmtId) {
		Comment c = null;
		String sql = "select * from board_comment where category = ? and board_id = ? and id = ?;";
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection conn = DatabaseUtil.getConnection();
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, category);
			pstmt.setLong(2, boardId);
			pstmt.setLong(3, cmtId);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				c = new Comment();
				c.setCategory(category);
				c.setBoardId(boardId);
				c.setId(cmtId);
				c.setContent(rs.getString("content"));
				c.setDel(rs.getBoolean("del"));
				c.setNickname(rs.getString("nickname"));
				c.setWriterId(rs.getString("writer"));
				c.setWriterIp(rs.getString("ip"));
				c.setRegdate(rs.getString("regdate"));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (conn != null)
				try {
					conn.close();
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
			return c;
		}
	}
	public ReComment getReCommentForReport(int category, long boardId, long cmtId, long rCmtId) {
		ReComment rc = null;
		String sql = "select * from re_comment where category = ? and board_id = ? and cmt_id = ? and id = ?;";
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection conn = DatabaseUtil.getConnection();
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, category);
			pstmt.setLong(2, boardId);
			pstmt.setLong(3, cmtId);
			pstmt.setLong(4, rCmtId);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				rc = new ReComment();
				rc.setCategory(category);
				rc.setBoardId(boardId);
				rc.setCmtId(cmtId);
				rc.setId(rCmtId);
				rc.setContent(rs.getString("content"));
				rc.setDel(rs.getBoolean("del"));
				rc.setNickname(rs.getString("nickname"));
				rc.setWriterId(rs.getString("writer"));
				rc.setWriterIp(rs.getString("ip"));
				rc.setRegdate(rs.getString("regdate"));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (conn != null)
				try {
					conn.close();
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
			return rc;
		}
	}
	
	//게시판 생성 및 삭제 관련
	
	//부모 게시판 생성하기
	public int regParentBoard(ParentBoardInfo pbi) {
		String sql = "insert into parent_board_info(category, name) values(?,?);";
		String findEmptyCategory = "select max(category) as category from parent_board_info;";
		int result = 0;
		Connection conn = DatabaseUtil.getConnection();
		try {
			Statement stmt = conn.createStatement();
			ResultSet rs = stmt.executeQuery(findEmptyCategory);
			int next = 1;
			if (rs.next())
				next = rs.getInt("category") + 1;

			conn.setAutoCommit(false);
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, next);
			pstmt.setString(2, pbi.getName());
			result = pstmt.executeUpdate();
			conn.commit();
			pstmt.close();
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			result = 0;
			e.printStackTrace();
		} finally {
			if (conn != null)
				try {
					conn.close();
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
			return result;
		}
	}
	
	//세부(자식) 게시판 생성하기
	public int regChildBoardInfo(ChildBoardInfo cbi) {
		String sql = "insert into child_board_info(category, name, kind, parent, admin, cmt_permit, read_permit) values(?,?,?,?,?,?,?);";
		String findEmptyCategory = "select max(category) as category from child_board_info;";
		int next = 1;
		int result = 0;
		Connection conn = DatabaseUtil.getConnection();
		try {
			PreparedStatement find = conn.prepareStatement(findEmptyCategory);
			ResultSet rs = find.executeQuery();
			if (rs.next())
				next = rs.getInt("category") + 1;

			conn.setAutoCommit(false);
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, next);
			pstmt.setString(2, cbi.getName());
			pstmt.setInt(3, cbi.getKind());
			pstmt.setInt(4, cbi.getParent());
			pstmt.setBoolean(5, cbi.getAdmin());
			pstmt.setBoolean(6, cbi.getCmtPermit());
			pstmt.setBoolean(7, cbi.getReadPermit());
			
			result = pstmt.executeUpdate();
			conn.commit();
			pstmt.close();
		} catch (SQLException e) {
			result = -1;
			e.printStackTrace();
		} finally {
			if (conn != null)
				try {
					conn.close();
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
			return result;
		}
	}
	
	//웹 페이지의 드롭다운 리스트를 구성하기 위한 메서드. 
	public List<ParentBoardInfo> getParentBoardInfo() {
		String sql = "select * from parent_board_info order by category asc;";
		List<ParentBoardInfo> list = new ArrayList<>();
		ParentBoardInfo pbi = null;
		Connection conn = DatabaseUtil.getConnection();
		try {
			Statement stmt = conn.createStatement();
			ResultSet rs = stmt.executeQuery(sql);

			while (rs.next()) {
				// 자식 게시판 전부 가져오기
				pbi = new ParentBoardInfo();
				pbi.setCategory(rs.getInt("category"));
				pbi.setName(rs.getString("name"));
				pbi.setChildren(getChildrenBoardInfo(pbi.getCategory()));
				list.add(pbi);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (conn != null)
				try {
					conn.close();
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
			return list;
		}
	}
	
	//위의 드롭다운 리스트를 구성하기 위한 부모 리스트 가져오기에서, 각 부모마다 할당된 자식 게시판을 전부 달아주는 메서드
	//1번 부모 게시판이 1,2,3,4번의 자식 게시판을 갖고 있다면 전부 연결해줘야 한다.
	public List<ChildBoardInfo> getChildrenBoardInfo(int parent) {
		String getChildren = "select * from child_board_info where parent = ?;";
		ChildBoardInfo cbi = null;
		List<ChildBoardInfo> list = new ArrayList<>();
		Connection conn = DatabaseUtil.getConnection();
		try {
			PreparedStatement pstmt = conn.prepareStatement(getChildren);
			pstmt.setInt(1, parent);
			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {
				cbi = new ChildBoardInfo();
				cbi.setCategory(rs.getInt("category"));
				cbi.setKind(rs.getInt("kind"));
				cbi.setName(rs.getString("name"));
				cbi.setParent(rs.getInt("parent"));
				cbi.setAdmin(rs.getBoolean("admin"));
				cbi.setCmtPermit(rs.getBoolean("cmt_permit"));
				cbi.setReadPermit(rs.getBoolean("read_permit"));

				list.add(cbi);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			list = null;
			e.printStackTrace();
		} finally {
			if (conn != null)
				try {
					conn.close();
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
			return list;
		}
	}
	//사용자가 세부 게시판을 클릭했을 경우, 리스트 컨트롤러에서 해당 게시판에 대한 정보를 담아서 사용자 브라우저에 넣어줘야 한다.
	//이때 사용할 메소드이다. 
	public ChildBoardInfo getChildBoardInfo(int category) {
		String getChild = "select * from child_board_info where category = ?;";
		ChildBoardInfo cbi = null;
		Connection conn = DatabaseUtil.getConnection();
		try {
			PreparedStatement pstmt = conn.prepareStatement(getChild);
			pstmt.setInt(1, category);
			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {
				cbi = new ChildBoardInfo();
				cbi.setCategory(rs.getInt("category"));
				cbi.setKind(rs.getInt("kind"));
				cbi.setName(rs.getString("name"));
				cbi.setParent(rs.getInt("parent"));
				cbi.setAdmin(rs.getBoolean("admin"));
				cbi.setCmtPermit(rs.getBoolean("cmt_permit"));
				cbi.setReadPermit(rs.getBoolean("read_permit"));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			cbi = null;
			e.printStackTrace();
		} finally {
			if (conn != null)
				try {
					conn.close();
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
			return cbi;
		}
	}
	
	//부모 게시판 정보 변경, 현재는 우선 순위 변경이 없음. 단순 이름 변경만 
	public int modParentBoardInfo(ParentBoardInfo pbi) {
		String sql = "update parent_board_info set name = ? where category = ?;";
		Connection conn = DatabaseUtil.getConnection();
		int result = 0;
		try {
			conn.setAutoCommit(false);
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, pbi.getName());
			pstmt.setInt(2, pbi.getCategory());
			result = pstmt.executeUpdate();

			conn.commit();
			pstmt.close();
		} catch (SQLException e) {
			result = -1;
			if (conn != null)
				try {
					conn.rollback();
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
			e.printStackTrace();
		} finally {
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			return result; 
		}
	}
	//자식 게시판 정보 변경, 후에 글 / 댓글 작성 권한, 미로그인 사용자 읽기 권한 등도 변경할 수 있게 바꿀 것.
		public int modChildBoardInfo(ChildBoardInfo cbi) {
			String sql = "update child_board_info set name = ? where category = ?;";
			Connection conn = DatabaseUtil.getConnection();
			int result = 0;
			try {
				conn.setAutoCommit(false);
				PreparedStatement pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, cbi.getName());
				pstmt.setInt(2, cbi.getCategory());
				result = pstmt.executeUpdate();

				conn.commit();
				pstmt.close();
			} catch (SQLException e) {
				result = -1;
				if (conn != null)
					try {
						conn.rollback();
					} catch (SQLException e1) {
						e1.printStackTrace();
					}
				e.printStackTrace();
			} finally {
				try {
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
				return result; 
			}
		}
	
	
	//부모 게시판 및 자식 게시판 삭제, 위에서 게시글을 board라고 표현했는데, 이제 Post르 통일. 설계 시 참고
	
	//이 메소드에서 혹은 이 메소드를 호출한 곳에서 반드시 삭제할 게시글에 업로드된 파일을 옮기는 작업 추가
	public int delAllPostAndCmt(String categories) {
		String delAllPost = "delete from board where category in(" + categories + ")";
		String delAllCmt = "delete from board_comment where category in(" + categories + ")";
		String delAllReCmt = "delete from re_comment where category in(" + categories + ")";
		int result = 0;
		Connection conn = DatabaseUtil.getConnection();
		try {
			conn.setAutoCommit(false);
			PreparedStatement pstmt = conn.prepareStatement(delAllPost);
			result += pstmt.executeUpdate();
			PreparedStatement pstmt2 = conn.prepareStatement(delAllCmt);
			result +=pstmt2.executeUpdate();

			PreparedStatement pstmt3 = conn.prepareStatement(delAllReCmt);
			result +=pstmt3.executeUpdate();
			conn.commit();
			
			conn.commit();
			pstmt.close();
			pstmt2.close();
			pstmt3.close();
		} catch (SQLException e) {
			result = -1;
			if (conn != null)
				try {
					conn.rollback();
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
			e.printStackTrace();
		} finally {
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			return result;
		}
	}
	
	public int delChildBoardInfo(int category) {
		String category_ = String.valueOf(category);
		return delChildBoardInfo(category_);
	}
	
	public int delChildBoardInfo(String categories) {
		String delCbi = "delete from child_board_info where category in(" + categories + ");";
		int result = 0;
		
		Connection conn = DatabaseUtil.getConnection();
		try {
			conn.setAutoCommit(false);
			PreparedStatement pstmt = conn.prepareStatement(delCbi);
			delAllPostAndCmt(categories);//해당 자식 게시판의 모든 정보를 삭제, 폴더 유틸을 이용하여 삭제되는 게시판에 업로드된 파일이 있으면 모두 휴지통으로 옮기는 작업 추가할 것.
			result = pstmt.executeUpdate();
			conn.commit();

			pstmt.close();
		} catch (SQLException e) {
			result = 0;
			if (conn != null)
				try {
					conn.rollback();
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
			e.printStackTrace();
		} finally {
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			return result;
		}
	}
	
	public int delParentBoardInfo(int category) {
		String delPbi = "delete from parent_board_info where category = ?;";
		List<ChildBoardInfo> targetList = getChildrenBoardInfo(category);//부모 게시판이 삭제되면 자식 게시판도 모두 삭제해야 함.
		StringBuilder plate = new StringBuilder();
		int result = 0;
		
		for(ChildBoardInfo cbi : targetList) 
			plate.append(cbi.getCategory()+",");
		plate.setLength(plate.length()-1);
		
		Connection conn = DatabaseUtil.getConnection();
		try {
			conn.setAutoCommit(false);
			PreparedStatement pstmt = conn.prepareStatement(delPbi);
			pstmt.setInt(1, category);
			delChildBoardInfo(plate.toString());//해당 부모 게시판에 속해 있는 자식 게시판의 모든 정보를 삭제. 이 메소드 안에서 게시글, 댓글 등의 정보 모두 삭제.
			result = pstmt.executeUpdate();
			conn.commit();

			pstmt.close();
		} catch (SQLException e) {
			result = 0;
			if (conn != null)
				try {
					conn.rollback();
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
			e.printStackTrace();
		} finally {
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			return result;
		}
	}
}
