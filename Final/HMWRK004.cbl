       IDENTIFICATION DIVISION.
       PROGRAM-ID. HMWRK004.
       AUTHOR.     KAAN KANIG.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT OUT-FILE  ASSIGN TO OUTFILE
                            STATUS OUT-ST.
           SELECT INP-FILE  ASSIGN TO INPFILE
                            STATUS INP-ST.
       DATA DIVISION.
       FILE SECTION.
       FD  OUT-FILE RECORDING MODE F.
       01  OUT-REC.
           05 OUT-ISLEM-TIPI          PIC X(01).
           05 OUT-ID                  PIC 9(05).
           05 OUT-DVZ                 PIC 9(03).
           05 OUT-RETURN-CODE         PIC 9(02).
           05 OUT-ACIKLAMA            PIC X(30).
           05 OUT-FROM                PIC X(15).
           05 OUT-TO                  PIC X(15).
       FD  INP-FILE RECORDING MODE F.
       01  INP-REC.
           05 INP-ISLEM-TIPI            PIC X(01).
           05 INP-ID                    PIC X(05).
           05 INP-DVZ                   PIC X(03).
    *
       WORKING-STORAGE SECTION.
         01  WS-WORK-AREA.
           05 WS-HMWRIDX             PIC X(08)  VALUE 'HMWRIDX'
           05 OUT-ST                 PIC 9(02).
              88 OUT-SUCCESS                    VALUE 00 97.
           05 INP-ST                 PIC 9(02).
              88 INP-EOF                        VALUE 10.
              88 INP-SUCCES                     VALUE 00 97.
           05 WS-ISLEM-TIPI          PIC 9(01).
              88 WS-ISLEM-TIPI-VALID      VALUE 1 THRU 9.
           05 WS-SUB-AREA.
              07 WS-SUB-FUNC         PIC 9(01).
                 88 WS-FUNC-OPEN                VALUE 1.
                 88 WS-FUNC-UPDATE              VALUE 3.
                 88 WS-FUNC-CLOSE               VALUE 9.
              07 WS-SUB-ID           PIC 9(05).
              07 WS-SUB-DVZ          PIC 9(03).
              07 WS-SUB-RC           PIC 9(02).
              07 WS-SUB-DATA         PIC X(60).

       PROCEDURE DIVISION.
       0000-MAIN.
           PERFORM H100-OPEN-FILES
           PERFORM H200-PROCESS UNTIL INP-EOF.
           PERFORM H999-PROGRAM-EXIT.
       H100-OPEN-FILES.
           OPEN INPUT  INP-FILE.
           OPEN OUTPUT OUT-FILE.
           READ  INP-FILE.
           SET   WS-FUNC-OPEN TO TRUE.
           CALL  WS-HMWRIDX USING WS-SUB-AREA.
        H100-END. EXIT.

       H200-PROCESS.
           MOVE INP-ISLEM-TIPI TO WS-ISLEM-TIPI
           IF WS-ISLEM-TIPI-VALID
              EVALUATE WS-ISLEM-TIPI
                  WHEN 3
                    SET WS-FUNC-UPDATE TO TRUE
                  WHEN OTHER
                     SET WS-FUNC-READ TO TRUE
               END-EVALUATE.
               MOVE INP-ID        TO WS-SUB-ID
               MOVE INP-DVZ       TO WS-SUB-DVZ
               MOVE ZEROS         TO WS-SUB-RC
               MOVE SPACES        TO WS-SUB-DATA
               CALL WS-HMWRIDX    USING WS-SUB-AREA
           ELSE
               STRING 'INVALID ISLEM TIPI: ' INP-ISLEM-TIPI
                DELIMITED BY SIZE INTO OUT-REC
                WRITE OUT-REC
           END-IF
           READ INP-FILE.
       H200-END. EXIT.
       H300-CLOSE-FILES.
           CLOSE INP-FILE
                 OUT-FILE.
           SET WS-FUNC-CLOSE TO TRUE.
           CALL WS-HMWRIDX  USING WS-SUB-AREA.
       H300-END. EXIT.
       H999-PROGRAM-EXIT.
           STOP RUN.
       H999-END. EXIT.
