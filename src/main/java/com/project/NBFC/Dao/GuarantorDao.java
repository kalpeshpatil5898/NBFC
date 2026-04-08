package com.project.NBFC.Dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.project.NBFC.Model.Guarantors;
import com.project.NBFC.Repo.GuarantorRepo;
import com.project.NBFC.Services.GuarantorService;

@Service
public class GuarantorDao implements GuarantorService {
	
	@Autowired
	GuarantorRepo gr;

	@Override
	public Guarantors saveGuarantor(Guarantors g) {
		// TODO Auto-generated method stub
		return gr.save(g);
	}

}
