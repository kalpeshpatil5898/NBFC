package com.project.NBFC.Repo;

import org.springframework.data.jpa.repository.JpaRepository;

import com.project.NBFC.Model.Guarantors;

public interface GuarantorRepo extends JpaRepository<Guarantors,Integer> {

}
