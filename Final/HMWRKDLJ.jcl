//SORTREPR JOB ' ',CLASS=A,MSGLEVEL=(1,1),
//          MSGCLASS=X,NOTIFY=&SYSUID
//DELET100 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN DD *
   DELETE Z95632.QSAM.XX NONVSAM
   IF LASTCC LE 08 THEN SET MAXCC = 00
//DELET500 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN DD *
    DELETE Z95632.VSAM.XX CLUSTER PURGE
    IF LASTCC LE 08 THEN SET MAXCC = 00
        DEF CL ( NAME(Z95632.VSAM.XX)         -
                FREESPACE( 20 20 )            -
                SHR( 2,3 )                    -
                KEYS(5 0)                     -
                INDEXED SPEED                 -
                RECSZ(47 47)                  -
                TRK (10 10)                   -
                LOG(NONE)                     -
                VOLUMES (VPWRKB)              -
                UNIQUE )                      -
        DATA ( NAME(Z95632.VSAM.XX.DATA))     -
        INDEX ( NAME(Z95632.VSAM.XX.INDEX))
//REPRO600 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//INN001 DD DSN=Z95632.QSAM.YY,DISP=SHR
//OUT001 DD DSN=Z95632.VSAM.XX,DISP=SHR
//SYSIN DD *
    REPRO INFILE(INN001) OUTFILE(OUT001)
