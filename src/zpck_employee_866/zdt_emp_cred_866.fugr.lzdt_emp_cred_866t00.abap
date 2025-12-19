*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZDT_EMP_CRED_866................................*
DATA:  BEGIN OF STATUS_ZDT_EMP_CRED_866              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZDT_EMP_CRED_866              .
CONTROLS: TCTRL_ZDT_EMP_CRED_866
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZDT_EMP_CRED_866              .
TABLES: ZDT_EMP_CRED_866               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
