package egovframework.LocalBoard.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.LocalBoard.dto.ExcelDTO;
import egovframework.LocalBoard.mapper.ExcelMapper;

@Service
public class ExcelServiceImpl implements ExcelService {
	
	@Autowired
	private ExcelMapper excelMapper;

	@Override
	public void insertExcel(ExcelDTO excel) {
		excelMapper.insertExcel(excel);
	}

	@Override
	public List<ExcelDTO> excelDownload() {
		return excelMapper.excelDownload();
	}
	
}
