--select convert(char(10),getdate(),112)

-- MA Claims
select   distinct 
         trim(isnull(eop.claim_id,''))+'-'+trim(isnull(eop.check_num,''))+'-'+isnull(convert(char(10),eop.check_date,112),'') 'ClaimId-NoCheque-FechaPago',
         eop.mbr_id MemberID,
         eop.claim_id ClaimUniqueIdentifier,
         isnull(convert(char(10),eop.check_date,112),'') ClaimPaidDate,
         isnull(convert(char(10),cl_rcvd_dt,112),'') ClaimReceivedDate,
         isnull(convert(char(10),cl_admit_dt,112),'') MemberAdmissionDate,
         isnull(convert(char(10),cl_disch_dt,112),'') MemberDischargeDate,
         -- ClaimInpatientAdmissionTypeCode
         -- ClaimBillFacilityTypeCode
         'N/A' ClaimServiceClassificationTypeCode,
         -- ClaimProcessingStatusCode
         ClaimTypeCode = 
            case
               when ct_svc_codemod like 'R%' then 'UB04'
               else '1500'
            end,
         isnull(patient_status,'') PatientDischargeStatusCode,
         pf_bill.npi ClaimBillingProviderNPI,
         '' ClaimReferringProviderNPI,
         pf_rend.npi ClaimPerformingProviderNPI,
         trim(trim(pf_bill.f_name)+' '+trim(pf_bill.l_name)) ClaimBillingProviderName,
         trim(trim(pf_rend.f_name)+' '+trim(pf_rend.l_name)) ClaimPerformingProviderName, 
         cl_diag1 DiagnosisCode,
         icd.short_desc DiagnosisDescription,
         'N/A' DiagnosisCodeType,
         'ABK' DiagnosisType,
         eop.line_no LineNumber,
         isnull(convert(char(10),ct_svc_begin_dt,112),'') ServiceFromDate,
         isnull(convert(char(10),ct_svc_end_dt,112),'')  ServiceToDate,
         ct_loc_new  PlaceOfServiceCode,
         ct_units NumberOfUnits,
         0 LineAmountPaidToProvider,
         0 LineCoinsuranceAmount,
         0 LineSubmittedAmount,
         0 LineAllowedAmount,
         0 LineCopayAmount
from     member..eop_detail eop
         left join member..rpx_claims on eop.claim_id = cl_claim_id
         left join processdb..icd_codes icd on cl_diag1 = icd_code
         left join member..rpx_claims_trans ct on ct_claim_id = eop.claim_id and ct_claim_seq = eop.line_no
         left join processdb..prov_final pf_bill on eop.bill_prov_id = pf_bill.provider_id
         left join processdb..prov_final pf_rend on eop.prov_id = pf_rend.provider_id
where    eop.claim_id in
         -- MA LIST --
         -- (
         -- 'CLPR58848106',
         -- 'CLPR58830443',
         -- 'CLPR58881889',
         -- 'CLPR10250676',
         -- 'CLPR58861992',
         -- 'CLPR10262812',
         -- 'CLPR10238454',
         -- 'CLPR58897841',
         -- 'CLPR58889398',
         -- 'CLPR58911235'
         -- )

         -- VITAL LIST --
         (
         'CLPR58876885',
         'CLPR58876889',
         'CLPR58876891',
         'CLPR58876892',
         'CLPR58876894',
         'CLPR58877071',
         'CLPR58877071',
         'CLPR58877072',
         'CLPR58877095',
         'CLPR58877095'         
         )
         
         and
         trim(isnull(eop.claim_id,''))+'-'+isnull(eop.check_num,'')+'-'+isnull(convert(char(10),eop.check_date,112),'') in
         
         -- TSA --
         -- (
         -- 'CLPR58848106-166849-20220520',
         -- 'CLPR58830443-166533-20220513',
         -- 'CLPR58881889-167709-20220603',
         -- 'CLPR10250676-168709-20220617',
         -- 'CLPR58861992-167420-20220527',
         -- 'CLPR10262812-170995-20220729',
         -- 'CLPR10238454-166456-20220513',
         -- 'CLPR58897841-168200-20220610',
         -- 'CLPR58889398-168073-20220610',
         -- 'CLPR58911235-168529-20220617'
         -- )

         -- Vital --
         (
         'CLPR58876885--20220603',
         'CLPR58876889--20220603',
         'CLPR58876891--20220603',
         'CLPR58876892--20220603',
         'CLPR58876894--20220603',
         'CLPR58877071--20220603',
         'CLPR58877071-082963-20220603',
         'CLPR58877072--20220603',
         'CLPR58877095--20220603',
         'CLPR58877095-082914-20220603'
         )
