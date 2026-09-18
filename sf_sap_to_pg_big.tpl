{
  "Comment": "SAP to S3 multi-query extract using a single sap_2_s3 Glue job",
  "StartAt": "Extract_ACDOCA",
  "States": {
    "Extract_ACDOCA": {
      "Comment": "Full extract of SAPPRD.ACDOCA",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "acdoca",
          "--query": "SELECT \"RCLNT\", \"RLDNR\", \"RBUKRS\", \"GJAHR\", \"BELNR\", \"DOCLN\", \"RYEAR\", \"DOCNR_LD\", \"RRCTY\", \"RMVCT\", \"VORGN\", \"VRGNG\", \"BTTYPE\", \"AWTYP\", \"AWSYS\", \"AWORG\", \"AWREF\", \"AWITEM\", \"AWITGRP\", \"SUBTA\", \"XREVERSING\", \"XREVERSED\", \"XTRUEREV\", \"AWTYP_REV\", \"AWORG_REV\", \"AWREF_REV\", \"SUBTA_REV\", \"XSETTLING\", \"XSETTLED\", \"PREC_AWTYP\", \"PREC_AWSYS\", \"PREC_AWORG\", \"PREC_AWREF\", \"PREC_AWITEM\", \"PREC_SUBTA\", \"PREC_AWMULT\", \"XSECONDARY\", \"SRC_AWTYP\", \"SRC_AWSYS\", \"SRC_AWORG\", \"SRC_AWREF\", \"SRC_AWITEM\", \"SRC_AWSUBIT\", \"XCOMMITMENT\", \"RTCUR\", \"RWCUR\", \"RHCUR\", \"RKCUR\", \"ROCUR\", \"RVCUR\", \"RBCUR\", \"RCCUR\", \"RDCUR\", \"RECUR\", \"RFCUR\", \"RGCUR\", \"RCO_OCUR\", \"RUNIT\", \"RVUNIT\", \"RRUNIT\", \"RIUNIT\", \"QUNIT1\", \"QUNIT2\", \"QUNIT3\", \"CO_MEINH\", \"RACCT\", \"RCNTR\", \"PRCTR\", \"RFAREA\", \"RBUSA\", \"KOKRS\", \"SEGMENT\", \"SCNTR\", \"PPRCTR\", \"SFAREA\", \"SBUSA\", \"RASSC\", \"PSEGMENT\", \"TSL\", \"WSL\", \"WSL2\", \"WSL3\", \"HSL\", \"KSL\", \"OSL\", \"VSL\", \"BSL\", \"CSL\", \"DSL\", \"ESL\", \"FSL\", \"GSL\", \"KFSL\", \"KFSL2\", \"KFSL3\", \"PSL\", \"PSL2\", \"PSL3\", \"PFSL\", \"PFSL2\", \"PFSL3\", \"CO_OSL\", \"HSALK3\", \"KSALK3\", \"OSALK3\", \"VSALK3\", \"HSALKV\", \"KSALKV\", \"OSALKV\", \"VSALKV\", \"HPVPRS\", \"KPVPRS\", \"OPVPRS\", \"VPVPRS\", \"HSTPRS\", \"KSTPRS\", \"OSTPRS\", \"VSTPRS\", \"HSLALT\", \"KSLALT\", \"OSLALT\", \"VSLALT\", \"HSLEXT\", \"KSLEXT\", \"OSLEXT\", \"VSLEXT\", \"HVKWRT\", \"HVKSAL\", \"MSL\", \"MFSL\", \"VMSL\", \"VMFSL\", \"RMSL\", \"QUANT1\", \"QUANT2\", \"QUANT3\", \"CO_MEGBTR\", \"CO_MEFBTR\", \"LBKUM\", \"DRCRK\", \"POPER\", \"PERIV\", \"FISCYEARPER\", \"BUDAT\", \"BLDAT\", \"BLART\", \"BUZEI\", \"ZUONR\", \"BSCHL\", \"BSTAT\", \"LINETYPE\", \"KTOSL\", \"SLALITTYPE\", \"XSPLITMOD\", \"USNAM\", \"TIMESTAMP\", \"EPRCTR\", \"RHOART\", \"GLACCOUNT_TYPE\", \"KTOPL\", \"LOKKT\", \"KTOP2\", \"REBZG\", \"REBZJ\", \"REBZZ\", \"REBZT\", \"RBEST\", \"EBELN\", \"EBELP\", \"ZEKKN\", \"SGTXT\", \"KDAUF\", \"KDPOS\", \"MATNR\", \"WERKS\", \"LIFNR\", \"KUNNR\", \"FBUDA\", \"KOART\", \"UMSKZ\", \"MWSKZ\", \"HBKID\", \"HKTID\", \"XOPVW\", \"AUGDT\", \"AUGBL\", \"AUGGJ\", \"AFABE\", \"ANLN1\", \"ANLN2\", \"BZDAT\", \"ANBWA\", \"MOVCAT\", \"DEPR_PERIOD\", \"ANLGR\", \"ANLGR2\", \"SETTLEMENT_RULE\", \"ANLKL\", \"KTOGR\", \"PANL1\", \"PANL2\", \"UBZDT_PN\", \"XVABG_PN\", \"PROZS_PN\", \"XMANPROPVAL_PN\", \"KALNR\", \"VPRSV\", \"MLAST\", \"KZBWS\", \"XOBEW\", \"SOBKZ\", \"VTSTAMP\", \"MAT_KDAUF\", \"MAT_KDPOS\", \"MAT_PSPNR\", \"MAT_PS_POSID\", \"MAT_LIFNR\", \"BWTAR\", \"BWKEY\", \"HPEINH\", \"KPEINH\", \"OPEINH\", \"VPEINH\", \"MLPTYP\", \"MLCATEG\", \"QSBVALT\", \"QSPROCESS\", \"PERART\", \"MLPOSNR\", \"BUKRS_SENDER\", \"RACCT_SENDER\", \"ACCAS_SENDER\", \"ACCASTY_SENDER\", \"OBJNR\", \"HRKFT\", \"HKGRP\", \"PAROB1\", \"PAROBSRC\", \"USPOB\", \"CO_BELKZ\", \"CO_BEKNZ\", \"BELTP\", \"MUVFLG\", \"GKONT\", \"GKOAR\", \"ERLKZ\", \"PERNR\", \"PAOBJNR\", \"XPAOBJNR_CO_REL\", \"SCOPE\", \"LOGSYSO\", \"PBUKRS\", \"PSCOPE\", \"LOGSYSP\", \"BWSTRAT\", \"OBJNR_HK\", \"AUFNR_ORG\", \"UKOSTL\", \"ULSTAR\", \"UPRZNR\", \"UPRCTR\", \"ACCAS\", \"ACCASTY\", \"LSTAR\", \"AUFNR\", \"AUTYP\", \"PS_PSP_PNR\", \"PS_POSID\", \"PS_PSPID\", \"NPLNR\", \"NPLNR_VORGN\", \"PRZNR\", \"KSTRG\", \"BEMOT\", \"RSRCE\", \"QMNUM\", \"ERKRS\", \"PACCAS\", \"PACCASTY\", \"PLSTAR\", \"PAUFNR\", \"PAUTYP\", \"PPS_POSID\", \"PPS_PSPID\", \"PKDAUF\", \"PKDPOS\", \"PPAOBJNR\", \"PNPLNR\", \"PNPLNR_VORGN\", \"PPRZNR\", \"PKSTRG\", \"CO_ACCASTY_N1\", \"CO_ACCASTY_N2\", \"CO_ACCASTY_N3\", \"CO_ZLENR\", \"CO_BELNR\", \"CO_BUZEI\", \"CO_BUZEI1\", \"CO_BUZEI2\", \"CO_BUZEI5\", \"CO_BUZEI6\", \"CO_BUZEI7\", \"CO_REFBZ\", \"CO_REFBZ1\", \"CO_REFBZ2\", \"CO_REFBZ5\", \"CO_REFBZ6\", \"CO_REFBZ7\", \"WORK_ITEM_ID\", \"ARBID\", \"VORNR\", \"AUFPS\", \"UVORN\", \"EQUNR\", \"TPLNR\", \"ISTRU\", \"ILART\", \"PLKNZ\", \"ARTPR\", \"PRIOK\", \"MAUFNR\", \"MATKL_MM\", \"PLANNED_PARTS_WORK\", \"FKART\", \"VKORG\", \"VTWEG\", \"SPART\", \"MATNR_COPA\", \"MATKL\", \"KDGRP\", \"LAND1\", \"BRSCH\", \"BZIRK\", \"KUNRE\", \"KUNWE\", \"KONZS\", \"ACDOC_COPA_EEW_DUMMY_PA\", \"AUGRU_PA\", \"WWBUC_PA\", \"WWFRA_PA\", \"WWPDT_PA\", \"WWSEG_PA\", \"WWSPA_PA\", \"WWSPB_PA\", \"WWSR_PA\", \"WWST_PA\", \"VBUND_PA\", \"RE_BUKRS\", \"RE_ACCOUNT\", \"FIKRS\", \"FISTL\", \"MEASURE\", \"RFUND\", \"RGRANT_NBR\", \"RBUDGET_PD\", \"SFUND\", \"SGRANT_NBR\", \"SBUDGET_PD\", \"VNAME\", \"EGRUP\", \"RECID\", \"VPTNR\", \"BTYPE\", \"ETYPE\", \"PRODPER\", \"SWENR\", \"SGENR\", \"SGRNR\", \"SMENR\", \"RECNNR\", \"SNKSL\", \"SEMPSL\", \"DABRZ\", \"PSWENR\", \"PSGENR\", \"PSGRNR\", \"PSMENR\", \"PRECNNR\", \"PSNKSL\", \"PSEMPSL\", \"PDABRZ\", \"ACDOC_EEW_DUMMY\", \"DUMMY_INCL_EEW_COBL\", \"FUP_ACTION\", \"MIG_SOURCE\", \"MIG_DOCLN\", \"_DATAAGING\", \"WWBRD_PA\", \"WWCPD_PA\", \"WWMVN_PA\", \"WWPTY_PA\", \"WWRIT_PA\", \"WWTHN_PA\" FROM \"SAPPRD\".\"ACDOCA\"",
          "--final_file_name": "from_SAP/for_ingestion/acdoca_output.json"
        }
      },
      "Catch": [
        {
          "ErrorEquals": [
            "States.ALL"
          ],
          "ResultPath": "$.glue_error",
          "Next": "Notify_Fail"
        }
      ],
      "Next": "Load_ACDOCA"
    },

    "Load_ACDOCA": {
      "Comment": "Full extract of SAPPRD.ACDOCA",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--table_name": "acdoca",
          "--nonstring_schema": "{\"prec_awmult\": \"bytea\", \"tsl\": \"numeric\", \"wsl\": \"numeric\", \"wsl2\": \"numeric\", \"wsl3\": \"numeric\", \"hsl\": \"numeric\", \"ksl\": \"numeric\", \"osl\": \"numeric\", \"vsl\": \"numeric\", \"bsl\": \"numeric\", \"csl\": \"numeric\", \"dsl\": \"numeric\", \"esl\": \"numeric\", \"fsl\": \"numeric\", \"gsl\": \"numeric\", \"kfsl\": \"numeric\", \"kfsl2\": \"numeric\", \"kfsl3\": \"numeric\", \"psl\": \"numeric\", \"psl2\": \"numeric\", \"psl3\": \"numeric\", \"pfsl\": \"numeric\", \"pfsl2\": \"numeric\", \"pfsl3\": \"numeric\", \"co_osl\": \"numeric\", \"hsalk3\": \"numeric\", \"ksalk3\": \"numeric\", \"osalk3\": \"numeric\", \"vsalk3\": \"numeric\", \"hsalkv\": \"numeric\", \"ksalkv\": \"numeric\", \"osalkv\": \"numeric\", \"vsalkv\": \"numeric\", \"hpvprs\": \"numeric\", \"kpvprs\": \"numeric\", \"opvprs\": \"numeric\", \"vpvprs\": \"numeric\", \"hstprs\": \"numeric\", \"kstprs\": \"numeric\", \"ostprs\": \"numeric\", \"vstprs\": \"numeric\", \"hslalt\": \"numeric\", \"kslalt\": \"numeric\", \"oslalt\": \"numeric\", \"vslalt\": \"numeric\", \"hslext\": \"numeric\", \"kslext\": \"numeric\", \"oslext\": \"numeric\", \"vslext\": \"numeric\", \"hvkwrt\": \"numeric\", \"hvksal\": \"numeric\", \"msl\": \"numeric\", \"mfsl\": \"numeric\", \"vmsl\": \"numeric\", \"vmfsl\": \"numeric\", \"rmsl\": \"numeric\", \"quant1\": \"numeric\", \"quant2\": \"numeric\", \"quant3\": \"numeric\", \"co_megbtr\": \"numeric\", \"co_mefbtr\": \"numeric\", \"lbkum\": \"numeric\", \"timestamp\": \"numeric\", \"prozs_pn\": \"numeric\", \"vtstamp\": \"numeric\", \"hpeinh\": \"numeric\", \"kpeinh\": \"numeric\", \"opeinh\": \"numeric\", \"vpeinh\": \"numeric\"}"
        }
      },
      "Catch": [
        {
          "ErrorEquals": [
            "States.ALL"
          ],
          "ResultPath": "$.glue_error",
          "Next": "Notify_Fail"
        }
      ],
      "Next": "Extract_BSAK"
    },

    "Extract_BSAK": {
      "Comment": "Full extract of SAPPRD.BSAK",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "bsak",
          "--query": "SELECT \"MANDT\", \"BUKRS\", \"LIFNR\", \"UMSKS\", \"UMSKZ\", \"AUGDT\", \"AUGBL\", \"ZUONR\", \"GJAHR\", \"BELNR\", \"BUZEI\", \"BUDAT\", \"BLDAT\", \"CPUDT\", \"WAERS\", \"XBLNR\", \"BLART\", \"MONAT\", \"BSCHL\", \"ZUMSK\", \"SHKZG\", \"GSBER\", \"MWSKZ\", \"DMBTR\", \"WRBTR\", \"MWSTS\", \"WMWST\", \"BDIFF\", \"BDIF2\", \"SGTXT\", \"PROJN\", \"AUFNR\", \"ANLN1\", \"ANLN2\", \"EBELN\", \"EBELP\", \"SAKNR\", \"HKONT\", \"FKONT\", \"FILKD\", \"ZFBDT\", \"ZTERM\", \"ZBD1T\", \"ZBD2T\", \"ZBD3T\", \"ZBD1P\", \"ZBD2P\", \"SKFBT\", \"SKNTO\", \"WSKTO\", \"ZLSCH\", \"ZLSPR\", \"ZBFIX\", \"HBKID\", \"BVTYP\", \"REBZG\", \"REBZJ\", \"REBZZ\", \"SAMNR\", \"ZOLLT\", \"ZOLLD\", \"LZBKZ\", \"LANDL\", \"DIEKZ\", \"MANSP\", \"MSCHL\", \"MADAT\", \"MANST\", \"MABER\", \"XNETB\", \"XANET\", \"XCPDD\", \"XESRD\", \"XZAHL\", \"MWSK1\", \"DMBT1\", \"WRBT1\", \"MWSK2\", \"DMBT2\", \"WRBT2\", \"MWSK3\", \"DMBT3\", \"WRBT3\", \"QSSKZ\", \"QSSHB\", \"QBSHB\", \"BSTAT\", \"ANFBN\", \"ANFBJ\", \"ANFBU\", \"VBUND\", \"REBZT\", \"STCEG\", \"EGBLD\", \"EGLLD\", \"QSZNR\", \"QSFBT\", \"XINVE\", \"PROJK\", \"FIPOS\", \"NPLNR\", \"AUFPL\", \"APLZL\", \"XEGDR\", \"DMBE2\", \"DMBE3\", \"DMB21\", \"DMB22\", \"DMB23\", \"DMB31\", \"DMB32\", \"DMB33\", \"MWST2\", \"MWST3\", \"SKNT2\", \"SKNT3\", \"BDIF3\", \"XRAGL\", \"RSTGR\", \"UZAWE\", \"KOSTL\", \"LNRAN\", \"XSTOV\", \"KZBTR\", \"XREF1\", \"XREF2\", \"XARCH\", \"PSWSL\", \"PSWBT\", \"IMKEY\", \"ZEKKN\", \"FISTL\", \"GEBER\", \"DABRZ\", \"XNEGP\", \"EMPFB\", \"PRCTR\", \"XREF3\", \"DTWS1\", \"DTWS2\", \"DTWS3\", \"DTWS4\", \"XPYPR\", \"KIDNO\", \"PYCUR\", \"PYAMT\", \"BUPLA\", \"SECCO\", \"PPDIFF\", \"PPDIF2\", \"PPDIF3\", \"PENLC1\", \"PENLC2\", \"PENLC3\", \"PENFC\", \"PENDAYS\", \"PENRC\", \"VERTT\", \"VERTN\", \"VBEWA\", \"KBLNR\", \"KBLPOS\", \"GRANT_NBR\", \"GMVKZ\", \"SRTYPE\", \"LOTKZ\", \"ZINKZ\", \"FKBER\", \"INTRENO\", \"PPRCT\", \"BUZID\", \"AUGGJ\", \"HKTID\", \"BUDGET_PD\", \"_DATAAGING\", \"KONTT\", \"KONTL\", \"UEBGDAT\", \"VNAME\", \"EGRUP\", \"BTYPE\", \"PROPMANO\", \"GKONT\", \"GKART\", \"GHKON\" FROM \"SAPPRD\".\"BSAK\"",
          "--final_file_name": "from_SAP/for_ingestion/bsak_output.json"
        }
      },
      "Catch": [
        {
          "ErrorEquals": [
            "States.ALL"
          ],
          "ResultPath": "$.glue_error",
          "Next": "Notify_Fail"
        }
      ],
      "Next": "Load_BSAK"
    },

    "Load_BSAK": {
      "Comment": "Load SAPPRD.BSAK to Postgres",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--table_name": "bsak",
          "--nonstring_schema": "{\"dmbtr\":\"numeric\",\"wrbtr\":\"numeric\",\"mwsts\":\"numeric\",\"wmwst\":\"numeric\",\"bdiff\":\"numeric\",\"bdif2\":\"numeric\",\"zbd1t\":\"numeric\",\"zbd2t\":\"numeric\",\"zbd3t\":\"numeric\",\"zbd1p\":\"numeric\",\"zbd2p\":\"numeric\",\"skfbt\":\"numeric\",\"sknto\":\"numeric\",\"wskto\":\"numeric\",\"dmbt1\":\"numeric\",\"wrbt1\":\"numeric\",\"dmbt2\":\"numeric\",\"wrbt2\":\"numeric\",\"dmbt3\":\"numeric\",\"wrbt3\":\"numeric\",\"qsshb\":\"numeric\",\"qbshb\":\"numeric\",\"qsfbt\":\"numeric\",\"dmbe2\":\"numeric\",\"dmbe3\":\"numeric\",\"dmb21\":\"numeric\",\"dmb22\":\"numeric\",\"dmb23\":\"numeric\",\"dmb31\":\"numeric\",\"dmb32\":\"numeric\",\"dmb33\":\"numeric\",\"mwst2\":\"numeric\",\"mwst3\":\"numeric\",\"sknt2\":\"numeric\",\"sknt3\":\"numeric\",\"bdif3\":\"numeric\",\"kzbtr\":\"numeric\",\"pswbt\":\"numeric\",\"pyamt\":\"numeric\",\"ppdiff\":\"numeric\",\"ppdif2\":\"numeric\",\"ppdif3\":\"numeric\",\"penlc1\":\"numeric\",\"penlc2\":\"numeric\",\"penlc3\":\"numeric\",\"penfc\":\"numeric\",\"pendays\":\"integer\"}"
        }
      },
      "Catch": [
        {
          "ErrorEquals": [
            "States.ALL"
          ],
          "ResultPath": "$.glue_error",
          "Next": "Notify_Fail"
        }
      ],
      "Next": "Extract_BSID"
    },

    "Extract_BSID": {
      "Comment": "Full extract of SAPPRD.BSID",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "bsid",
          "--query": "SELECT \"MANDT\", \"BUKRS\", \"KUNNR\", \"UMSKS\", \"UMSKZ\", \"AUGDT\", \"AUGBL\", \"ZUONR\", \"GJAHR\", \"BELNR\", \"BUZEI\", \"BUDAT\", \"BLDAT\", \"CPUDT\", \"WAERS\", \"XBLNR\", \"BLART\", \"MONAT\", \"BSCHL\", \"ZUMSK\", \"SHKZG\", \"GSBER\", \"MWSKZ\", \"DMBTR\", \"WRBTR\", \"MWSTS\", \"WMWST\", \"BDIFF\", \"BDIF2\", \"SGTXT\", \"PROJN\", \"AUFNR\", \"ANLN1\", \"ANLN2\", \"SAKNR\", \"HKONT\", \"FKONT\", \"FILKD\", \"ZFBDT\", \"ZTERM\", \"ZBD1T\", \"ZBD2T\", \"ZBD3T\", \"ZBD1P\", \"ZBD2P\", \"SKFBT\", \"SKNTO\", \"WSKTO\", \"ZLSCH\", \"ZLSPR\", \"ZBFIX\", \"HBKID\", \"BVTYP\", \"REBZG\", \"REBZJ\", \"REBZZ\", \"SAMNR\", \"ANFBN\", \"ANFBJ\", \"ANFBU\", \"ANFAE\", \"MANSP\", \"MSCHL\", \"MADAT\", \"MANST\", \"MABER\", \"XNETB\", \"XANET\", \"XCPDD\", \"XINVE\", \"XZAHL\", \"MWSK1\", \"DMBT1\", \"WRBT1\", \"MWSK2\", \"DMBT2\", \"WRBT2\", \"MWSK3\", \"DMBT3\", \"WRBT3\", \"BSTAT\", \"VBUND\", \"VBELN\", \"REBZT\", \"INFAE\", \"STCEG\", \"EGBLD\", \"EGLLD\", \"RSTGR\", \"XNOZA\", \"VERTT\", \"VERTN\", \"VBEWA\", \"WVERW\", \"PROJK\", \"FIPOS\", \"NPLNR\", \"AUFPL\", \"APLZL\", \"XEGDR\", \"DMBE2\", \"DMBE3\", \"DMB21\", \"DMB22\", \"DMB23\", \"DMB31\", \"DMB32\", \"DMB33\", \"BDIF3\", \"XRAGL\", \"UZAWE\", \"XSTOV\", \"MWST2\", \"MWST3\", \"SKNT2\", \"SKNT3\", \"XREF1\", \"XREF2\", \"XARCH\", \"PSWSL\", \"PSWBT\", \"LZBKZ\", \"LANDL\", \"IMKEY\", \"VBEL2\", \"VPOS2\", \"POSN2\", \"ETEN2\", \"FISTL\", \"GEBER\", \"DABRZ\", \"XNEGP\", \"KOSTL\", \"RFZEI\", \"KKBER\", \"EMPFB\", \"PRCTR\", \"XREF3\", \"QSSKZ\", \"ZINKZ\", \"DTWS1\", \"DTWS2\", \"DTWS3\", \"DTWS4\", \"XPYPR\", \"KIDNO\", \"ABSBT\", \"CCBTC\", \"PYCUR\", \"PYAMT\", \"BUPLA\", \"SECCO\", \"CESSION_KZ\", \"PPDIFF\", \"PPDIF2\", \"PPDIF3\", \"KBLNR\", \"KBLPOS\", \"GRANT_NBR\", \"GMVKZ\", \"SRTYPE\", \"LOTKZ\", \"FKBER\", \"INTRENO\", \"PPRCT\", \"BUZID\", \"AUGGJ\", \"HKTID\", \"BUDGET_PD\", \"PAYS_PROV\", \"PAYS_TRAN\", \"MNDID\", \"_DATAAGING\", \"KONTT\", \"KONTL\", \"UEBGDAT\", \"VNAME\", \"EGRUP\", \"BTYPE\", \"PROPMANO\", \"GKONT\", \"GKART\", \"GHKON\" FROM \"SAPPRD\".\"BSID\"",
          "--final_file_name": "from_SAP/for_ingestion/bsid_output.json"
        }
      },
      "Catch": [
        {
          "ErrorEquals": [
            "States.ALL"
          ],
          "ResultPath": "$.glue_error",
          "Next": "Notify_Fail"
        }
      ],
      "Next": "Load_BSID"
    },

    "Load_BSID": {
      "Comment": "Load SAPPRD.BSID to Postgres",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--table_name": "bsid",
          "--nonstring_schema": "{\"dmbtr\":\"numeric\",\"wrbtr\":\"numeric\",\"mwsts\":\"numeric\",\"wmwst\":\"numeric\",\"bdiff\":\"numeric\",\"bdif2\":\"numeric\",\"zbd1t\":\"numeric\",\"zbd2t\":\"numeric\",\"zbd3t\":\"numeric\",\"zbd1p\":\"numeric\",\"zbd2p\":\"numeric\",\"skfbt\":\"numeric\",\"sknto\":\"numeric\",\"wskto\":\"numeric\",\"dmbt1\":\"numeric\",\"wrbt1\":\"numeric\",\"dmbt2\":\"numeric\",\"wrbt2\":\"numeric\",\"dmbt3\":\"numeric\",\"wrbt3\":\"numeric\",\"dmbe2\":\"numeric\",\"dmbe3\":\"numeric\",\"dmb21\":\"numeric\",\"dmb22\":\"numeric\",\"dmb23\":\"numeric\",\"dmb31\":\"numeric\",\"dmb32\":\"numeric\",\"dmb33\":\"numeric\",\"bdif3\":\"numeric\",\"mwst2\":\"numeric\",\"mwst3\":\"numeric\",\"sknt2\":\"numeric\",\"sknt3\":\"numeric\",\"pswbt\":\"numeric\",\"absbt\":\"numeric\",\"pyamt\":\"numeric\",\"ppdiff\":\"numeric\",\"ppdif2\":\"numeric\",\"ppdif3\":\"numeric\"}"
        }
      },
      "Catch": [
        {
          "ErrorEquals": [
            "States.ALL"
          ],
          "ResultPath": "$.glue_error",
          "Next": "Notify_Fail"
        }
      ],
      "Next": "Extract_BSIK"
    },

    "Extract_BSIK": {
      "Comment": "Full extract of SAPPRD.BSIK",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "bsik",
          "--query": "SELECT \"MANDT\", \"BUKRS\", \"LIFNR\", \"UMSKS\", \"UMSKZ\", \"AUGDT\", \"AUGBL\", \"ZUONR\", \"GJAHR\", \"BELNR\", \"BUZEI\", \"BUDAT\", \"BLDAT\", \"CPUDT\", \"WAERS\", \"XBLNR\", \"BLART\", \"MONAT\", \"BSCHL\", \"ZUMSK\", \"SHKZG\", \"GSBER\", \"MWSKZ\", \"DMBTR\", \"WRBTR\", \"MWSTS\", \"WMWST\", \"BDIFF\", \"BDIF2\", \"SGTXT\", \"PROJN\", \"AUFNR\", \"ANLN1\", \"ANLN2\", \"EBELN\", \"EBELP\", \"SAKNR\", \"HKONT\", \"FKONT\", \"FILKD\", \"ZFBDT\", \"ZTERM\", \"ZBD1T\", \"ZBD2T\", \"ZBD3T\", \"ZBD1P\", \"ZBD2P\", \"SKFBT\", \"SKNTO\", \"WSKTO\", \"ZLSCH\", \"ZLSPR\", \"ZBFIX\", \"HBKID\", \"BVTYP\", \"REBZG\", \"REBZJ\", \"REBZZ\", \"SAMNR\", \"ZOLLT\", \"ZOLLD\", \"LZBKZ\", \"LANDL\", \"DIEKZ\", \"MANSP\", \"MSCHL\", \"MADAT\", \"MANST\", \"MABER\", \"XNETB\", \"XANET\", \"XCPDD\", \"XESRD\", \"XZAHL\", \"MWSK1\", \"DMBT1\", \"WRBT1\", \"MWSK2\", \"DMBT2\", \"WRBT2\", \"MWSK3\", \"DMBT3\", \"WRBT3\", \"QSSKZ\", \"QSSHB\", \"QBSHB\", \"BSTAT\", \"ANFBN\", \"ANFBJ\", \"ANFBU\", \"VBUND\", \"REBZT\", \"STCEG\", \"EGBLD\", \"EGLLD\", \"QSZNR\", \"QSFBT\", \"XINVE\", \"PROJK\", \"FIPOS\", \"NPLNR\", \"AUFPL\", \"APLZL\", \"XEGDR\", \"DMBE2\", \"DMBE3\", \"DMB21\", \"DMB22\", \"DMB23\", \"DMB31\", \"DMB32\", \"DMB33\", \"MWST2\", \"MWST3\", \"SKNT2\", \"SKNT3\", \"BDIF3\", \"XRAGL\", \"RSTGR\", \"UZAWE\", \"KOSTL\", \"LNRAN\", \"XSTOV\", \"KZBTR\", \"XREF1\", \"XREF2\", \"XARCH\", \"PSWSL\", \"PSWBT\", \"IMKEY\", \"ZEKKN\", \"FISTL\", \"GEBER\", \"DABRZ\", \"XNEGP\", \"EMPFB\", \"PRCTR\", \"XREF3\", \"DTWS1\", \"DTWS2\", \"DTWS3\", \"DTWS4\", \"XPYPR\", \"KIDNO\", \"PYCUR\", \"PYAMT\", \"BUPLA\", \"SECCO\", \"PPDIFF\", \"PPDIF2\", \"PPDIF3\", \"PENLC1\", \"PENLC2\", \"PENLC3\", \"PENFC\", \"PENDAYS\", \"PENRC\", \"VERTT\", \"VERTN\", \"VBEWA\", \"KBLNR\", \"KBLPOS\", \"GRANT_NBR\", \"GMVKZ\", \"SRTYPE\", \"LOTKZ\", \"ZINKZ\", \"FKBER\", \"INTRENO\", \"PPRCT\", \"BUZID\", \"AUGGJ\", \"HKTID\", \"BUDGET_PD\", \"_DATAAGING\", \"KONTT\", \"KONTL\", \"UEBGDAT\", \"VNAME\", \"EGRUP\", \"BTYPE\", \"PROPMANO\", \"GKONT\", \"GKART\", \"GHKON\" FROM \"SAPPRD\".\"BSIK\"",
          "--final_file_name": "from_SAP/for_ingestion/bsik_output.json"
        }
      },
      "Catch": [
        {
          "ErrorEquals": [
            "States.ALL"
          ],
          "ResultPath": "$.glue_error",
          "Next": "Notify_Fail"
        }
      ],
      "Next": "Load_BSIK"
    },

    "Load_BSIK": {
      "Comment": "Load SAPPRD.BSIK to Postgres",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--table_name": "bsik",
          "--nonstring_schema": "{\"dmbtr\":\"numeric\",\"wrbtr\":\"numeric\",\"mwsts\":\"numeric\",\"wmwst\":\"numeric\",\"bdiff\":\"numeric\",\"bdif2\":\"numeric\",\"zbd1t\":\"numeric\",\"zbd2t\":\"numeric\",\"zbd3t\":\"numeric\",\"zbd1p\":\"numeric\",\"zbd2p\":\"numeric\",\"skfbt\":\"numeric\",\"sknto\":\"numeric\",\"wskto\":\"numeric\",\"dmbt1\":\"numeric\",\"wrbt1\":\"numeric\",\"dmbt2\":\"numeric\",\"wrbt2\":\"numeric\",\"dmbt3\":\"numeric\",\"wrbt3\":\"numeric\",\"qsshb\":\"numeric\",\"qbshb\":\"numeric\",\"qsfbt\":\"numeric\",\"dmbe2\":\"numeric\",\"dmbe3\":\"numeric\",\"dmb21\":\"numeric\",\"dmb22\":\"numeric\",\"dmb23\":\"numeric\",\"dmb31\":\"numeric\",\"dmb32\":\"numeric\",\"dmb33\":\"numeric\",\"mwst2\":\"numeric\",\"mwst3\":\"numeric\",\"sknt2\":\"numeric\",\"sknt3\":\"numeric\",\"bdif3\":\"numeric\",\"kzbtr\":\"numeric\",\"pswbt\":\"numeric\",\"pyamt\":\"numeric\",\"ppdiff\":\"numeric\",\"ppdif2\":\"numeric\",\"ppdif3\":\"numeric\",\"penlc1\":\"numeric\",\"penlc2\":\"numeric\",\"penlc3\":\"numeric\",\"penfc\":\"numeric\",\"pendays\":\"integer\"}"
        }
      },
      "Catch": [
        {
          "ErrorEquals": [
            "States.ALL"
          ],
          "ResultPath": "$.glue_error",
          "Next": "Notify_Fail"
        }
      ],
      "Next": "Extract_DD03L"
    },

    "Extract_DD03L": {
      "Comment": "Full extract of SAPPRD.DD03L",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "dd03l",
          "--query": "SELECT \"FIELDNAME\", \"AS4LOCAL\", \"AS4VERS\", \"POSITION\", \"KEYFLAG\", \"MANDATORY\", \"ROLLNAME\", \"CHECKTABLE\", \"ADMINFIELD\", \"INTTYPE\", \"INTLEN\", \"REFTABLE\", \"PRECFIELD\", \"REFFIELD\", \"CONROUT\", \"NOTNULL\", \"DATATYPE\", \"LENG\", \"DECIMALS\", \"DOMNAME\", \"SHLPORIGIN\", \"TABLETYPE\", \"DEPTH\", \"COMPTYPE\", \"REFTYPE\", \"LANGUFLAG\", \"DBPOSITION\", \"ANONYMOUS\", \"OUTPUTSTYLE\" FROM \"SAPPRD\".\"DD03L\"",
          "--final_file_name": "from_SAP/for_ingestion/dd03l_output.json"
        }
      },
      "Catch": [
        {
          "ErrorEquals": [
            "States.ALL"
          ],
          "ResultPath": "$.glue_error",
          "Next": "Notify_Fail"
        }
      ],
      "Next": "Extract_PRPS"
    },

    "Extract_PRPS": {
      "Comment": "Full extract of SAPPRD.PRPS",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "prps",
          "--query": "SELECT \"MANDT\", \"PSPNR\", \"POSID\", \"POST1\", \"OBJNR\", \"PSPHI\", \"POSKI\", \"ERNAM\", \"ERDAT\", \"AENAM\", \"AEDAT\", \"VERNR\", \"VERNA\", \"ASTNR\", \"ASTNA\", \"PBUKR\", \"PGSBR\", \"PKOKR\", \"PRCTR\", \"PRART\", \"STUFE\", \"PLAKZ\", \"BELKZ\", \"FAKKZ\", \"NPFAZ\", \"ZUORD\", \"TRMEQ\", \"KVEWE\", \"KAPPL\", \"KALSM\", \"ZSCHL\", \"ABGSL\", \"AKOKR\", \"AKSTL\", \"FKOKR\", \"FKSTL\", \"FABKL\", \"PSPRI\", \"EQUNR\", \"TPLNR\", \"PWPOS\", \"WERKS\", \"TXTSP\", \"SLWID\", \"USR00\", \"USR01\", \"USR02\", \"USR03\", \"USR04\", \"USE04\", \"USR05\", \"USE05\", \"USR06\", \"USE06\", \"USR07\", \"USE07\", \"USR08\", \"USR09\", \"USR10\", \"USR11\", \"KOSTL\", \"KTRG\", \"BERST\", \"BERTR\", \"BERKO\", \"BERBU\", \"CLASF\", \"SPSNR\", \"SCOPE\", \"XSTAT\", \"TXJCD\", \"ZSCHM\", \"IMPRF\", \"EVGEW\", \"AENNR\", \"SUBPR\", \"POSTU\", \"PLINT\", \"LOEVM\", \"KZBWS\", \"FPLNR\", \"TADAT\", \"IZWEK\", \"ISIZE\", \"IUMKZ\", \"ABUKR\", \"GRPKZ\", \"PGPRF\", \"LOGSYSTEM\", \"PSPNR_LOGS\", \"STORT\", \"FUNC_AREA\", \"KLVAR\", \"KALNR\", \"POSID_EDIT\", \"PSPKZ\", \"MATNR\", \"VLPSP\", \"VLPKZ\", \"SORT1\", \"SORT2\", \"SORT3\", \"VNAME\", \"RECID\", \"ETYPE\", \"OTYPE\", \"JIBCL\", \"JIBSA\", \"CGPL_GUID16\", \"CGPL_LOGSYS\", \"CGPL_OBJTYPE\", \"ADPSP\", \"RFIPPNT\", \"FERC_IND\", \"EEW_PRPS_PS_DUMMY\", \"CPD_UPDAT\", \"PRPS_STATUS\" FROM \"SAPPRD\".\"PRPS\"",
          "--final_file_name": "from_SAP/for_ingestion/prps_output.json"
        }
      },
      "Catch": [
        {
          "ErrorEquals": [
            "States.ALL"
          ],
          "ResultPath": "$.glue_error",
          "Next": "Notify_Fail"
        }
      ],
      "Next": "Load_PRPS"
    },

    "Load_PRPS": {
      "Comment": "Load SAPPRD.PRPS to Postgres",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--table_name": "prps",
          "--nonstring_schema": "{\"stufe\":\"smallint\",\"usr04\":\"numeric\",\"usr05\":\"numeric\",\"usr06\":\"numeric\",\"usr07\":\"numeric\",\"evgew\":\"numeric\",\"cgpl_guid16\":\"bytea\",\"cpd_updat\":\"numeric\",\"prps_status\":\"smallint\"}"
        }
      },
      "Catch": [
        {
          "ErrorEquals": [
            "States.ALL"
          ],
          "ResultPath": "$.glue_error",
          "Next": "Notify_Fail"
        }
      ],
      "Next": "Extract_WITH_ITEM"
    },

    "Extract_WITH_ITEM": {
      "Comment": "Full extract of SAPPRD.WITH_ITEM",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "with_item",
          "--query": "SELECT \"MANDT\", \"BUKRS\", \"BELNR\", \"GJAHR\", \"BUZEI\", \"WITHT\", \"WT_WITHCD\", \"WT_QSSHH\", \"WT_QSSHB\", \"WT_QSSH2\", \"WT_QSSH3\", \"WT_BASMAN\", \"WT_QSSHHC\", \"WT_QSSHBC\", \"WT_QSSH2C\", \"WT_QSSH3C\", \"WT_QBSHH\", \"WT_QBSHB\", \"WT_QBSH2\", \"WT_QBSH3\", \"WT_AMNMAN\", \"WT_QBSHHA\", \"WT_QBSHHB\", \"WT_STAT\", \"WT_QSFHH\", \"WT_QSFHB\", \"WT_QSFH2\", \"WT_QSFH3\", \"WT_WTEXMN\", \"KOART\", \"WT_ACCO\", \"HKONT\", \"HKONT_OPP\", \"QSREC\", \"AUGBL\", \"AUGDT\", \"WT_QSZRT\", \"WT_WDMBTR\", \"WT_WWRBTR\", \"WT_WDMBT2\", \"WT_WDMBT3\", \"TEXT15\", \"WT_QBUIHH\", \"WT_QBUIHB\", \"WT_QBUIH2\", \"WT_QBUIH3\", \"WT_ACCBS\", \"WT_ACCWT\", \"WT_ACCWTA\", \"WT_ACCWTHA\", \"WT_ACCBS1\", \"WT_ACCWT1\", \"WT_ACCWTA1\", \"WT_ACCWTHA1\", \"WT_ACCBS2\", \"WT_ACCWT2\", \"WT_ACCWTA2\", \"WT_ACCWTHA2\", \"QSATZ\", \"WT_SLFWTPD\", \"WT_GRUWTPD\", \"WT_OPOWTPD\", \"WT_GIVENPD\", \"CTNUMBER\", \"WT_DOWNC\", \"WT_RESITEM\", \"CTISSUEDATE\", \"J_1BWHTCOLLCODE\", \"J_1BWHTRATE\", \"J_1BWHT_BS\", \"J_1BWHTACCBS\", \"J_1BWHTACCBS1\", \"J_1BWHTACCBS2\", \"J_1IINTCHLN\", \"J_1IINTCHDT\", \"J_1IEWTREC\", \"J_1IBUZEI\", \"J_1ICERTDT\", \"J_1ICLRAMT\", \"J_1IREBZG\", \"J_1ISURAMT\", \"J_1AF_WT_REPBS\", \"WT_CALC\", \"WT_LOGSYS\", \"_DATAAGING\", \"FIWTIN_PAR_EXEM\" FROM \"SAPPRD\".\"WITH_ITEM\"",
          "--final_file_name": "from_SAP/for_ingestion/with_item_output.json"
        }
      },
      "Catch": [
        {
          "ErrorEquals": [
            "States.ALL"
          ],
          "ResultPath": "$.glue_error",
          "Next": "Notify_Fail"
        }
      ],
      "Next": "Load_WITH_ITEM"
    },

    "Load_WITH_ITEM": {
      "Comment": "Load SAPPRD.WITH_ITEM to Postgres",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--table_name": "with_item",
          "--nonstring_schema": "{\"wt_qsshh\":\"numeric\",\"wt_qsshb\":\"numeric\",\"wt_qssh2\":\"numeric\",\"wt_qssh3\":\"numeric\",\"wt_qsshhc\":\"numeric\",\"wt_qsshbc\":\"numeric\",\"wt_qssh2c\":\"numeric\",\"wt_qssh3c\":\"numeric\",\"wt_qbshh\":\"numeric\",\"wt_qbshb\":\"numeric\",\"wt_qbsh2\":\"numeric\",\"wt_qbsh3\":\"numeric\",\"wt_qbshha\":\"numeric\",\"wt_qbshhb\":\"numeric\",\"wt_qsfhh\":\"numeric\",\"wt_qsfhb\":\"numeric\",\"wt_qsfh2\":\"numeric\",\"wt_qsfh3\":\"numeric\",\"wt_qszrt\":\"numeric\",\"wt_wdmbtr\":\"numeric\",\"wt_wwrbtr\":\"numeric\",\"wt_wdmbt2\":\"numeric\",\"wt_wdmbt3\":\"numeric\",\"wt_qbuihh\":\"numeric\",\"wt_qbuihb\":\"numeric\",\"wt_qbuih2\":\"numeric\",\"wt_qbuih3\":\"numeric\",\"wt_accbs\":\"numeric\",\"wt_accwt\":\"numeric\",\"wt_accwta\":\"numeric\",\"wt_accwtha\":\"numeric\",\"wt_accbs1\":\"numeric\",\"wt_accwt1\":\"numeric\",\"wt_accwta1\":\"numeric\",\"wt_accwtha1\":\"numeric\",\"wt_accbs2\":\"numeric\",\"wt_accwt2\":\"numeric\",\"wt_accwta2\":\"numeric\",\"wt_accwtha2\":\"numeric\",\"qsatz\":\"numeric\",\"j_1bwhtrate\":\"numeric\",\"j_1bwht_bs\":\"numeric\",\"j_1bwhtaccbs\":\"numeric\",\"j_1bwhtaccbs1\":\"numeric\",\"j_1bwhtaccbs2\":\"numeric\",\"j_1iclramt\":\"numeric\",\"j_1isuramt\":\"numeric\",\"j_1af_wt_repbs\":\"numeric\"}"
        }
      },
      "Catch": [
        {
          "ErrorEquals": [
            "States.ALL"
          ],
          "ResultPath": "$.glue_error",
          "Next": "Notify_Fail"
        }
      ],
      "Next": "Extract_BKPF"
    },

    "Extract_BKPF": {
      "Comment": "Full extract of SAPPRD.BKPF",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "bkpf",
          "--query": "SELECT \"MANDT\", \"BUKRS\", \"BELNR\", \"GJAHR\", \"BLART\", \"BLDAT\", \"BUDAT\", \"MONAT\", \"CPUDT\", \"CPUTM\", \"AEDAT\", \"UPDDT\", \"WWERT\", \"USNAM\", \"TCODE\", \"BVORG\", \"XBLNR\", \"DBBLG\", \"STBLG\", \"STJAH\", \"BKTXT\", \"WAERS\", \"KURSF\", \"KZWRS\", \"KZKRS\", \"BSTAT\", \"XNETB\", \"FRATH\", \"XRUEB\", \"GLVOR\", \"GRPID\", \"DOKID\", \"ARCID\", \"IBLAR\", \"AWTYP\", \"AWKEY\", \"FIKRS\", \"HWAER\", \"HWAE2\", \"HWAE3\", \"KURS2\", \"KURS3\", \"BASW2\", \"BASW3\", \"UMRD2\", \"UMRD3\", \"XSTOV\", \"STODT\", \"XMWST\", \"CURT2\", \"CURT3\", \"KUTY2\", \"KUTY3\", \"XSNET\", \"AUSBK\", \"XUSVR\", \"DUEFL\", \"AWSYS\", \"TXKRS\", \"LOTKZ\", \"XWVOF\", \"STGRD\", \"PPNAM\", \"BRNCH\", \"NUMPG\", \"ADISC\", \"XREF1_HD\", \"XREF2_HD\", \"XREVERSAL\", \"REINDAT\", \"RLDNR\", \"LDGRP\", \"PROPMANO\", \"XBLNR_ALT\", \"VATDATE\", \"XSPLIT\", \"CASH_ALLOC\", \"FOLLOW_ON\", \"XREORG\", \"PSOTY\", \"PSOAK\", \"PSOKS\", \"PSOSG\", \"PSOFN\", \"INTFORM\", \"INTDATE\", \"PSOBT\", \"PSOZL\", \"PSODT\", \"PSOTM\", \"FM_UMART\", \"CCINS\", \"CCNUM\", \"SSBLK\", \"BATCH\", \"SNAME\", \"SAMPLED\", \"EXCLUDE_FLAG\", \"BLIND\", \"OFFSET_STATUS\", \"OFFSET_REFER_DAT\", \"PENRC\", \"KNUMV\", \"CTXKRS\", \"DOCCAT\", \"SUBSET\", \"KURST\", \"KURSX\", \"KUR2X\", \"KUR3X\", \"XMCA\", \"RESUBMISSION\", \"/SAPF15/STATUS\", \"DBBLG_GJAHR\", \"DBBLG_BUKRS\", \"PPDAT\", \"PPTME\", \"PPTCOD\", \"LOGSYSTEM_SENDER\", \"BUKRS_SENDER\", \"BELNR_SENDER\", \"GJAHR_SENDER\", \"INTSUBID\", \"AWORG_REV\", \"AWREF_REV\", \"XREVERSING\", \"XREVERSED\", \"GLBTGRP\", \"CO_VRGNG\", \"CO_REFBT\", \"CO_ALEBN\", \"CO_VALDT\", \"CO_BELNR_SENDER\", \"KOKRS_SENDER\", \"ACC_PRINCIPLE\", \"_DATAAGING\", \"TRAVA_PN\", \"LDGRPSPEC_PN\", \"AFABESPEC_PN\", \"XSECONDARY\", \"REPROCESSING_STATUS_CODE\", \"TRR_PARTIAL_IND\", \"ANXTYPE\", \"ANXAMNT\", \"ANXPERC\", \"ZVAT_INDC\", \"BLO\", \"CNT\", \"PYBASTYP\", \"PYBASNO\", \"PYBASDAT\", \"PYIBAN\", \"INWARDNO_HD\", \"INWARDDT_HD\" FROM \"SAPPRD\".\"BKPF\"",
          "--final_file_name": "from_SAP/for_ingestion/bkpf_output.json"
        }
      },
      "Catch": [
        {
          "ErrorEquals": [
            "States.ALL"
          ],
          "ResultPath": "$.glue_error",
          "Next": "Notify_Fail"
        }
      ],
      "Next": "Load_BKPF"
    },

    "Load_BKPF": {
      "Comment": "Full extract of SAPPRD.BKPF",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--table_name": "bkpf",
          "--nonstring_schema": "{\"kursf\":\"numeric\", \"kzkrs\":\"numeric\", \"frath\":\"numeric\", \"kurs2\":\"numeric\", \"kurs3\":\"numeric\", \"txkrs\":\"numeric\", \"ctxkrs\":\"numeric\", \"kursx\":\"numeric\", \"kur2x\":\"numeric\", \"kur3x\":\"numeric\", \"anxamnt\":\"numeric\", \"anxperc\":\"numeric\"}"
        }
      },
      "Catch": [
        {
          "ErrorEquals": [
            "States.ALL"
          ],
          "ResultPath": "$.glue_error",
          "Next": "Notify_Fail"
        }
      ],
      "Next": "Notify_Success"
    },

    "Notify_Success": {
      "Type": "Task",
      "Resource": "arn:aws:states:::states:startExecution",
      "Parameters": {
        "StateMachineArn.$": "States.Format('arn:aws:states:{}:{}:stateMachine:{}-notifier-sf','${aws_region}','${aws_account_id}',$.env_prefix)",
        "Input": {
          "email_subject": "[SUCCESS] SAP to PostgreSQL pipeline",
          "email_body": "Processing Complete: SAP to PostgreSQL workflow finished successfully."
        }
      },
      "End": true
    },
    
    "Notify_Fail": {
      "Type": "Task",
      "Resource": "arn:aws:states:::states:startExecution",
      "Parameters": {
        "StateMachineArn.$": "States.Format('arn:aws:states:{}:{}:stateMachine:{}-notifier-sf','${aws_region}','${aws_account_id}',$.env_prefix)",
        "Input": {
          "email_subject": "[FAILED] SAP to PostgreSQL pipeline",
          "email_body.$": "States.Format('Processing Failed. Error: {}', $.glue_error.Cause)"
        }
      },
      "ResultPath": null,
      "Next": "Fail"
    },
    "Fail": {
      "Type": "Fail",
      "Error": "SAP to PorsgreSQL Pipeline - Big Tables",
      "Cause": "The Glue Job or processing step failed."
    }
  }
}