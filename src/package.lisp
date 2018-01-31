#|
  This file is a part of while project.
  Copyright (c) 2018 Masataro Asai (guicho2.71828@gmail.com)
|#

(in-package :cl-user)
(defpackage while
  (:export :while :if :oddp :binarize :diff :>))
(defpackage while.impl
  (:use :cl :iterate :alexandria :trivia)
  (:shadowing-import-from :while :while))
(in-package :while.impl)

;; blah blah blah.

(defmacro while:while (condition &body body)
  `(do ()
       ((= 0 ,condition))
     ,@body))

(defun diff (a b) (max (- a b) 0))

(defmacro while:if (condition then else)
  (with-gensyms (aux aux2 result)
    `(let ((,aux 1) (,aux2 1) (,result 1))
       (setf ,aux ,condition
             ,aux2 1)
       (while ,aux
         (setf ,result ,then
               ,aux 0
               ,aux2 0))
       (while ,aux2
         (setf ,result ,else
               ,aux2 0))
       ,result)))

(print (while:if 1 1 0))
(print (while:if 0 1 0))

(defun while:oddp (thing)
  "O(n)"
  (while:if thing
            (let ((aux (diff thing 1)))
              (while:if aux
                        (while:oddp (diff aux 1))
                        1))
            0))

(print (while:oddp 5))
(print (while:oddp 4))

(defun while:> (a b)
  (let ((c (diff a b)))
    (while:if c
              1
              0)))

(print (while:> 5 4))
(print (while:> 4 5))

(defmacro while:binarize (thing d)
  (check-type d integer)
  (with-gensyms (aux)
    (once-only (thing)
      (if (= d 0)
          `(while:if ,thing (progn (princ 1) 1) (progn (princ 0) 0))
          `(let ((,aux (diff ,thing (expt 2 ,d))))
             (while:if ,aux
                       (progn (princ 1) (while:binarize ,aux ,(1- d)))
                       (progn (princ 0) (while:binarize ,thing ,(1- d)))))))))

(print (sb-cltl2:macroexpand-all '(while:binarize 3 2)))

(LET ((#:THING1251 3))
  (LET ((#:AUX1250 (DIFF #:THING1251 (EXPT 2 2))))
    (WHILE:IF #:AUX1250
              (PROGN (PRINC 1)
                     (LET ((#:THING1253 #:AUX1250))
                       (LET ((#:AUX1252 (DIFF #:THING1253 (EXPT 2 1))))
                         (WHILE:IF #:AUX1252
                                   (PROGN (PRINC 1)
                                          (LET ((#:THING1255 #:AUX1252))
                                            (WHILE:IF #:THING1255
                                                      (PROGN (PRINC 1) 1)
                                                      (PROGN (PRINC 0) 0))))
                                   (PROGN (PRINC 0)
                                          (LET ((#:THING1257 #:THING1253))
                                            (WHILE:IF #:THING1257
                                                      (PROGN (PRINC 1) 1)
                                                      (PROGN (PRINC 0) 0))))))))
              (PROGN (PRINC 0)
                     (LET ((#:THING1259 #:THING1251))
                       (LET ((#:AUX1258 (DIFF #:THING1259 (EXPT 2 1))))
                         (WHILE:IF #:AUX1258
                                   (PROGN (PRINC 1)
                                          (LET ((#:THING1261 #:AUX1258))
                                            (WHILE:IF #:THING1261
                                                      (PROGN (PRINC 1) 1)
                                                      (PROGN (PRINC 0) 0))))
                                   (PROGN (PRINC 0)
                                          (LET ((#:THING1263 #:THING1259))
                                            (WHILE:IF #:THING1263
                                                      (PROGN (PRINC 1) 1)
                                                      (PROGN (PRINC 0) 0)))))))))))

(print (while:binarize 5 4))

