*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZDT_EHSM_LGN_866................................*
DATA:  BEGIN OF STATUS_ZDT_EHSM_LGN_866              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZDT_EHSM_LGN_866              .
CONTROLS: TCTRL_ZDT_EHSM_LGN_866
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZDT_EHSM_LGN_866              .
TABLES: ZDT_EHSM_LGN_866               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
