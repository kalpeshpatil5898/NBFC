/*
DELETE from Users where account_no = 211001001;
COMMIT;
INSERT INTO public.Users(account_no,balance,branch) values(211001001,0,'NBFC');*/

INSERT INTO public.Users(account_no,balance,branch) values(211001000,0,'NBFC') ON CONFLICT (account_no) DO NOTHING;
INSERT INTO public.admin_login(aid, aemail, apass)	VALUES (1, 'admin@nbfc.com', 'admin') ON CONFLICT (aid) DO NOTHING;
INSERT INTO public.NBFC(id,wallet_Balance,total_Repayments,total_Disbursed,total_Loans,total_Users) values (1,5000000,0,0,0,0) ON CONFLICT (id) DO NOTHING;