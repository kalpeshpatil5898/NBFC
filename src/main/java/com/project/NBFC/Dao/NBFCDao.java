package com.project.NBFC.Dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.project.NBFC.Model.NBFC;
import com.project.NBFC.Repo.NBFCRepo;
import com.project.NBFC.Services.NBFCService;

@Service
public class NBFCDao implements NBFCService
{
	@Autowired
	NBFCRepo nr;

	@Override
	public void saveNBFCinfo(NBFC obj) {
		nr.save(obj);
	}

	@Override
	public NBFC getbyid(int id) {
		return nr.getById(id);
	}
	
	

}
