{
  "Comment": "SAP to S3 multi-query extract using a single sap_2_s3 Glue job",
  "StartAt": "Extract_AUFK",
  "States": {
    "Extract_AUFK": {
      "Comment": "Full extract of SAPPRD.AUFK",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "aufk",
          "--query": "SELECT \"MANDT\", \"AUFNR\", \"AUART\", \"AUTYP\", \"REFNR\", \"ERNAM\", \"ERDAT\", \"AENAM\", \"AEDAT\", \"KTEXT\", \"LTEXT\", \"BUKRS\", \"WERKS\", \"GSBER\", \"KOKRS\", \"CCKEY\", \"KOSTV\", \"STORT\", \"SOWRK\", \"ASTKZ\", \"WAERS\", \"ASTNR\", \"STDAT\", \"ESTNR\", \"PHAS0\", \"PHAS1\", \"PHAS2\", \"PHAS3\", \"PDAT1\", \"PDAT2\", \"PDAT3\", \"IDAT1\", \"IDAT2\", \"IDAT3\", \"OBJID\", \"VOGRP\", \"LOEKZ\", \"PLGKZ\", \"KVEWE\", \"KAPPL\", \"KALSM\", \"ZSCHL\", \"ABKRS\", \"KSTAR\", \"KOSTL\", \"SAKNR\", \"SETNM\", \"CYCLE\", \"SDATE\", \"SEQNR\", \"USER0\", \"USER1\", \"USER2\", \"USER3\", \"USER4\", \"USER5\", \"USER6\", \"USER7\", \"USER8\", \"USER9\", \"OBJNR\", \"PRCTR\", \"PSPEL\", \"AWSLS\", \"ABGSL\", \"TXJCD\", \"FUNC_AREA\", \"SCOPE\", \"PLINT\", \"KDAUF\", \"KDPOS\", \"AUFEX\", \"IVPRO\", \"LOGSYSTEM\", \"FLG_MLTPS\", \"ABUKR\", \"AKSTL\", \"SIZECL\", \"IZWEK\", \"UMWKZ\", \"KSTEMPF\", \"ZSCHM\", \"PKOSA\", \"ANFAUFNR\", \"PROCNR\", \"PROTY\", \"RSORD\", \"BEMOT\", \"ADRNRA\", \"ERFZEIT\", \"AEZEIT\", \"CSTG_VRNT\", \"COSTESTNR\", \"VERAA_USER\", \"ZZAUFUSER1\", \"ZZAUFUSER2\", \"ZZAUFUSER3\", \"ZZAUFUSER4\", \"ZZAUFUSER5\", \"ZZAUFUSER6\", \"ZZAUFUSER7\", \"ZZAUFUSER8\", \"ZZAUFUSER9\", \"ZZAUFUSER10\", \"ZZAUFUSER11\", \"ZZAUFUSER12\", \"ZZAUFUSER13\", \"ZZAUFUSER14\", \"VNAME\", \"RECID\", \"ETYPE\", \"OTYPE\", \"JV_JIBCL\", \"JV_JIBSA\", \"JV_OCO\", \"/CUM/INDCU\", \"\"/CUM/CMNUM\"\", \"\"/CUM/AUEST\"\", \"\"/CUM/DESNUM\"\", \"VAPLZ\", \"WAWRK\", \"FERC_IND\", \"EEW_AUFK_PS_DUMMY\", \"CPD_UPDAT\", \"AD01PROFNR\", \"CLAIM_CONTROL\", \"UPDATE_NEEDED\", \"UPDATE_CONTROL\", \"AUFK_STATUS\" FROM \"SAPPRD\".\"AUFK\";",
          "--final_file_name": "from_SAP/for_ingestion/aufk_output.json"
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
      "Next": "Load_AUFK"
    },
    "Load_AUFK": {
      "Comment": "Full extract of SAPPRD.AUFK",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "aufk",   
          "--input_file_name": "from_SAP/for_ingestion/aufk_output.json"
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
          "--query": "SELECT \"MANDT\", \"BUKRS\", \"BELNR\", \"GJAHR\", \"BLART\", \"BLDAT\", \"BUDAT\", \"MONAT\", \"CPUDT\", \"CPUTM\", \"AEDAT\", \"UPDDT\", \"WWERT\", \"USNAM\", \"TCODE\", \"BVORG\", \"XBLNR\", \"DBBLG\", \"STBLG\", \"STJAH\", \"BKTXT\", \"WAERS\", \"KURSF\", \"KZWRS\", \"KZKRS\", \"BSTAT\", \"XNETB\", \"FRATH\", \"XRUEB\", \"GLVOR\", \"GRPID\", \"DOKID\", \"ARCID\", \"IBLAR\", \"AWTYP\", \"AWKEY\", \"FIKRS\", \"HWAER\", \"HWAE2\", \"HWAE3\", \"KURS2\", \"KURS3\", \"BASW2\", \"BASW3\", \"UMRD2\", \"UMRD3\", \"XSTOV\", \"STODT\", \"XMWST\", \"CURT2\", \"CURT3\", \"KUTY2\", \"KUTY3\", \"XSNET\", \"AUSBK\", \"XUSVR\", \"DUEFL\", \"AWSYS\", \"TXKRS\", \"LOTKZ\", \"XWVOF\", \"STGRD\", \"PPNAM\", \"BRNCH\", \"NUMPG\", \"ADISC\", \"XREF1_HD\", \"XREF2_HD\", \"XREVERSAL\", \"REINDAT\", \"RLDNR\", \"LDGRP\", \"PROPMANO\", \"XBLNR_ALT\", \"VATDATE\", \"XSPLIT\", \"CASH_ALLOC\", \"FOLLOW_ON\", \"XREORG\", \"PSOTY\", \"PSOAK\", \"PSOKS\", \"PSOSG\", \"PSOFN\", \"INTFORM\", \"INTDATE\", \"PSOBT\", \"PSOZL\", \"PSODT\", \"PSOTM\", \"FM_UMART\", \"CCINS\", \"CCNUM\", \"SSBLK\", \"BATCH\", \"SNAME\", \"SAMPLED\", \"EXCLUDE_FLAG\", \"BLIND\", \"OFFSET_STATUS\", \"OFFSET_REFER_DAT\", \"PENRC\", \"KNUMV\", \"CTXKRS\", \"DOCCAT\", \"SUBSET\", \"KURST\", \"KURSX\", \"KUR2X\", \"KUR3X\", \"XMCA\", \"RESUBMISSION\", \"\"/SAPF15/STATUS\"\", \"DBBLG_GJAHR\", \"DBBLG_BUKRS\", \"PPDAT\", \"PPTME\", \"PPTCOD\", \"LOGSYSTEM_SENDER\", \"BUKRS_SENDER\", \"BELNR_SENDER\", \"GJAHR_SENDER\", \"INTSUBID\", \"AWORG_REV\", \"AWREF_REV\", \"XREVERSING\", \"XREVERSED\", \"GLBTGRP\", \"CO_VRGNG\", \"CO_REFBT\", \"CO_ALEBN\", \"CO_VALDT\", \"CO_BELNR_SENDER\", \"KOKRS_SENDER\", \"ACC_PRINCIPLE\", \"_DATAAGING\", \"TRAVA_PN\", \"LDGRPSPEC_PN\", \"AFABESPEC_PN\", \"XSECONDARY\", \"REPROCESSING_STATUS_CODE\", \"TRR_PARTIAL_IND\", \"ANXTYPE\", \"ANXAMNT\", \"ANXPERC\", \"ZVAT_INDC\", \"BLO\", \"CNT\", \"PYBASTYP\", \"PYBASNO\", \"PYBASDAT\", \"PYIBAN\", \"INWARDNO_HD\", \"INWARDDT_HD\" FROM \"SAPPRD\".\"BKPF\";",
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
          "--s4_table_name": "bkpf",   
          "--input_file_name": "from_SAP/for_ingestion/bkpf_output.json"
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
      "Next": "Extract_BSIS"
    },
    "Extract_BSIS": {
      "Comment": "Full extract of SAPPRD.BSIS",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "bsis",
          "--query": "SELECT \"MANDT\", \"BUKRS\", \"HKONT\", \"AUGDT\", \"AUGBL\", \"ZUONR\", \"GJAHR\", \"BELNR\", \"BUZEI\", \"BUDAT\", \"BLDAT\", \"WAERS\", \"XBLNR\", \"BLART\", \"MONAT\", \"BSCHL\", \"SHKZG\", \"GSBER\", \"MWSKZ\", \"FKONT\", \"DMBTR\", \"WRBTR\", \"MWSTS\", \"WMWST\", \"SGTXT\", \"PROJN\", \"AUFNR\", \"WERKS\", \"KOSTL\", \"ZFBDT\", \"XOPVW\", \"VALUT\", \"BSTAT\", \"BDIFF\", \"BDIF2\", \"VBUND\", \"PSWSL\", \"WVERW\", \"DMBE2\", \"DMBE3\", \"MWST2\", \"MWST3\", \"BDIF3\", \"RDIF3\", \"XRAGL\", \"PROJK\", \"PRCTR\", \"XSTOV\", \"XARCH\", \"PSWBT\", \"XNEGP\", \"RFZEI\", \"CCBTC\", \"XREF3\", \"BUPLA\", \"PPDIFF\", \"PPDIF2\", \"PPDIF3\", \"BEWAR\", \"IMKEY\", \"DABRZ\", \"INTRENO\", \"GRANT_NBR\", \"FKBER\", \"FIPOS\", \"FISTL\", \"GEBER\", \"PPRCT\", \"BUZID\", \"AUGGJ\", \"UZAWE\", \"SEGMENT\", \"PSEGMENT\", \"PGEBER\", \"PGRANT_NBR\", \"MEASURE\", \"BUDGET_PD\", \"PBUDGET_PD\", \"FIPEX\", \"_DATAAGING\", \"KIDNO\", \"PRODPER\", \"QSSKZ\", \"PROPMANO\", \"GKONT\", \"GKART\", \"GHKON\", \"LOGSYSTEM_SENDER\", \"BUKRS_SENDER\", \"BELNR_SENDER\", \"GJAHR_SENDER\", \"BUZEI_SENDER\" FROM \"SAPPRD\".\"BSIS\";",
          "--final_file_name": "from_SAP/for_ingestion/bsis_output.json"
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
      "Next": "Load_BSIS"
    },
    "Load_BSIS": {
      "Comment": "Full extract of SAPPRD.BSIS",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "bsis",   
          "--input_file_name": "from_SAP/for_ingestion/bsis_output.json"
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
      "Next": "Extract_CSKS"
    },
    "Extract_CSKS": {
      "Comment": "Full extract of SAPPRD.CSKS",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "csks",
          "--query": "SELECT \"MANDT\", \"KOKRS\", \"KOSTL\", \"DATBI\", \"DATAB\", \"BKZKP\", \"PKZKP\", \"BUKRS\", \"GSBER\", \"KOSAR\", \"VERAK\", \"VERAK_USER\", \"WAERS\", \"KALSM\", \"TXJCD\", \"PRCTR\", \"WERKS\", \"LOGSYSTEM\", \"ERSDA\", \"USNAM\", \"BKZKS\", \"BKZER\", \"BKZOB\", \"PKZKS\", \"PKZER\", \"VMETH\", \"MGEFL\", \"ABTEI\", \"NKOST\", \"KVEWE\", \"KAPPL\", \"KOSZSCHL\", \"LAND1\", \"ANRED\", \"NAME1\", \"NAME2\", \"NAME3\", \"NAME4\", \"ORT01\", \"ORT02\", \"STRAS\", \"PFACH\", \"PSTLZ\", \"PSTL2\", \"REGIO\", \"SPRAS\", \"TELBX\", \"TELF1\", \"TELF2\", \"TELFX\", \"TELTX\", \"TELX1\", \"DATLT\", \"DRNAM\", \"KHINR\", \"CCKEY\", \"KOMPL\", \"STAKZ\", \"OBJNR\", \"FUNKT\", \"AFUNK\", \"CPI_TEMPL\", \"CPD_TEMPL\", \"FUNC_AREA\", \"SCI_TEMPL\", \"SCD_TEMPL\", \"VNAME\", \"RECID\", \"ETYPE\", \"JV_OTYPE\", \"JV_JIBCL\", \"JV_JIBSA\", \"FERC_IND\", \"SKI_TEMPL\", \"SKD_TEMPL\", \"EEW_CSKS_PS_DUMMY\" FROM \"SAPPRD\".\"CSKS\";",
          "--final_file_name": "from_SAP/for_ingestion/csks_output.json"
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
      "Next": "Load_CSKS"
    },
    "Load_CSKS": {
      "Comment": "Full extract of SAPPRD.CSKS",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "csks",   
          "--input_file_name": "from_SAP/for_ingestion/csks_output.json"
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
      "Next": "Extract_DD02L"
    },
    "Extract_DD02L": {
      "Comment": "Full extract of SAPPRD.DD02L",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "dd02l",
          "--query": "SELECT \"TABNAME\", \"AS4LOCAL\", \"AS4VERS\", \"TABCLASS\", \"SQLTAB\", \"DATMIN\", \"DATMAX\", \"DATAVG\", \"CLIDEP\", \"BUFFERED\", \"COMPRFLAG\", \"LANGDEP\", \"ACTFLAG\", \"APPLCLASS\", \"AUTHCLASS\", \"AS4USER\", \"AS4DATE\", \"AS4TIME\", \"MASTERLANG\", \"MAINFLAG\", \"CONTFLAG\", \"RESERVETAB\", \"GLOBALFLAG\", \"PROZPUFF\", \"VIEWCLASS\", \"VIEWGRANT\", \"MULTIPLEX\", \"SHLPEXI\", \"PROXYTYPE\", \"EXCLASS\", \"WRONGCL\", \"ALWAYSTRP\", \"ALLDATAINCL\", \"WITH_PARAMETERS\", \"EXVIEW_INCLUDED\", \"KEYMAX_FEATURE\", \"KEYLEN_FEATURE\", \"TABLEN_FEATURE\", \"NONTRP_INCLUDED\", \"VIEWREF\", \"VIEWREF_ERR\", \"VIEWREF_POS_CHG\", \"TBFUNC_INCLUDED\", \"IS_GTT\", \"SESSION_VAR_EX\", \"FROM_ENTITY\", \"PK_IS_INVHASH\", \"USED_SESSION_VARS\" FROM \"SAPPRD\".\"DD02L\";",
          "--final_file_name": "from_SAP/for_ingestion/dd02l_output.json"
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
      "Next": "Load_DD02L"
    },
    "Load_DD02L": {
      "Comment": "Full extract of SAPPRD.DD02L",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "dd02l",   
          "--input_file_name": "from_SAP/for_ingestion/dd02l_output.json"
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
      "Next": "Extract_DD02L_V2"
    },
    "Extract_DD02L_V2": {
      "Comment": "Full extract of SAPPRD.DD02L_V2",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "dd02l_v2",
          "--query": "SELECT \"TABNAME\", \"AS4LOCAL\", \"AS4VERS\", \"TABCLASS\", \"SQLTAB\", \"DATMIN\", \"DATMAX\", \"DATAVG\", \"CLIDEP\", \"BUFFERED\", \"COMPRFLAG\", \"LANGDEP\", \"ACTFLAG\", \"APPLCLASS\", \"AUTHCLASS\", \"AS4USER\", \"AS4DATE\", \"AS4TIME\", \"MASTERLANG\", \"MAINFLAG\", \"CONTFLAG\", \"RESERVETAB\", \"GLOBALFLAG\", \"PROZPUFF\", \"VIEWCLASS\", \"VIEWGRANT\", \"MULTIPLEX\", \"SHLPEXI\", \"PROXYTYPE\", \"EXCLASS\", \"WRONGCL\", \"ALWAYSTRP\", \"ALLDATAINCL\", \"WITH_PARAMETERS\", \"EXVIEW_INCLUDED\", \"KEYMAX_FEATURE\", \"KEYLEN_FEATURE\", \"TABLEN_FEATURE\", \"NONTRP_INCLUDED\", \"VIEWREF\", \"VIEWREF_ERR\", \"VIEWREF_POS_CHG\", \"TBFUNC_INCLUDED\", \"IS_GTT\", \"SESSION_VAR_EX\", \"FROM_ENTITY\", \"PK_IS_INVHASH\", \"USED_SESSION_VARS\" FROM \"SAPPRD\".\"DD02L_V2\";",
          "--final_file_name": "from_SAP/for_ingestion/dd02l_v2_output.json"
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
      "Next": "Load_DD02L_V2"
    },
    "Load_DD02L_V2": {
      "Comment": "Full extract of SAPPRD.DD02L_V2",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "dd02l_v2",   
          "--input_file_name": "from_SAP/for_ingestion/dd02l_v2_output.json"
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
      "Next": "Extract_DD02T"
    },
    "Extract_DD02T": {
      "Comment": "Full extract of SAPPRD.DD02T",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "dd02t",
          "--query": "SELECT \"TABNAME\", \"DDLANGUAGE\", \"AS4LOCAL\", \"AS4VERS\", \"DDTEXT\" FROM \"SAPPRD\".\"DD02T\";",
          "--final_file_name": "from_SAP/for_ingestion/dd02t_output.json"
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
      "Next": "Load_DD02T"
    },
    "Load_DD02T": {
      "Comment": "Full extract of SAPPRD.DD02T",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "dd02t",   
          "--input_file_name": "from_SAP/for_ingestion/dd02t_output.json"
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
      "Next": "Extract_DD03T"
    },
    "Extract_DD03T": {
      "Comment": "Full extract of SAPPRD.DD03T",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "dd03t",
          "--query": "SELECT \"TABNAME\", \"DDLANGUAGE\", \"AS4LOCAL\", \"FIELDNAME\", \"DDTEXT\" FROM \"SAPPRD\".\"DD03T\";",
          "--final_file_name": "from_SAP/for_ingestion/dd03t_output.json"
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
      "Next": "Load_DD03T"
    },
    "Load_DD03T": {
      "Comment": "Full extract of SAPPRD.DD03T",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "dd03t",   
          "--input_file_name": "from_SAP/for_ingestion/dd03t_output.json"
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
      "Next": "Extract_DD04L"
    },
    "Extract_DD04L": {
      "Comment": "Full extract of SAPPRD.DD04L",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "dd04l",
          "--query": "SELECT \"ROLLNAME\", \"AS4LOCAL\", \"AS4VERS\", \"DOMNAME\", \"ROUTPUTLEN\", \"MEMORYID\", \"LOGFLAG\", \"HEADLEN\", \"SCRLEN1\", \"SCRLEN2\", \"SCRLEN3\", \"ACTFLAG\", \"APPLCLASS\", \"AUTHCLASS\", \"AS4USER\", \"AS4DATE\", \"AS4TIME\", \"DTELMASTER\", \"RESERVEDTE\", \"DTELGLOBAL\", \"SHLPNAME\", \"SHLPFIELD\", \"DEFFDNAME\", \"DATATYPE\", \"LENG\", \"DECIMALS\", \"OUTPUTLEN\", \"LOWERCASE\", \"SIGNFLAG\", \"CONVEXIT\", \"VALEXI\", \"ENTITYTAB\", \"REFKIND\", \"REFTYPE\", \"PROXYTYPE\", \"LTRFLDDIS\", \"BIDICTRLC\", \"NOHISTORY\" FROM \"SAPPRD\".\"DD04L\";",
          "--final_file_name": "from_SAP/for_ingestion/dd04l_output.json"
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
      "Next": "Load_DD04L"
    },
    "Load_DD04L": {
      "Comment": "Full extract of SAPPRD.DD04L",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "dd04l",   
          "--input_file_name": "from_SAP/for_ingestion/dd04l_output.json"
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
      "Next": "Extract_DD04T"
    },
    "Extract_DD04T": {
      "Comment": "Full extract of SAPPRD.DD04T",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "dd04t",
          "--query": "SELECT \"ROLLNAME\", \"DDLANGUAGE\", \"AS4LOCAL\", \"AS4VERS\", \"DDTEXT\", \"REPTEXT\", \"SCRTEXT_S\", \"SCRTEXT_M\", \"SCRTEXT_L\" FROM \"SAPPRD\".\"DD04T\";",
          "--final_file_name": "from_SAP/for_ingestion/dd04t_output.json"
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
      "Next": "Load_DD04T"
    },
    "Load_DD04T": {
      "Comment": "Full extract of SAPPRD.DD04T",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "dd04t",   
          "--input_file_name": "from_SAP/for_ingestion/dd04t_output.json"
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
      "Next": "Extract_DD05S"
    },
    "Extract_DD05S": {
      "Comment": "Full extract of SAPPRD.DD05S",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "dd05s",
          "--query": "SELECT \"TABNAME\", \"FIELDNAME\", \"PRIMPOS\", \"AS4LOCAL\", \"AS4VERS\", \"FORTABLE\", \"FORKEY\", \"FORSTRING\" FROM \"SAPPRD\".\"DD05S\";",
          "--final_file_name": "from_SAP/for_ingestion/dd05s_output.json"
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
      "Next": "Load_DD05S"
    },
    "Load_DD05S": {
      "Comment": "Full extract of SAPPRD.DD05S",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "dd05s",   
          "--input_file_name": "from_SAP/for_ingestion/dd05s_output.json"
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
      "Next": "Extract_DD08L"
    },
    "Extract_DD08L": {
      "Comment": "Full extract of SAPPRD.DD08L",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "dd08l",
          "--query": "SELECT \"TABNAME\", \"FIELDNAME\", \"AS4LOCAL\", \"AS4VERS\", \"CHECKTABLE\", \"FRKART\", \"CLASFIELD\", \"CLASVALUE\", \"CARDLEFT\", \"CARD\", \"CHECKFLAG\", \"ARBGB\", \"MSGNR\", \"NOINHERIT\" FROM \"SAPPRD\".\"DD08L\";",
          "--final_file_name": "from_SAP/for_ingestion/dd08l_output.json"
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
      "Next": "Load_DD08L"
    },
    "Load_DD08L": {
      "Comment": "Full extract of SAPPRD.DD08L",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "dd08l",   
          "--input_file_name": "from_SAP/for_ingestion/dd08l_output.json"
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
      "Next": "Extract_DSPCOMMONTRACE_EVENTDATA"
    },
    "Extract_DSPCOMMONTRACE_EVENTDATA": {
      "Comment": "Full extract of SAPPRD.DSPCOMMONTRACE_EVENTDATA",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "dspcommontrace_eventdata",
          "--query": "SELECT \"ID\", \"DATABASENAME\", \"EVENTTYPE\", \"OBJECTNAME\", \"OBJECTTYPE\", \"TSQLCOMMAND\", \"LOGINNAME\", \"CHANGEDON\", \"TYPE\" FROM \"SAPPRD\".\"DSPCOMMONTRACE_EVENTDATA\";",
          "--final_file_name": "from_SAP/for_ingestion/dspcommontrace_eventdata_output.json"
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
      "Next": "Load_DSPCOMMONTRACE_EVENTDATA"
    },
    "Load_DSPCOMMONTRACE_EVENTDATA": {
      "Comment": "Full extract of SAPPRD.DSPCOMMONTRACE_EVENTDATA",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "dspcommontrace_eventdata",   
          "--input_file_name": "from_SAP/for_ingestion/dspcommontrace_eventdata_output.json"
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
      "Next": "Extract_JEST"
    },
    "Extract_JEST": {
      "Comment": "Full extract of SAPPRD.JEST",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "jest",
          "--query": "SELECT \"MANDT\", \"OBJNR\", \"STAT\", \"INACT\", \"CHGNR\", \"_DATAAGING\" FROM \"SAPPRD\".\"JEST\";",
          "--final_file_name": "from_SAP/for_ingestion/jest_output.json"
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
      "Next": "Load_JEST"
    },
    "Load_JEST": {
      "Comment": "Full extract of SAPPRD.JEST",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "jest",   
          "--input_file_name": "from_SAP/for_ingestion/jest_output.json"
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
      "Next": "Extract_LFA1"
    },
    "Extract_LFA1": {
      "Comment": "Full extract of SAPPRD.LFA1",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "lfa1",
          "--query": "SELECT \"MANDT\", \"LIFNR\", \"LAND1\", \"NAME1\", \"NAME2\", \"NAME3\", \"NAME4\", \"ORT01\", \"ORT02\", \"PFACH\", \"PSTL2\", \"PSTLZ\", \"REGIO\", \"SORTL\", \"STRAS\", \"ADRNR\", \"MCOD1\", \"MCOD2\", \"MCOD3\", \"ANRED\", \"BAHNS\", \"BBBNR\", \"BBSNR\", \"BEGRU\", \"BRSCH\", \"BUBKZ\", \"DATLT\", \"DTAMS\", \"DTAWS\", \"ERDAT\", \"ERNAM\", \"ESRNR\", \"KONZS\", \"KTOKK\", \"KUNNR\", \"LNRZA\", \"LOEVM\", \"SPERR\", \"SPERM\", \"SPRAS\", \"STCD1\", \"STCD2\", \"STKZA\", \"STKZU\", \"TELBX\", \"TELF1\", \"TELF2\", \"TELFX\", \"TELTX\", \"TELX1\", \"XCPDK\", \"XZEMP\", \"VBUND\", \"FISKN\", \"STCEG\", \"STKZN\", \"SPERQ\", \"GBORT\", \"GBDAT\", \"SEXKZ\", \"KRAUS\", \"REVDB\", \"QSSYS\", \"KTOCK\", \"PFORT\", \"WERKS\", \"LTSNA\", \"WERKR\", \"PLKAL\", \"DUEFL\", \"TXJCD\", \"SPERZ\", \"SCACD\", \"SFRGR\", \"LZONE\", \"XLFZA\", \"DLGRP\", \"FITYP\", \"STCDT\", \"REGSS\", \"ACTSS\", \"STCD3\", \"STCD4\", \"STCD5\", \"IPISP\", \"TAXBS\", \"PROFS\", \"STGDL\", \"EMNFR\", \"LFURL\", \"J_1KFREPRE\", \"J_1KFTBUS\", \"J_1KFTIND\", \"CONFS\", \"UPDAT\", \"UPTIM\", \"NODEL\", \"QSSYSDAT\", \"PODKZB\", \"FISKU\", \"STENR\", \"CARRIER_CONF\", \"J_SC_CAPITAL\", \"J_SC_CURRENCY\", \"ALC\", \"PMT_OFFICE\", \"PSOFG\", \"PSOIS\", \"PSON1\", \"PSON2\", \"PSON3\", \"PSOVN\", \"PSOTL\", \"PSOHS\", \"PSOST\", \"TRANSPORT_CHAIN\", \"STAGING_TIME\", \"SCHEDULING_TYPE\", \"SUBMI_RELEVANT\", \"MIN_COMP\", \"TERM_LI\", \"CRC_NUM\", \"CVP_XBLCK\", \"RG\", \"EXP\", \"UF\", \"RGDATE\", \"RIC\", \"RNE\", \"RNEDATE\", \"CNAE\", \"LEGALNAT\", \"CRTN\", \"ICMSTAXPAY\", \"INDTYP\", \"TDT\", \"COMSIZE\", \"DECREGPC\", \"ZZMIBP\" FROM \"SAPPRD\".\"LFA1\";",
          "--final_file_name": "from_SAP/for_ingestion/lfa1_output.json"
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
      "Next": "Load_LFA1"
    },
    "Load_LFA1": {
      "Comment": "Full extract of SAPPRD.LFA1",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "lfa1",   
          "--input_file_name": "from_SAP/for_ingestion/lfa1_output.json"
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
      "Next": "Extract_LFB1"
    },
    "Extract_LFB1": {
      "Comment": "Full extract of SAPPRD.LFB1",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "lfb1",
          "--query": "SELECT \"MANDT\", \"LIFNR\", \"BUKRS\", \"PERNR\", \"ERDAT\", \"ERNAM\", \"SPERR\", \"LOEVM\", \"ZUAWA\", \"AKONT\", \"BEGRU\", \"VZSKZ\", \"ZWELS\", \"XVERR\", \"ZAHLS\", \"ZTERM\", \"EIKTO\", \"ZSABE\", \"KVERM\", \"FDGRV\", \"BUSAB\", \"LNRZE\", \"LNRZB\", \"ZINDT\", \"ZINRT\", \"DATLZ\", \"XDEZV\", \"WEBTR\", \"KULTG\", \"REPRF\", \"TOGRU\", \"HBKID\", \"XPORE\", \"QSZNR\", \"QSZDT\", \"QSSKZ\", \"BLNKZ\", \"MINDK\", \"ALTKN\", \"ZGRUP\", \"MGRUP\", \"UZAWE\", \"QSREC\", \"QSBGR\", \"QLAND\", \"XEDIP\", \"FRGRP\", \"TOGRR\", \"TLFXS\", \"INTAD\", \"XLFZB\", \"GUZTE\", \"GRICD\", \"GRIDT\", \"XAUSZ\", \"CERDT\", \"CONFS\", \"UPDAT\", \"UPTIM\", \"NODEL\", \"TLFNS\", \"AVSND\", \"AD_HASH\", \"J_SC_SUBCONTYPE\", \"J_SC_COMPDATE\", \"J_SC_OFFSM\", \"J_SC_OFFSR\", \"BASIS_PNT\", \"GMVKZK\", \"PREPAY_RELEVANT\", \"ASSIGN_TEST\", \"CVP_XBLCK_B\", \"CIIUCODE\", \"LFB1_EEW_CC\", \"ZBOKD\", \"ZQSSKZ\", \"ZQSZDT\", \"ZQSZNR\", \"ZMINDAT\", \"BRSCH\", \"WRBTR\", \"WAERS\", \"FORGN\", \"SHARE_IN_FOREIGN\", \"NOTES\", \"ACTIVE\" FROM \"SAPPRD\".\"LFB1\";",
          "--final_file_name": "from_SAP/for_ingestion/lfb1_output.json"
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
      "Next": "Load_LFB1"
    },
    "Load_LFB1": {
      "Comment": "Full extract of SAPPRD.LFB1",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "lfb1",   
          "--input_file_name": "from_SAP/for_ingestion/lfb1_output.json"
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
      "Next": "Extract_LFBW"
    },
    "Extract_LFBW": {
      "Comment": "Full extract of SAPPRD.LFBW",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "lfbw",
          "--query": "SELECT \"MANDT\", \"LIFNR\", \"BUKRS\", \"WITHT\", \"WT_SUBJCT\", \"QSREC\", \"WT_WTSTCD\", \"WT_WITHCD\", \"WT_EXNR\", \"WT_EXRT\", \"WT_EXDF\", \"WT_EXDT\", \"WT_WTEXRS\" FROM \"SAPPRD\".\"LFBW\";",
          "--final_file_name": "from_SAP/for_ingestion/lfbw_output.json"
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
      "Next": "Load_LFBW"
    },
    "Load_LFBW": {
      "Comment": "Full extract of SAPPRD.LFBW",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "lfbw",   
          "--input_file_name": "from_SAP/for_ingestion/lfbw_output.json"
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
      "Next": "Extract_SKA1"
    },
    "Extract_SKA1": {
      "Comment": "Full extract of SAPPRD.SKA1",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "ska1",
          "--query": "SELECT \"MANDT\", \"KTOPL\", \"SAKNR\", \"XBILK\", \"SAKAN\", \"BILKT\", \"ERDAT\", \"ERNAM\", \"GVTYP\", \"KTOKS\", \"MUSTR\", \"VBUND\", \"XLOEV\", \"XSPEA\", \"XSPEB\", \"XSPEP\", \"MCOD1\", \"FUNC_AREA\", \"GLACCOUNT_TYPE\", \"LAST_CHANGED_TS\" FROM \"SAPPRD\".\"SKA1\";",
          "--final_file_name": "from_SAP/for_ingestion/ska1_output.json"
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
      "Next": "Load_SKA1"
    },
    "Load_SKA1": {
      "Comment": "Full extract of SAPPRD.SKA1",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "ska1",   
          "--input_file_name": "from_SAP/for_ingestion/ska1_output.json"
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
      "Next": "Extract_SKAT"
    },
    "Extract_SKAT": {
      "Comment": "Full extract of SAPPRD.SKAT",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "skat",
          "--query": "SELECT \"MANDT\", \"SPRAS\", \"KTOPL\", \"SAKNR\", \"TXT20\", \"TXT50\", \"MCOD1\", \"LAST_CHANGED_TS\" FROM \"SAPPRD\".\"SKAT\";",
          "--final_file_name": "from_SAP/for_ingestion/skat_output.json"
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
      "Next": "Load_SKAT"
    },
    "Load_SKAT": {
      "Comment": "Full extract of SAPPRD.SKAT",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "skat",   
          "--input_file_name": "from_SAP/for_ingestion/skat_output.json"
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
      "Next": "Extract_SKB1"
    },
    "Extract_SKB1": {
      "Comment": "Full extract of SAPPRD.SKB1",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "skb1",
          "--query": "SELECT \"MANDT\", \"BUKRS\", \"SAKNR\", \"BEGRU\", \"BUSAB\", \"DATLZ\", \"ERDAT\", \"ERNAM\", \"FDGRV\", \"FDLEV\", \"FIPLS\", \"FSTAG\", \"HBKID\", \"HKTID\", \"KDFSL\", \"MITKZ\", \"MWSKZ\", \"STEXT\", \"VZSKZ\", \"WAERS\", \"WMETH\", \"XGKON\", \"XINTB\", \"XKRES\", \"XLOEB\", \"XNKON\", \"XOPVW\", \"XSPEB\", \"ZINDT\", \"ZINRT\", \"ZUAWA\", \"ALTKT\", \"XMITK\", \"RECID\", \"FIPOS\", \"XMWNO\", \"XSALH\", \"BEWGP\", \"INFKY\", \"TOGRU\", \"XLGCLR\", \"MCAKEY\", \"COCHANGED\", \"LAST_CHANGED_TS\" FROM \"SAPPRD\".\"SKB1\";",
          "--final_file_name": "from_SAP/for_ingestion/skb1_output.json"
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
      "Next": "Load_SKB1"
    },
    "Load_SKB1": {
      "Comment": "Full extract of SAPPRD.SKB1",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "skb1",   
          "--input_file_name": "from_SAP/for_ingestion/skb1_output.json"
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
      "Next": "Extract_T001"
    },
    "Extract_T001": {
      "Comment": "Full extract of SAPPRD.T001",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "t001",
          "--query": "SELECT \"MANDT\", \"BUKRS\", \"BUTXT\", \"ORT01\", \"LAND1\", \"WAERS\", \"SPRAS\", \"KTOPL\", \"WAABW\", \"PERIV\", \"KOKFI\", \"RCOMP\", \"ADRNR\", \"STCEG\", \"FIKRS\", \"XFMCO\", \"XFMCB\", \"XFMCA\", \"TXJCD\", \"FMHRDATE\", \"XTEMPLT\", \"BUVAR\", \"FDBUK\", \"XFDIS\", \"XVALV\", \"XSKFN\", \"KKBER\", \"XMWSN\", \"MREGL\", \"XGSBE\", \"XGJRV\", \"XKDFT\", \"XPROD\", \"XEINK\", \"XJVAA\", \"XVVWA\", \"XSLTA\", \"XFDMM\", \"XFDSD\", \"XEXTB\", \"EBUKR\", \"KTOP2\", \"UMKRS\", \"BUKRS_GLOB\", \"FSTVA\", \"OPVAR\", \"XCOVR\", \"TXKRS\", \"WFVAR\", \"XBBBF\", \"XBBBE\", \"XBBBA\", \"XBBKO\", \"XSTDT\", \"MWSKV\", \"MWSKA\", \"IMPDA\", \"XNEGP\", \"XKKBI\", \"WT_NEWWT\", \"PP_PDATE\", \"INFMT\", \"FSTVARE\", \"KOPIM\", \"DKWEG\", \"OFFSACCT\", \"BAPOVAR\", \"XCOS\", \"XCESSION\", \"XSPLT\", \"SURCCM\", \"DTPROV\", \"DTAMTC\", \"DTTAXC\", \"DTTDSP\", \"DTAXR\", \"XVATDATE\", \"PST_PER_VAR\", \"XBBSC\", \"F_OBSOLETE\", \"FM_DERIVE_ACC\" FROM \"SAPPRD\".\"T001\";",
          "--final_file_name": "from_SAP/for_ingestion/t001_output.json"
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
      "Next": "Load_T001"
    },
    "Load_T001": {
      "Comment": "Full extract of SAPPRD.T001",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "t001",   
          "--input_file_name": "from_SAP/for_ingestion/t001_output.json"
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
      "Next": "Extract_T007A"
    },
    "Extract_T007A": {
      "Comment": "Full extract of SAPPRD.T007A",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "t007a",
          "--query": "SELECT \"MANDT\", \"KALSM\", \"MWSKZ\", \"PRUEF\", \"MWART\", \"XMSTU\", \"ZMWSK\", \"EGRKZ\", \"XSLTA\", \"PROCD\", \"TXIND\", \"TXREL\", \"LSTML\", \"J_1BUSAGE\", \"J_1BISS\", \"J_1BTAXLW1\", \"J_1BTAXLW2\", \"J_1BTXICEX\", \"J_1BTXIPEX\", \"TOLERANCE\", \"ZMWSK_ESA\", \"ZMWSK_ESE\", \"NEWDEFTAX\", \"J_1BTAXLW4\", \"J_1BTAXLW5\", \"XINACT\", \"MOSSC\" FROM \"SAPPRD\".\"T007A\";",
          "--final_file_name": "from_SAP/for_ingestion/t007a_output.json"
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
      "Next": "Load_T007A"
    },
    "Load_T007A": {
      "Comment": "Full extract of SAPPRD.T007A",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "t007a",   
          "--input_file_name": "from_SAP/for_ingestion/t007a_output.json"
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
      "Next": "Extract_T030K"
    },
    "Extract_T030K": {
      "Comment": "Full extract of SAPPRD.T030K",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "t030k",
          "--query": "SELECT \"MANDT\", \"KTOPL\", \"KTOSL\", \"MWSKZ\", \"KONTS\", \"KONTH\", \"LAND1\" FROM \"SAPPRD\".\"T030K\";",
          "--final_file_name": "from_SAP/for_ingestion/t030k_output.json"
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
      "Next": "Load_T030K"
    },
    "Load_T030K": {
      "Comment": "Full extract of SAPPRD.T030K",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "t030k",   
          "--input_file_name": "from_SAP/for_ingestion/t030k_output.json"
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
      "Next": "Extract_T042Z"
    },
    "Extract_T042Z": {
      "Comment": "Full extract of SAPPRD.T042Z",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "t042z",
          "--query": "SELECT \"MANDT\", \"LAND1\", \"ZLSCH\", \"TEXT1\", \"XBKKT\", \"XSTRA\", \"XEINZ\", \"XESRD\", \"XPGIR\", \"XEZER\", \"XSCHK\", \"PROGN\", \"XZWHR\", \"XEURO\", \"FORMI\", \"FORMZ\", \"XWECH\", \"XWANF\", \"XPSKT\", \"XWECS\", \"BLART\", \"BLARV\", \"UMSKZ\", \"XSWEC\", \"TXTSL\", \"ZLSTN\", \"WLSTN\", \"XZANF\", \"XAKTZ\", \"WEART\", \"XNOPO\", \"XORB\", \"XIBAN\", \"XNO_ACCNO\", \"XSEPA\" FROM \"SAPPRD\".\"T042Z\";",
          "--final_file_name": "from_SAP/for_ingestion/t042z_output.json"
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
      "Next": "Load_T042Z"
    },
    "Load_T042Z": {
      "Comment": "Full extract of SAPPRD.T042Z",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "t042z",   
          "--input_file_name": "from_SAP/for_ingestion/t042z_output.json"
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
      "Next": "Extract_T059Z"
    },
    "Extract_T059Z": {
      "Comment": "Full extract of SAPPRD.T059Z",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "t059z",
          "--query": "SELECT \"MANDT\", \"LAND1\", \"WITHT\", \"WT_WITHCD\", \"QSCOD\", \"QPROZ\", \"QSATZ\", \"QSATR\", \"XQFOR\", \"REGIO\", \"FPRCD\", \"QEKAR\", \"WT_POSIN\", \"WT_RATEZ\", \"WT_RATEN\", \"WITHCD2\" FROM \"SAPPRD\".\"T059Z\";",
          "--final_file_name": "from_SAP/for_ingestion/t059z_output.json"
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
      "Next": "Load_T059Z"
    },
    "Load_T059Z": {
      "Comment": "Full extract of SAPPRD.T059Z",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "t059z",   
          "--input_file_name": "from_SAP/for_ingestion/t059z_output.json"
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
      "Next": "Extract_T2502"
    },
    "Extract_T2502": {
      "Comment": "Full extract of SAPPRD.T2502",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "t2502",
          "--query": "SELECT \"MANDT\", \"WWPDT\" FROM \"SAPPRD\".\"T2502\";",
          "--final_file_name": "from_SAP/for_ingestion/t2502_output.json"
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
      "Next": "Load_T2502"
    },
    "Load_T2502": {
      "Comment": "Full extract of SAPPRD.T2502",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "t2502",   
          "--input_file_name": "from_SAP/for_ingestion/t2502_output.json"
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
      "Next": "Extract_T25A1"
    },
    "Extract_T25A1": {
      "Comment": "Full extract of SAPPRD.T25A1",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "t25a1",
          "--query": "SELECT \"MANDT\", \"SPRAS\", \"WWBRD\", \"BEZEK\" FROM \"SAPPRD\".\"T25A1\";",
          "--final_file_name": "from_SAP/for_ingestion/t25a1_output.json"
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
      "Next": "Load_T25A1"
    },
    "Load_T25A1": {
      "Comment": "Full extract of SAPPRD.T25A1",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "t25A1",   
          "--input_file_name": "from_SAP/for_ingestion/t25A1_output.json"
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
      "Next": "Extract_T25A2"
    },
    "Extract_T25A2": {
      "Comment": "Full extract of SAPPRD.T25A2",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "t25a2",
          "--query": "SELECT \"MANDT\", \"SPRAS\", \"WWPDT\", \"BEZEK\" FROM \"SAPPRD\".\"T25A2\";",
          "--final_file_name": "from_SAP/for_ingestion/t25a2_output.json"
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
      "Next": "Load_T25A2"
    },
    "Load_T25A2": {
      "Comment": "Full extract of SAPPRD.T25A2",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "t25A2",   
          "--input_file_name": "from_SAP/for_ingestion/t25A2_output.json"
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
      "Next": "Extract_T25A4"
    },
    "Extract_T25A4": {
      "Comment": "Full extract of SAPPRD.T25A4",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "t25a4",
          "--query": "SELECT \"MANDT\", \"SPRAS\", \"WWSPA\", \"BEZEK\" FROM \"SAPPRD\".\"T25A4\";",
          "--final_file_name": "from_SAP/for_ingestion/t25a4_output.json"
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
      "Next": "Load_T25A4"
    },
    "Load_T25A4": {
      "Comment": "Full extract of SAPPRD.T25A4",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "t25A4",   
          "--input_file_name": "from_SAP/for_ingestion/t25A4_output.json"
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
      "Next": "Extract_T25A9"
    },
    "Extract_T25A9": {
      "Comment": "Full extract of SAPPRD.T25A9",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "t25a9",
          "--query": "SELECT \"MANDT\", \"SPRAS\", \"WWST\", \"BEZEK\" FROM \"SAPPRD\".\"T25A9\";",
          "--final_file_name": "from_SAP/for_ingestion/t25a9_output.json"
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
      "Next": "Load_T25A9"
    },
    "Load_T25A9": {
      "Comment": "Full extract of SAPPRD.T25A9",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "t25A9",   
          "--input_file_name": "from_SAP/for_ingestion/t25A9_output.json"
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
      "Next": "Extract_TCURC"
    },
    "Extract_TCURC": {
      "Comment": "Full extract of SAPPRD.TCURC",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "tcurc",
          "--query": "SELECT \"MANDT\", \"WAERS\", \"ISOCD\", \"ALTWR\", \"GDATU\", \"XPRIMARY\" FROM \"SAPPRD\".\"TCURC\";",
          "--final_file_name": "from_SAP/for_ingestion/tcurc_output.json"
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
      "Next": "Load_TCURC"
    },
    "Load_TCURC": {
      "Comment": "Full extract of SAPPRD.TCURC",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "tcurc",   
          "--input_file_name": "from_SAP/for_ingestion/tcurc_output.json"
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
      "Next": "Extract_TCURR"
    },
    "Extract_TCURR": {
      "Comment": "Full extract of SAPPRD.TCURR",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "tcurr",
          "--query": "SELECT \"MANDT\", \"KURST\", \"FCURR\", \"TCURR\", \"GDATU\", \"UKURS\", \"FFACT\", \"TFACT\" FROM \"SAPPRD\".\"TCURR\";",
          "--final_file_name": "from_SAP/for_ingestion/tcurr_output.json"
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
      "Next": "Load_TCURR"
    },
    "Load_TCURR": {
      "Comment": "Full extract of SAPPRD.TCURR",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "tcurr",   
          "--input_file_name": "from_SAP/for_ingestion/tcurr_output.json"
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
      "Next": "Extract_TCURT"
    },
    "Extract_TCURT": {
      "Comment": "Full extract of SAPPRD.TCURT",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "tcurt",
          "--query": "SELECT \"MANDT\", \"SPRAS\", \"WAERS\", \"LTEXT\", \"KTEXT\" FROM \"SAPPRD\".\"TCURT\";",
          "--final_file_name": "from_SAP/for_ingestion/tcurt_output.json"
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
      "Next": "Load_TCURT"
    },
    "Load_TCURT": {
      "Comment": "Full extract of SAPPRD.TCURT",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "tcurt",   
          "--input_file_name": "from_SAP/for_ingestion/tcurt_output.json"
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
      "Next": "Extract_TVZBT"
    },
    "Extract_TVZBT": {
      "Comment": "Full extract of SAPPRD.TVZBT",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "tvzbt",
          "--query": "SELECT \"MANDT\", \"SPRAS\", \"ZTERM\", \"VTEXT\" FROM \"SAPPRD\".\"TVZBT\";",
          "--final_file_name": "from_SAP/for_ingestion/tvzbt_output.json"
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
      "Next": "Load_TVZBT"
    },
    "Load_TVZBT": {
      "Comment": "Full extract of SAPPRD.TVZBT",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "tvzbt",   
          "--input_file_name": "from_SAP/for_ingestion/tvzbt_output.json"
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
      "Next": "Extract_ZFCO_UDT_MAP"
    },
    "Extract_ZFCO_UDT_MAP": {
      "Comment": "Full extract of SAPPRD.ZFCO_UDT_MAP",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "zfco_udt_map",
          "--query": "SELECT \"MANDT\", \"DIMENSION\", \"FROM_SYSTEM\", \"TO_SYSTEM\", \"EVENT\", \"BUKRS\", \"SOURCE_VAL\", \"TARGET_VAL\", \"USNAM\", \"CPUDT\", \"CPUTM\" FROM \"SAPPRD\".\"ZFCO_UDT_MAP\";",
          "--final_file_name": "from_SAP/for_ingestion/zfco_udt_map_output.json"
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
      "Next": "Load_ZFCO_UDT_MAP"
    },
    "Load_ZFCO_UDT_MAP": {
      "Comment": "Full extract of SAPPRD.ZFCO_UDT_MAP",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "zfco_udt_map",   
          "--input_file_name": "from_SAP/for_ingestion/zfco_udt_map_output.json"
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
      "Next": "Extract_ZFFI_0346"
    },
    "Extract_ZFFI_0346": {
      "Comment": "Full extract of SAPPRD.ZFFI_0346",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "zffi_0346",
          "--query": "SELECT \"MANDT\", \"BUKRS\", \"ZCCODE\", \"ZWAERS\", \"ZPK_DEBIT\", \"ZGL_DEBIT\", \"ZPK_CREDIT\", \"ZGL_CREDIT\", \"ZTER_FLAG\", \"ZTER_PK_DEBIT\", \"ZTER_GL_DEBIT\", \"ZTER_PK_CREDIT\", \"ZTER_GL_CREDIT\", \"ZDISCOUNT_FLAG\", \"ZVAT_OCT_FLG\", \"ZVAT_GL_DEBIT\", \"ZVAT_GL_CREDIT\", \"ZOCT_RATE\", \"ZVATINC_FLG\", \"ZVATINC_GL_DEBIT\", \"ZVATINC_GL_CREDIT\", \"ZVAT_RATE\", \"ZWRITE_OFF_FLG\", \"ZWRITE_GL_DEBIT\", \"ZWRITE_GL_CREDIT\", \"ZUNBIL_GL_DEBIT\", \"ZUNBIL_GL_CREDIT\", \"ZDEF_GL_DEBIT\", \"ZDEF_GL_CREDIT\", \"DATBU\", \"UZEIT\", \"UNAME\" FROM \"SAPPRD\".\"ZFFI_0346\";",
          "--final_file_name": "from_SAP/for_ingestion/zffi_0346_output.json"
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
      "Next": "Load_ZFFI_0346"
    },
    "Load_ZFFI_0346": {
      "Comment": "Full extract of SAPPRD.ZFFI_0346",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "zffi_0346",   
          "--input_file_name": "from_SAP/for_ingestion/zffi_0346_output.json"
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
      "Next": "Extract_ZFFI_CUST_MKTSEG"
    },
    "Extract_ZFFI_CUST_MKTSEG": {
      "Comment": "Full extract of SAPPRD.ZFFI_CUST_MKTSEG",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "zffi_cust_mktseg",
          "--query": "SELECT \"MANDT\", \"ZFN_CC\", \"ZFN_MS\" FROM \"SAPPRD\".\"ZFFI_CUST_MKTSEG\";",
          "--final_file_name": "from_SAP/for_ingestion/zffi_cust_mktseg_output.json"
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
      "Next": "Load_ZFFI_CUST_MKTSEG"
    },
    "Load_ZFFI_CUST_MKTSEG": {
      "Comment": "Full extract of SAPPRD.ZFFI_CUST_MKTSEG",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "zffi_cust_mktseg",   
          "--input_file_name": "from_SAP/for_ingestion/zffi_cust_mktseg_output.json"
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
      "Next": "Extract_ZFFI_CUST_SERV"
    },
    "Extract_ZFFI_CUST_SERV": {
      "Comment": "Full extract of SAPPRD.ZFFI_CUST_SERV",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "zffi_cust_serv",
          "--query": "SELECT \"MANDT\", \"CUSTOMER_ACCOUNT\", \"SERVICE_TYPE\" FROM \"SAPPRD\".\"ZFFI_CUST_SERV\";",
          "--final_file_name": "from_SAP/for_ingestion/zffi_cust_serv_output.json"
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
      "Next": "Load_ZFFI_CUST_SERV"
    },
    "Load_ZFFI_CUST_SERV": {
      "Comment": "Full extract of SAPPRD.ZFFI_CUST_SERV",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "zffi_cust_serv",   
          "--input_file_name": "from_SAP/for_ingestion/zffi_cust_serv_output.json"
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
      "Next": "Extract_ZFFI_FLCN_PRDG"
    },
    "Extract_ZFFI_FLCN_PRDG": {
      "Comment": "Full extract of SAPPRD.ZFFI_FLCN_PRDG",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "zffi_flcn_prdg",
          "--query": "SELECT \"MANDT\", \"ZFLCN_PG\", \"ZFFI_PL\" FROM \"SAPPRD\".\"ZFFI_FLCN_PRDG\";",
          "--final_file_name": "from_SAP/for_ingestion/zffi_flcn_prdg_output.json"
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
      "Next": "Load_ZZFFI_FLCN_PRDG"
    },
    "Load_ZZFFI_FLCN_PRDG": {
      "Comment": "Full extract of SAPPRD.ZFFI_FLCN_PRDG",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "zffi_flow_prog",   
          "--input_file_name": "from_SAP/for_ingestion/zffi_flow_prog_output.json"
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
      "Next": "Extract_ZFFI_ISMSACCRUAL"
    },
    "Extract_ZFFI_ISMSACCRUAL": {
      "Comment": "Full extract of SAPPRD.ZFFI_ISMSACCRUAL",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "zffi_ismsaccrual",
          "--query": "SELECT \"MANDT\", \"IOIND\", \"ZUONR\", \"WWSPA\", \"WWBRD\", \"WWST\", \"HKONT\", \"SUBPROD\", \"PRCTR\", \"ZRATE\", \"VALDATE\" FROM \"SAPPRD\".\"ZFFI_ISMSACCRUAL\";",
          "--final_file_name": "from_SAP/for_ingestion/zffi_ismsaccrual_output.json"
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
      "Next": "Load_ZFFI_ISMSACCRUA"
    },
    "Load_ZFFI_ISMSACCRUA": {
      "Comment": "Full extract of SAPPRD.ZFFI_ISMSACCRUA",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "zffi_ismsaccrua",   
          "--input_file_name": "from_SAP/for_ingestion/zffi_ismsaccrua_output.json"
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
      "Next": "Extract_ZFFI_ISMSPARTNER"
    },
    "Extract_ZFFI_ISMSPARTNER": {
      "Comment": "Full extract of SAPPRD.ZFFI_ISMSPARTNER",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "zffi_ismspartner",
          "--query": "SELECT \"MANDT\", \"SAP_CODE\", \"COUNTER\", \"PARTNER_NAME\", \"SHORT_CODE\", \"BOOKING_INBOUND\", \"BOOKING_OUTBOUND\" FROM \"SAPPRD\".\"ZFFI_ISMSPARTNER\";",
          "--final_file_name": "from_SAP/for_ingestion/zffi_ismspartner_output.json"
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
      "Next": "Load_ZFFI_ISMSPARTNER"
    },
    "Load_ZFFI_ISMSPARTNER": {
      "Comment": "Full extract of SAPPRD.ZFFI_ISMSPARTNER",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "zffi_ismspartner",   
          "--input_file_name": "from_SAP/for_ingestion/zffi_ismspartner_output.json"
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
      "Next": "Extract_ZFFI_PROD_SERV"
    },
    "Extract_ZFFI_PROD_SERV": {
      "Comment": "Full extract of SAPPRD.ZFFI_PROD_SERV",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "zffi_prod_serv",
          "--query": "SELECT \"MANDT\", \"ZPL_ST\", \"PRODUCT_GROUP\", \"SERVICE_TYPE\", \"CUSTOMER_CLASS\", \"MARKET_SEGMENT\", \"REVENUE_TYPE\" FROM \"SAPPRD\".\"ZFFI_PROD_SERV\";",
          "--final_file_name": "from_SAP/for_ingestion/zffi_prod_serv_output.json"
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
      "Next": "Load_ZFFI_PROD_SERV"
    },
    "Load_ZFFI_PROD_SERV": {
      "Comment": "Full extract of SAPPRD.ZFFI_PROD_SERV",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "zffi_ismspartner",   
          "--input_file_name": "from_SAP/for_ingestion/zffi_ismspartner_output.json"
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
      "Next": "Extract_ZFFI_RATES_SYNIV"
    },
    "Extract_ZFFI_RATES_SYNIV": {
      "Comment": "Full extract of SAPPRD.ZFFI_RATES_SYNIV",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "zffi_rates_syniv",
          "--query": "SELECT \"MANDT\", \"GJAHR\", \"PERIO\", \"MONTH_NAME\", \"USD_SDR\", \"EUR_SDR\", \"GBP_SDR\", \"HKD_SDR\", \"CHF_SDR\", \"EUR_USD\", \"GBP_USD\", \"CHF_USD\", \"HKD_USD\" FROM \"SAPPRD\".\"ZFFI_RATES_SYNIV\";",
          "--final_file_name": "from_SAP/for_ingestion/zffi_rates_syniv_output.json"
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
      "Next": "Load_ZFFI_RATES_SYNIV"
    },
    "Load_ZFFI_RATES_SYNIV": {
      "Comment": "Full extract of SAPPRD.ZFFI_RATES_SYNIV",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "zffi_rates_syniv",   
          "--input_file_name": "from_SAP/for_ingestion/zffi_rates_syniv_output.json"
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
      "Next": "Extract_ZFFI_REPORT_ODBC"
    },
    "Extract_ZFFI_REPORT_ODBC": {
      "Comment": "Full extract of SAPPRD.ZFFI_REPORT_ODBC",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "zffi_report_odbc",
          "--query": "SELECT \"MANDT\", \"Z_SOURCE_NAME\", \"ZDSP_ORDER\", \"ZDSP_UNIQUEKEY\", \"Z_UPLD_FILENAME\", \"Z_LINE_ITEM\", \"Z_PROG_NAME\", \"Z_MESSAGE\", \"Z_DATE\", \"Z_TIME\", \"Z_USER_ID\" FROM \"SAPPRD\".\"ZFFI_REPORT_ODBC\";",
          "--final_file_name": "from_SAP/for_ingestion/zffi_report_odbc_output.json"
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
      "Next": "Load_ZFFI_REPORT_ODBC"
    },
    "Load_ZFFI_REPORT_ODBC": {
      "Comment": "Full extract of SAPPRD.ZFFI_REPORT_ODBC",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "zffi_report_odbc",   
          "--input_file_name": "from_SAP/for_ingestion/zffi_report_odbc_output.json"
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
      "Next": "Extract_ZFFI_REV_SERV"
    },
    "Extract_ZFFI_REV_SERV": {
      "Comment": "Full extract of SAPPRD.ZFFI_REV_SERV",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "zffi_rev_serv",
          "--query": "SELECT \"MANDT\", \"RIC_ST\", \"REVENUE_ITEMCODE\", \"REVENUE_TYPE\" FROM \"SAPPRD\".\"ZFFI_REV_SERV\";",
          "--final_file_name": "from_SAP/for_ingestion/zffi_rev_serv_output.json"
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
      "Next": "Load_ZFFI_REV_SERV"
    },
    "Load_ZFFI_REV_SERV": {
      "Comment": "Full extract of SAPPRD.ZFFI_REV_SERV",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "zffi_rev_serv",   
          "--input_file_name": "from_SAP/for_ingestion/zffi_rev_serv_output.json"
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
      "Next": "Extract_ZFFI_SUBTYPE"
    },
    "Extract_ZFFI_SUBTYPE": {
      "Comment": "Full extract of SAPPRD.ZFFI_SUBTYPE",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "zffi_subtype",
          "--query": "SELECT \"MANDT\", \"ZBUKRS\", \"ZSUBTYPE\", \"ZPROFIT_CENTER\", \"ZWWPDT_PA\", \"ZWWSPA_PA\", \"ZWWSPB_PA\", \"ZWWFRA_PA\", \"ZWWBUC_PA\", \"ZWWSR_PA\", \"ZWWST_PA\", \"ZWWSEG_PA\", \"ZWWTHN_PA\", \"ZWWBRD_PA\", \"ZWWMVN_PA\", \"ZWWCPD_PA\", \"ZWWPTY_PA\", \"ZWWRIT_PA\", \"DATBU\", \"UZEIT\", \"UNAME\" FROM \"SAPPRD\".\"ZFFI_SUBTYPE\";",
          "--final_file_name": "from_SAP/for_ingestion/zffi_subtype_output.json"
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
      "Next": "Load_ZFFI_SUBTYPE"
    },
    "Load_ZFFI_SUBTYPE": {
      "Comment": "Full extract of SAPPRD.ZFFI_SUBTYPE",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "zffi_subtype",   
          "--input_file_name": "from_SAP/for_ingestion/zffi_subtype_output.json"
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
      "Next": "Extract_ZFFI_UBADJ_SBP"
    },
    "Extract_ZFFI_UBADJ_SBP": {
      "Comment": "Full extract of SAPPRD.ZFFI_UBADJ_SBP",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "zffi_ubadj_sbp",
          "--query": "SELECT \"MANDT\", \"Z_ADJ_TAX_CODE\", \"Z_ADJ_REASON\", \"HKONT\", \"WWSPB\", \"Z_VAT_RATE\" FROM \"SAPPRD\".\"ZFFI_UBADJ_SBP\";",
          "--final_file_name": "from_SAP/for_ingestion/zffi_ubadj_sbp_output.json"
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
      "Next": "Load_ZFFI_UBADJ_SBP"
    },
    "Load_ZFFI_UBADJ_SBP": {
      "Comment": "Full extract of SAPPRD.ZFFI_UBADJ_SBP",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "zffi_ubadj_sbp",   
          "--input_file_name": "from_SAP/for_ingestion/zffi_ubadj_sbp_output.json"
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
      "Next": "Extract_ZTF0001"
    },
    "Extract_ZTF0001": {
      "Comment": "Full extract of SAPPRD.ZTF0001",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "ztf0001",
          "--query": "SELECT \"MANDT\", \"FROM_SYSTEM\", \"TO_SYSTEM\", \"EVENT\", \"BUKRS\", \"BATCH_NO\", \"UNAME\", \"IDATE\", \"TIME\" FROM \"SAPPRD\".\"ZTF0001\";",
          "--final_file_name": "from_SAP/for_ingestion/ztf0001_output.json"
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
      "Next": "Load_ZTF0001"
    },
    "Load_ZTF0001": {
      "Comment": "Full extract of SAPPRD.ZTF0001",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "ztf0001",   
          "--input_file_name": "from_SAP/for_ingestion/ztf0001_output.json"
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
      "Next": "Extract_ZTF0001S"
    },
    "Extract_ZTF0001S": {
      "Comment": "Full extract of SAPPRD.ZTF0001S",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "ztf00015",
          "--query": "SELECT \"MANDT\", \"FROM_SYSTEM\", \"TO_SYSTEM\", \"EVENT\", \"BUKRS\", \"BATCH_NO\", \"IDATE\", \"TIME\" FROM \"SAPPRD\".\"ZTF0001S\";",
          "--final_file_name": "from_SAP/for_ingestion/ztf00015_output.json"
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
      "Next": "Load_ZTF00015"
    },
    "Load_ZTF00015": {
      "Comment": "Full extract of SAPPRD.ZTF00015",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "ztf00015",   
          "--input_file_name": "from_SAP/for_ingestion/ztf00015_output.json"
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
      "Next": "Extract_ZTF0002S"
    },
    "Extract_ZTF0002S": {
      "Comment": "Full extract of SAPPRD.ZTF0002S",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "ztf00025",
          "--query": "SELECT \"MANDT\", \"CCODE\", \"CHCODE\", \"DPCODE\", \"PSTKEY\", \"GLCODE\", \"SLINE\", \"SGROUP\", \"VATIND\", \"DEVREVIND\", \"VATRATE\", \"PSTKEY2\", \"GLCODETAX\" FROM \"SAPPRD\".\"ZTF0002S\";",
          "--final_file_name": "from_SAP/for_ingestion/ztf00025_output.json"
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
      "Next": "Load_ZTF00025"
    },
    "Load_ZTF00025": {
      "Comment": "Full extract of SAPPRD.ZTF00025",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "ztf00025",   
          "--input_file_name": "from_SAP/for_ingestion/ztf00025_output.json"
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
      "Next": "Extract_ZTF0158"
    },
    "Extract_ZTF0158": {
      "Comment": "Full extract of SAPPRD.ZTF0158",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "ztf0158",
          "--query": "SELECT \"MANDT\", \"LIFNR\", \"BUKRS\", \"EWT\", \"EWT2\", \"VALIDFR\", \"ZDISC\", \"SM_DCODE\", \"GX_DCODE\", \"ZEROVAT\", \"DATUM\", \"UZEIT\", \"UNAME\" FROM \"SAPPRD\".\"ZTF0158\";",
          "--final_file_name": "from_SAP/for_ingestion/ztf0158_output.json"
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
      "Next": "Load_ZTF0158"
    },
    "Load_ZTF0158": {
      "Comment": "Full extract of SAPPRD.ZTF0158",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "ztf0158",   
          "--input_file_name": "from_SAP/for_ingestion/ztf0158_output.json"
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
      "Next": "Extract_ZTF0188S"
    },
    "Extract_ZTF0188S": {
      "Comment": "Full extract of SAPPRD.ZTF0188S",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "ztf0188s",
          "--query": "SELECT \"MANDT\", \"CCODE\", \"CHCODE\", \"PSTKEY\", \"GLCODE\", \"PLINE\", \"SLINE\", \"SGROUP\", \"VATIND\", \"PSTKEY_CERA\", \"GLCODE_CERA\" FROM \"SAPPRD\".\"ZTF0188S\";",
          "--final_file_name": "from_SAP/for_ingestion/ztf0188s_output.json"
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
      "Next": "Load_ZTF0188S"
    },
    "Load_ZTF0188S": {
      "Comment": "Full extract of SAPPRD.ZTF0188S",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "ztf01885",   
          "--input_file_name": "from_SAP/for_ingestion/ztf01885_output.json"
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
      "Next": "Extract_ZTF0322"
    },
    "Extract_ZTF0322": {
      "Comment": "Full extract of SAPPRD.ZTF0322",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "ztf0322",
          "--query": "SELECT \"MANDT\", \"BUKRS\", \"LIFNR\", \"DATUM\", \"UZEIT\", \"UNAME\" FROM \"SAPPRD\".\"ZTF0322\";",
          "--final_file_name": "from_SAP/for_ingestion/ztf0322_output.json"
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
      "Next": "Load_ZTF0322"
    },
    "Load_ZTF0322": {
      "Comment": "Full extract of SAPPRD.ZTF0322",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "ztf0322",   
          "--input_file_name": "from_SAP/for_ingestion/ztf0322_output.json"
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
      "Next": "Extract_ZTF0368"
    },
    "Extract_ZTF0368": {
      "Comment": "Full extract of SAPPRD.ZTF0368",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "ztf0368",
          "--query": "SELECT \"MANDT\", \"BUKRS\", \"ZREV_IT\", \"ZFN_PL\", \"VBUND\", \"ZPK_DEBIT\", \"ZGL_DEBIT\", \"ZPK_CREDIT\", \"ZGL_CREDIT\", \"ZOCT_FLG\", \"ZVAT_FLG\", \"ZUONR\", \"PPRCTR\", \"KOSTL\", \"ZDPK_DEBIT\", \"ZDGL_DEBIT\", \"ZDPK_CREDIT\", \"ZDGL_CREDIT\", \"ACCT_CAT\", \"ACCT_CATPK\", \"ACCT_CATGL\", \"FLG_REV\", \"REVPK_D\", \"REVGL_D\", \"REVPK_C\", \"REVGL_C\", \"REV_RATE\", \"DATBU\", \"UZEIT\", \"UNAME\" FROM \"SAPPRD\".\"ZTF0368\";",
          "--final_file_name": "from_SAP/for_ingestion/ztf0368_output.json"
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
      "Next": "Load_ZTF0368"
    },
    "Load_ZTF0368": {
      "Comment": "Full extract of SAPPRD.ZTF0368",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "ztf0368",   
          "--input_file_name": "from_SAP/for_ingestion/ztf0368_output.json"
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
      "Next": "Extract_ZTF0455S"
    },
    "Extract_ZTF0455S": {
      "Comment": "Full extract of SAPPRD.ZTF0455S",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "ztf0455s",
          "--query": "SELECT \"MANDT\", \"BUKRS\", \"HKONT\", \"BRAND\", \"WWSPA\", \"WWBRD\", \"SPB\", \"WWST\", \"PSTKY\", \"GLDEF\", \"INTLIND\", \"TAXRATE\", \"DUOM\", \"EXSPB\", \"AVERATE\", \"ULI\", \"SUBSER\" FROM \"SAPPRD\".\"ZTF0455S\";",
          "--final_file_name": "from_SAP/for_ingestion/ztf0455s_output.json"
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
      "Next": "Load_ZTF0455S"
    },
    "Load_ZTF0455S": {
      "Comment": "Full extract of SAPPRD.ZTF0455S",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "ztf0455S",   
          "--input_file_name": "from_SAP/for_ingestion/ztf0455S_output.json"
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
      "Next": "Extract_ZTM0001"
    },
    "Extract_ZTM0001": {
      "Comment": "Full extract of SAPPRD.ZTM0001",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "ztm0001",
          "--query": "SELECT \"MANDT\", \"BCENTER\", \"CMSSL\", \"PMSL\", \"LGORT\", \"WERKS\", \"BCDESC\", \"REMARKS\", \"KUNNR\", \"ZADDR\", \"LGTYP\", \"RFURB\", \"SEGMT\", \"CRTDT\", \"CRTBY\", \"CHGDT\", \"CHGBY\", \"ZREGION\", \"STOCKCOND\", \"PICKUP_CONTACT_PERSON\", \"PICKUP_CONTACT_NUMBER\", \"PICKUP_CONTACT_EMAIL\", \"PICKUP_ZIPCODE\" FROM \"SAPPRD\".\"ZTM0001\";",
          "--final_file_name": "from_SAP/for_ingestion/ztm0001_output.json"
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
      "Next": "Load_ZTM0001"
    },
    "Load_ZTM0001": {
      "Comment": "Full extract of SAPPRD.ZTM0001",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "ztm0001",   
          "--input_file_name": "from_SAP/for_ingestion/ztm0001_output.json" 
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
      "Next": "Extract_ZZAB_GEN_DWNLOAD"
    },
    "Extract_ZZAB_GEN_DWNLOAD": {
      "Comment": "Full extract of SAPPRD.ZZAB_GEN_DWNLOAD",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "zzab_gen_dwnload",
          "--query": "SELECT \"MANDT\", \"TCODE\", \"USERID\", \"APPDIR\" FROM \"SAPPRD\".\"ZZAB_GEN_DWNLOAD\";",
          "--final_file_name": "from_SAP/for_ingestion/zzab_gen_dwnload_output.json"
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
      "Next": "Load_ZZAB_GEN_DWNLOAD"
    },
    "Load_ZZAB_GEN_DWNLOAD": {
      "Comment": "Full extract of SAPPRD.ZZAB_GEN_DWNLOAD",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "zzab_gen_download",   
          "--input_file_name": "from_SAP/for_ingestion/zzab_gen_download_output.json"
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
      "Next": "Extract_ZZAB_GEN_TABLE"
    },
    "Extract_ZZAB_GEN_TABLE": {
      "Comment": "Full extract of SAPPRD.ZZAB_GEN_TABLE",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "zzab_gen_table",
          "--query": "SELECT \"MANDT\", \"USNAM\", \"TNAME\", \"SE16O\", \"SE16N\", \"REPID\", \"UNAME\", \"AEDAT\", \"CPUTM\" FROM \"SAPPRD\".\"ZZAB_GEN_TABLE\";",
          "--final_file_name": "from_SAP/for_ingestion/zzab_gen_table_output.json"
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
      "Next": "Load_ZZAB_GEN_TABLE"
    },
    "Load_ZZAB_GEN_TABLE": {
      "Comment": "Full extract of SAPPRD.ZZAB_GEN_TABLE",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "zzab_gen_table",   
          "--input_file_name": "from_SAP/for_ingestion/zzab_gen_table_output.json"
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
          "email_subject": "[SUCCESS] Daily ingestion of WITH_ITEM",
          "email_body": "✅ Processing Complete: Successfully synced S4HANA WITH_ITEM table."
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
          "email_subject": "[FAILED] Daily ingestion of WITH_ITEM",
          "email_body.$": "States.Format('❌ Processing Failed: Unexpected issue was encountered while processing. \n\nError: {}\n\nPlease check the cloudwatch logs for details.', $.glue_error.Cause)"
        }
      },
      "ResultPath": null,
      "End": true
    }
  }
}