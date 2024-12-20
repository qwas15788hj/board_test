package egovframework.LocalBoard.mapper;

import java.util.List;

import egovframework.LocalBoard.dto.ExcelDTO;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface ExcelMapper {

	void insertExcel(ExcelDTO excel);

	List<ExcelDTO> excelDownload();

}
