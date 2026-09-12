{
  "Comment": "SAP to S3 multi-query extract using a single sap_2_s3 Glue job",
  "StartAt": "Extract_AUFK",
  "States": {
    "Extract_AUFK": {
      "Comment": "Full extract of SAPPRD.AUFK",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName": "isg-esatp-dv-sap_2_s3-glue",
        "Arguments": {
          "--table_name": "(Select \"MANDT\", \"AUFNR\", \"AUART\", \"AUTYP\", \"REFNR\", \"ERNAM\", \"ERDAT\", \"AENAM\", \"AEDAT\", \"KTEXT\", \"LTEXT\", \"BUKRS\", \"WERKS\", \"GSBER\", \"KOKRS\", \"CCKEY\", \"KOSTV\", \"STORT\", \"SOWRK\", \"ASTKZ\", \"WAERS\", \"ASTNR\", \"STDAT\", \"ESTNR\", \"PHAS0\", \"PHAS1\", \"PHAS2\", \"PHAS3\", \"PDAT1\", \"PDAT2\", \"PDAT3\", \"IDAT1\", \"IDAT2\", \"IDAT3\", \"OBJID\", \"VOGRP\", \"LOEKZ\", \"PLGKZ\", \"KVEWE\", \"KAPPL\", \"KALSM\", \"ZSCHL\", \"ABKRS\", \"KSTAR\", \"KOSTL\", \"SAKNR\", \"SETNM\", \"CYCLE\", \"SDATE\", \"SEQNR\", \"USER0\", \"USER1\", \"USER2\", \"USER3\", \"USER4\", \"USER5\", \"USER6\", \"USER7\", \"USER8\", \"USER9\", \"OBJNR\", \"PRCTR\", \"PSPEL\", \"AWSLS\", \"ABGSL\", \"TXJCD\", \"FUNC_AREA\", \"SCOPE\", \"PLINT\", \"KDAUF\", \"KDPOS\", \"AUFEX\", \"IVPRO\", \"LOGSYSTEM\", \"FLG_MLTPS\", \"ABUKR\", \"AKSTL\", \"SIZECL\", \"IZWEK\", \"UMWKZ\", \"KSTEMPF\", \"ZSCHM\", \"PKOSA\", \"ANFAUFNR\", \"PROCNR\", \"PROTY\", \"RSORD\", \"BEMOT\", \"ADRNRA\", \"ERFZEIT\", \"AEZEIT\", \"CSTG_VRNT\", \"COSTESTNR\", \"VERAA_USER\", \"ZZAUFUSER1\", \"ZZAUFUSER2\", \"ZZAUFUSER3\", \"ZZAUFUSER4\", \"ZZAUFUSER5\", \"ZZAUFUSER6\", \"ZZAUFUSER7\", \"ZZAUFUSER8\", \"ZZAUFUSER9\", \"ZZAUFUSER10\", \"ZZAUFUSER11\", \"ZZAUFUSER12\", \"ZZAUFUSER13\", \"ZZAUFUSER14\", \"VNAME\", \"RECID\", \"ETYPE\", \"OTYPE\", \"JV_JIBCL\", \"JV_JIBSA\", \"JV_OCO\", \"/CUM/INDCU\", \"/CUM/CMNUM\", \"/CUM/AUEST\", \"/CUM/DESNUM\", \"VAPLZ\", \"WAWRK\", \"FERC_IND\", \"EEW_AUFK_PS_DUMMY\", \"CPD_UPDAT\", \"AD01PROFNR\", \"CLAIM_CONTROL\", \"UPDATE_NEEDED\", \"UPDATE_CONTROL\", \"AUFK_STATUS\" From \"SAPPRD\".\"AUFK\") AS aufk_query",
          "--final_file_name": "from_SAP/for_ingestion/aufk_output.csv"
        }
      },
      "Catch": [
        {
          "ErrorEquals": [
            "States.ALL"
          ],
          "ResultPath": "$.glue_error",
          "Next": "Parse_Glue_Error_Lambda"
        }
      ],
      "Next": "Extract_ACDOCA"
    },
    "Extract_ACDOCA": {
      "Comment": "Full extract of SAPPRD.ACDOCA",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName": "isg-esatp-dv-sap_2_s3-glue",
        "Arguments": {
          "--table_name": "(Select \"RCLNT\", \"RLDNR\", \"RBUKRS\", \"GJAHR\", \"BELNR\", \"DOCLN\", \"RYEAR\", \"DOCNR_LD\", \"RRCTY\", \"RMVCT\", \"VORGN\", \"VRGNG\", \"BTTYPE\", \"AWTYP\", \"AWSYS\", \"AWORG\", \"AWREF\", \"AWITEM\", \"AWITGRP\", \"SUBTA\", \"XREVERSING\", \"XREVERSED\", \"XTRUEREV\", \"AWTYP_REV\", \"AWORG_REV\", \"AWREF_REV\", \"SUBTA_REV\", \"XSETTLING\", \"XSETTLED\", \"PREC_AWTYP\", \"PREC_AWSYS\", \"PREC_AWORG\", \"PREC_AWREF\", \"PREC_AWITEM\", \"PREC_SUBTA\", \"PREC_AWMULT\", \"XSECONDARY\", \"SRC_AWTYP\", \"SRC_AWSYS\", \"SRC_AWORG\", \"SRC_AWREF\", \"SRC_AWITEM\", \"SRC_AWSUBIT\", \"XCOMMITMENT\", \"RTCUR\", \"RWCUR\", \"RHCUR\", \"RKCUR\", \"ROCUR\", \"RVCUR\", \"RBCUR\", \"RCCUR\", \"RDCUR\", \"RECUR\", \"RFCUR\", \"RGCUR\", \"RCO_OCUR\", \"RUNIT\", \"RVUNIT\", \"RRUNIT\", \"RIUNIT\", \"QUNIT1\", \"QUNIT2\", \"QUNIT3\", \"CO_MEINH\", \"RACCT\", \"RCNTR\", \"PRCTR\", \"RFAREA\", \"RBUSA\", \"KOKRS\", \"SEGMENT\", \"SCNTR\", \"PPRCTR\", \"SFAREA\", \"SBUSA\", \"RASSC\", \"PSEGMENT\", \"TSL\", \"WSL\", \"WSL2\", \"WSL3\", \"HSL\", \"KSL\", \"OSL\", \"VSL\", \"BSL\", \"CSL\", \"DSL\", \"ESL\", \"FSL\", \"GSL\", \"KFSL\", \"KFSL2\", \"KFSL3\", \"PSL\", \"PSL2\", \"PSL3\", \"PFSL\", \"PFSL2\", \"PFSL3\", \"CO_OSL\", \"HSALK3\", \"KSALK3\", \"OSALK3\", \"VSALK3\", \"HSALKV\", \"KSALKV\", \"OSALKV\", \"VSALKV\", \"HPVPRS\", \"KPVPRS\", \"OPVPRS\", \"VPVPRS\", \"HSTPRS\", \"KSTPRS\", \"OSTPRS\", \"VSTPRS\", \"HSLALT\", \"KSLALT\", \"OSLALT\", \"VSLALT\", \"HSLEXT\", \"KSLEXT\", \"OSLEXT\", \"VSLEXT\", \"HVKWRT\", \"HVKSAL\", \"MSL\", \"MFSL\", \"VMSL\", \"VMFSL\", \"RMSL\", \"QUANT1\", \"QUANT2\", \"QUANT3\", \"CO_MEGBTR\", \"CO_MEFBTR\", \"LBKUM\", \"DRCRK\", \"POPER\", \"PERIV\", \"FISCYEARPER\", \"BUDAT\", \"BLDAT\", \"BLART\", \"BUZEI\", \"ZUONR\", \"BSCHL\", \"BSTAT\", \"LINETYPE\", \"KTOSL\", \"SLALITTYPE\", \"XSPLITMOD\", \"USNAM\", \"TIMESTAMP\", \"EPRCTR\", \"RHOART\", \"GLACCOUNT_TYPE\", \"KTOPL\", \"LOKKT\", \"KTOP2\", \"REBZG\", \"REBZJ\", \"REBZZ\", \"REBZT\", \"RBEST\", \"EBELN\", \"EBELP\", \"ZEKKN\", \"SGTXT\", \"KDAUF\", \"KDPOS\", \"MATNR\", \"WERKS\", \"LIFNR\", \"KUNNR\", \"FBUDA\", \"KOART\", \"UMSKZ\", \"MWSKZ\", \"HBKID\", \"HKTID\", \"XOPVW\", \"AUGDT\", \"AUGBL\", \"AUGGJ\", \"AFABE\", \"ANLN1\", \"ANLN2\", \"BZDAT\", \"ANBWA\", \"MOVCAT\", \"DEPR_PERIOD\", \"ANLGR\", \"ANLGR2\", \"SETTLEMENT_RULE\", \"ANLKL\", \"KTOGR\", \"PANL1\", \"PANL2\", \"UBZDT_PN\", \"XVABG_PN\", \"PROZS_PN\", \"XMANPROPVAL_PN\", \"KALNR\", \"VPRSV\", \"MLAST\", \"KZBWS\", \"XOBEW\", \"SOBKZ\", \"VTSTAMP\", \"MAT_KDAUF\", \"MAT_KDPOS\", \"MAT_PSPNR\", \"MAT_PS_POSID\", \"MAT_LIFNR\", \"BWTAR\", \"BWKEY\", \"HPEINH\", \"KPEINH\", \"OPEINH\", \"VPEINH\", \"MLPTYP\", \"MLCATEG\", \"QSBVALT\", \"QSPROCESS\", \"PERART\", \"MLPOSNR\", \"BUKRS_SENDER\", \"RACCT_SENDER\", \"ACCAS_SENDER\", \"ACCASTY_SENDER\", \"OBJNR\", \"HRKFT\", \"HKGRP\", \"PAROB1\", \"PAROBSRC\", \"USPOB\", \"CO_BELKZ\", \"CO_BEKNZ\", \"BELTP\", \"MUVFLG\", \"GKONT\", \"GKOAR\", \"ERLKZ\", \"PERNR\", \"PAOBJNR\", \"XPAOBJNR_CO_REL\", \"SCOPE\", \"LOGSYSO\", \"PBUKRS\", \"PSCOPE\", \"LOGSYSP\", \"BWSTRAT\", \"OBJNR_HK\", \"AUFNR_ORG\", \"UKOSTL\", \"ULSTAR\", \"UPRZNR\", \"UPRCTR\", \"ACCAS\", \"ACCASTY\", \"LSTAR\", \"AUFNR\", \"AUTYP\", \"PS_PSP_PNR\", \"PS_POSID\", \"PS_PSPID\", \"NPLNR\", \"NPLNR_VORGN\", \"PRZNR\", \"KSTRG\", \"BEMOT\", \"RSRCE\", \"QMNUM\", \"ERKRS\", \"PACCAS\", \"PACCASTY\", \"PLSTAR\", \"PAUFNR\", \"PAUTYP\", \"PPS_POSID\", \"PPS_PSPID\", \"PKDAUF\", \"PKDPOS\", \"PPAOBJNR\", \"PNPLNR\", \"PNPLNR_VORGN\", \"PPRZNR\", \"PKSTRG\", \"CO_ACCASTY_N1\", \"CO_ACCASTY_N2\", \"CO_ACCASTY_N3\", \"CO_ZLENR\", \"CO_BELNR\", \"CO_BUZEI\", \"CO_BUZEI1\", \"CO_BUZEI2\", \"CO_BUZEI5\", \"CO_BUZEI6\", \"CO_BUZEI7\", \"CO_REFBZ\", \"CO_REFBZ1\", \"CO_REFBZ2\", \"CO_REFBZ5\", \"CO_REFBZ6\", \"CO_REFBZ7\", \"WORK_ITEM_ID\", \"ARBID\", \"VORNR\", \"AUFPS\", \"UVORN\", \"EQUNR\", \"TPLNR\", \"ISTRU\", \"ILART\", \"PLKNZ\", \"ARTPR\", \"PRIOK\", \"MAUFNR\", \"MATKL_MM\", \"PLANNED_PARTS_WORK\", \"FKART\", \"VKORG\", \"VTWEG\", \"SPART\", \"MATNR_COPA\", \"MATKL\", \"KDGRP\", \"LAND1\", \"BRSCH\", \"BZIRK\", \"KUNRE\", \"KUNWE\", \"KONZS\", \"ACDOC_COPA_EEW_DUMMY_PA\", \"AUGRU_PA\", \"WWBUC_PA\", \"WWFRA_PA\", \"WWPDT_PA\", \"WWSEG_PA\", \"WWSPA_PA\", \"WWSPB_PA\", \"WWSR_PA\", \"WWST_PA\", \"VBUND_PA\", \"RE_BUKRS\", \"RE_ACCOUNT\", \"FIKRS\", \"FISTL\", \"MEASURE\", \"RFUND\", \"RGRANT_NBR\", \"RBUDGET_PD\", \"SFUND\", \"SGRANT_NBR\", \"SBUDGET_PD\", \"VNAME\", \"EGRUP\", \"RECID\", \"VPTNR\", \"BTYPE\", \"ETYPE\", \"PRODPER\", \"SWENR\", \"SGENR\", \"SGRNR\", \"SMENR\", \"RECNNR\", \"SNKSL\", \"SEMPSL\", \"DABRZ\", \"PSWENR\", \"PSGENR\", \"PSGRNR\", \"PSMENR\", \"PRECNNR\", \"PSNKSL\", \"PSEMPSL\", \"PDABRZ\", \"ACDOC_EEW_DUMMY\", \"DUMMY_INCL_EEW_COBL\", \"FUP_ACTION\", \"MIG_SOURCE\", \"MIG_DOCLN\", \"_DATAAGING\", \"WWBRD_PA\", \"WWCPD_PA\", \"WWMVN_PA\", \"WWPTY_PA\", \"WWRIT_PA\", \"WWTHN_PA\" From \"SAPPRD\".\"ACDOCA\" WHERE \"RACCT\" IN ( '0000450102', '0000450103', '0000450104', '0000470102', '0000470103', '0000470104') AND \"RLDNR\" = '0L' AND \"BLART\" = 'CB') AS acdoca_query",
          "--final_file_name": "from_SAP/for_ingestion/acdoca_output.csv"
        }
      },
      "Catch": [
        {
          "ErrorEquals": [
            "States.ALL"
          ],
          "ResultPath": "$.glue_error",
          "Next": "Parse_Glue_Error_Lambda"
        }
      ],
      "Next": "Extract_BSAK"
    },
    "Extract_BSAK": {
      "Comment": "Filtered extract of SAPPRD.BSAK - current year only",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName": "isg-esatp-dv-sap_2_s3-glue",
        "Arguments": {
          "--table_name": "(select \"MANDT\", \"BUKRS\", \"LIFNR\", \"UMSKS\", \"UMSKZ\", \"AUGDT\", \"MONAT\", \"SHKZG\", \"BSCHL\", \"GJAHR\", \"BELNR\", \"BLDAT\", \"XBLNR\", \"BLART\", \"SKFBT\", \"AUGBL\", \"XREF3\", \"SGTXT\", \"QBSHB\", \"WRBTR\", \"ZUONR\", \"BUZEI\", \"WAERS\", \"GHKON\" From \"SAPPRD\".\"BSAK\" Where \"GJAHR\" > 2018) AS bsak_query",
          "--final_file_name": "from_SAP/for_ingestion/bsak_output.csv"
        }
      },
      "Catch": [
        {
          "ErrorEquals": [
            "States.ALL"
          ],
          "ResultPath": "$.glue_error",
          "Next": "Parse_Glue_Error_Lambda"
        }
      ],
      "Next": "Extract_BSIK"
    },
    "Extract_BSIK": {
      "Comment": "Filtered extract of SAPPRD.BSIK - purchase orders",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName": "isg-esatp-dv-sap_2_s3-glue",
        "Arguments": {
          "--table_name": "(Select \"MANDT\", \"BUKRS\", \"LIFNR\", \"ZUONR\", \"GJAHR\", \"BELNR\", \"BUZEI\", \"BUDAT\", \"BLDAT\", \"CPUDT\", \"WAERS\",\"XBLNR\", \"BLART\",\"BSCHL\", \"SHKZG\", \"DMBTR\", \"WRBTR\", \"SGTXT\", \"SAKNR\", \"HKONT\", \"DMBT1\", \"WRBT1\", \"MWSK2\", \"DMBT2\", \"WRBT2\", \"MWSK3\", \"DMBT3\", \"WRBT3\", \"DMBE2\", \"DMBE3\", \"DMB21\", \"DMB22\", \"DMB23\", \"DMB31\", \"DMB32\", \"DMB33\", \"MWST2\", \"MWST3\", \"SKNT2\", \"SKNT3\", \"BDIF3\" From \"SAPPRD\".\"BSIK\") AS bsik_query",
          "--final_file_name": "from_SAP/for_ingestion/bsik_output.csv"
        }
      },
      "Catch": [
        {
          "ErrorEquals": [
            "States.ALL"
          ],
          "ResultPath": "$.glue_error",
          "Next": "Parse_Glue_Error_Lambda"
        }
      ],
      "End": true
    },
    "Parse_Glue_Error_Lambda": {
      "Type": "Task",
      "Resource": "arn:aws:states:::lambda:invoke",
      "Parameters": {
        "FunctionName": "arn:aws:lambda:ap-southeast-1:782221581292:function:isg-esatp-dv-error_parser-lambda",
        "Payload": {
          "raw_cause.$": "$.glue_error.Cause"
        }
      },
      "ResultSelector": {
        "cleaned_cause.$": "$.Payload.cleaned_cause"
      },
      "ResultPath": "$.clean_error_payload",
      "Next": "SAP_Extract_Pipeline_ERROR"
    },
    "SAP_Extract_Pipeline_ERROR": {
      "Type": "Fail",
      "Error": "PipelineJobFailed",
      "CausePath": "$.clean_error_payload.cleaned_cause"
    }
  }
}