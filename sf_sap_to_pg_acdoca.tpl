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
          "--query": "SELECT \"RCLNT\", \"RLDNR\", \"RBUKRS\", \"GJAHR\", \"BELNR\", \"DOCLN\", \"RYEAR\", \"DOCNR_LD\", \"RRCTY\", \"RMVCT\", \"VORGN\", \"VRGNG\", \"BTTYPE\", \"AWTYP\", \"AWSYS\", \"AWORG\", \"AWREF\", \"AWITEM\", \"AWITGRP\", \"SUBTA\", \"XREVERSING\", \"XREVERSED\", \"XTRUEREV\", \"AWTYP_REV\", \"AWORG_REV\", \"AWREF_REV\", \"SUBTA_REV\", \"XSETTLING\", \"XSETTLED\", \"PREC_AWTYP\", \"PREC_AWSYS\", \"PREC_AWORG\", \"PREC_AWREF\", \"PREC_AWITEM\", \"PREC_SUBTA\", \"PREC_AWMULT\", \"XSECONDARY\", \"SRC_AWTYP\", \"SRC_AWSYS\", \"SRC_AWORG\", \"SRC_AWREF\", \"SRC_AWITEM\", \"SRC_AWSUBIT\", \"XCOMMITMENT\", \"RTCUR\", \"RWCUR\", \"RHCUR\", \"RKCUR\", \"ROCUR\", \"RVCUR\", \"RBCUR\", \"RCCUR\", \"RDCUR\", \"RECUR\", \"RFCUR\", \"RGCUR\", \"RCO_OCUR\", \"RUNIT\", \"RVUNIT\", \"RRUNIT\", \"RIUNIT\", \"QUNIT1\", \"QUNIT2\", \"QUNIT3\", \"CO_MEINH\", \"RACCT\", \"RCNTR\", \"PRCTR\", \"RFAREA\", \"RBUSA\", \"KOKRS\", \"SEGMENT\", \"SCNTR\", \"PPRCTR\", \"SFAREA\", \"SBUSA\", \"RASSC\", \"PSEGMENT\", \"TSL\", \"WSL\", \"WSL2\", \"WSL3\", \"HSL\", \"KSL\", \"OSL\", \"VSL\", \"BSL\", \"CSL\", \"DSL\", \"ESL\", \"FSL\", \"GSL\", \"KFSL\", \"KFSL2\", \"KFSL3\", \"PSL\", \"PSL2\", \"PSL3\", \"PFSL\", \"PFSL2\", \"PFSL3\", \"CO_OSL\", \"HSALK3\", \"KSALK3\", \"OSALK3\", \"VSALK3\", \"HSALKV\", \"KSALKV\", \"OSALKV\", \"VSALKV\", \"HPVPRS\", \"KPVPRS\", \"OPVPRS\", \"VPVPRS\", \"HSTPRS\", \"KSTPRS\", \"OSTPRS\", \"VSTPRS\", \"HSLALT\", \"KSLALT\", \"OSLALT\", \"VSLALT\", \"HSLEXT\", \"KSLEXT\", \"OSLEXT\", \"VSLEXT\", \"HVKWRT\", \"HVKSAL\", \"MSL\", \"MFSL\", \"VMSL\", \"VMFSL\", \"RMSL\", \"QUANT1\", \"QUANT2\", \"QUANT3\", \"CO_MEGBTR\", \"CO_MEFBTR\", \"LBKUM\", \"DRCRK\", \"POPER\", \"PERIV\", \"FISCYEARPER\", \"BUDAT\", \"BLDAT\", \"BLART\", \"BUZEI\", \"ZUONR\", \"BSCHL\", \"BSTAT\", \"LINETYPE\", \"KTOSL\", \"SLALITTYPE\", \"XSPLITMOD\", \"USNAM\", \"TIMESTAMP\", \"EPRCTR\", \"RHOART\", \"GLACCOUNT_TYPE\", \"KTOPL\", \"LOKKT\", \"KTOP2\", \"REBZG\", \"REBZJ\", \"REBZZ\", \"REBZT\", \"RBEST\", \"EBELN\", \"EBELP\", \"ZEKKN\", \"SGTXT\", \"KDAUF\", \"KDPOS\", \"MATNR\", \"WERKS\", \"LIFNR\", \"KUNNR\", \"FBUDA\", \"KOART\", \"UMSKZ\", \"MWSKZ\", \"HBKID\", \"HKTID\", \"XOPVW\", \"AUGDT\", \"AUGBL\", \"AUGGJ\", \"AFABE\", \"ANLN1\", \"ANLN2\", \"BZDAT\", \"ANBWA\", \"MOVCAT\", \"DEPR_PERIOD\", \"ANLGR\", \"ANLGR2\", \"SETTLEMENT_RULE\", \"ANLKL\", \"KTOGR\", \"PANL1\", \"PANL2\", \"UBZDT_PN\", \"XVABG_PN\", \"PROZS_PN\", \"XMANPROPVAL_PN\", \"KALNR\", \"VPRSV\", \"MLAST\", \"KZBWS\", \"XOBEW\", \"SOBKZ\", \"VTSTAMP\", \"MAT_KDAUF\", \"MAT_KDPOS\", \"MAT_PSPNR\", \"MAT_PS_POSID\", \"MAT_LIFNR\", \"BWTAR\", \"BWKEY\", \"HPEINH\", \"KPEINH\", \"OPEINH\", \"VPEINH\", \"MLPTYP\", \"MLCATEG\", \"QSBVALT\", \"QSPROCESS\", \"PERART\", \"MLPOSNR\", \"BUKRS_SENDER\", \"RACCT_SENDER\", \"ACCAS_SENDER\", \"ACCASTY_SENDER\", \"OBJNR\", \"HRKFT\", \"HKGRP\", \"PAROB1\", \"PAROBSRC\", \"USPOB\", \"CO_BELKZ\", \"CO_BEKNZ\", \"BELTP\", \"MUVFLG\", \"GKONT\", \"GKOAR\", \"ERLKZ\", \"PERNR\", \"PAOBJNR\", \"XPAOBJNR_CO_REL\", \"SCOPE\", \"LOGSYSO\", \"PBUKRS\", \"PSCOPE\", \"LOGSYSP\", \"BWSTRAT\", \"OBJNR_HK\", \"AUFNR_ORG\", \"UKOSTL\", \"ULSTAR\", \"UPRZNR\", \"UPRCTR\", \"ACCAS\", \"ACCASTY\", \"LSTAR\", \"AUFNR\", \"AUTYP\", \"PS_PSP_PNR\", \"PS_POSID\", \"PS_PSPID\", \"NPLNR\", \"NPLNR_VORGN\", \"PRZNR\", \"KSTRG\", \"BEMOT\", \"RSRCE\", \"QMNUM\", \"ERKRS\", \"PACCAS\", \"PACCASTY\", \"PLSTAR\", \"PAUFNR\", \"PAUTYP\", \"PPS_POSID\", \"PPS_PSPID\", \"PKDAUF\", \"PKDPOS\", \"PPAOBJNR\", \"PNPLNR\", \"PNPLNR_VORGN\", \"PPRZNR\", \"PKSTRG\", \"CO_ACCASTY_N1\", \"CO_ACCASTY_N2\", \"CO_ACCASTY_N3\", \"CO_ZLENR\", \"CO_BELNR\", \"CO_BUZEI\", \"CO_BUZEI1\", \"CO_BUZEI2\", \"CO_BUZEI5\", \"CO_BUZEI6\", \"CO_BUZEI7\", \"CO_REFBZ\", \"CO_REFBZ1\", \"CO_REFBZ2\", \"CO_REFBZ5\", \"CO_REFBZ6\", \"CO_REFBZ7\", \"WORK_ITEM_ID\", \"ARBID\", \"VORNR\", \"AUFPS\", \"UVORN\", \"EQUNR\", \"TPLNR\", \"ISTRU\", \"ILART\", \"PLKNZ\", \"ARTPR\", \"PRIOK\", \"MAUFNR\", \"MATKL_MM\", \"PLANNED_PARTS_WORK\", \"FKART\", \"VKORG\", \"VTWEG\", \"SPART\", \"MATNR_COPA\", \"MATKL\", \"KDGRP\", \"LAND1\", \"BRSCH\", \"BZIRK\", \"KUNRE\", \"KUNWE\", \"KONZS\", \"ACDOC_COPA_EEW_DUMMY_PA\", \"AUGRU_PA\", \"WWBUC_PA\", \"WWFRA_PA\", \"WWPDT_PA\", \"WWSEG_PA\", \"WWSPA_PA\", \"WWSPB_PA\", \"WWSR_PA\", \"WWST_PA\", \"VBUND_PA\", \"RE_BUKRS\", \"RE_ACCOUNT\", \"FIKRS\", \"FISTL\", \"MEASURE\", \"RFUND\", \"RGRANT_NBR\", \"RBUDGET_PD\", \"SFUND\", \"SGRANT_NBR\", \"SBUDGET_PD\", \"VNAME\", \"EGRUP\", \"RECID\", \"VPTNR\", \"BTYPE\", \"ETYPE\", \"PRODPER\", \"SWENR\", \"SGENR\", \"SGRNR\", \"SMENR\", \"RECNNR\", \"SNKSL\", \"SEMPSL\", \"DABRZ\", \"PSWENR\", \"PSGENR\", \"PSGRNR\", \"PSMENR\", \"PRECNNR\", \"PSNKSL\", \"PSEMPSL\", \"PDABRZ\", \"ACDOC_EEW_DUMMY\", \"DUMMY_INCL_EEW_COBL\", \"FUP_ACTION\", \"MIG_SOURCE\", \"MIG_DOCLN\", \"_DATAAGING\", \"WWBRD_PA\", \"WWCPD_PA\", \"WWMVN_PA\", \"WWPTY_PA\", \"WWRIT_PA\", \"WWTHN_PA\" FROM \"SAPPRD\".\"ACDOCA\";",
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
          "--s4_table_name": "acdoca",   
          "--input_file_name": "from_SAP/for_ingestion/acdoca_output.json"
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
          "email_subject": "[SUCCESS] Daily ingestion of ACDOCA",
          "email_body": "✅ Processing Complete: Successfully synced S4HANA ACDOCA table."
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
          "email_subject": "[FAILED] Daily ingestion of ACDOCA ",
          "email_body.$": "States.Format('❌ Processing Failed: Unexpected issue was encountered while processing. \n\nError: {}\n\nPlease check the cloudwatch logs for details.', $.glue_error.Cause)"
        }
      },
      "ResultPath": null,
      "End": true
    }
  }
}