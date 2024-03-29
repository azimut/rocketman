;;;; rocketman.lisp

;; TODO: reinitilize rocket instance?
;; TODO: handle disconnect (program closed)

(in-package #:rocketman)

(a:define-constant +CLIENT-GREET+
  "hello, synctracker!" :test #'equal)
(a:define-constant +SERVER-GREET+
  "hello, demo!" :test #'equal)

(defstruct key
  (row 0 :type fixnum)
  (value 0f0 :type single-float)
  (interpolation 0 :type fixnum))

(defclass state ()
  ((pausedp :accessor state-pausedp :initarg :pausedp)
   (row     :accessor state-row     :initarg :row :documentation "current row")
   (rps     :accessor state-rps     :initarg :rps :documentation "rows per second")
   (lmp     :accessor state-lmp     :initarg :lmp :documentation "last meter point")
   (name2id :accessor state-name2id :initarg :name2id)
   (tracks  :accessor state-tracks  :initarg :tracks
            :documentation "adjustable vector of lists of structs of type key")
   (stime   :accessor state-stime   :initarg :stime))
  (:default-initargs
   :row 0d0
   :rps 10
   :lmp 0d0
   :pausedp 0
   :name2id (make-hash-table :test #'equal)
   :tracks (make-array 0 :adjustable t :fill-pointer 0)
   :stime (local-time:now))
  (:documentation "container for the rocket state"))

(defclass rocket (state)
  ((socket :accessor con-socket :initarg :socket)
   (host   :accessor con-host   :initarg :host)
   (port   :accessor con-port   :initarg :port))
  (:default-initargs
   :socket NIL
   :host "127.0.0.1"
   :port 1338)
  (:documentation "connection"))

(defun make-rocket (&key (rps 10))
  (make-instance 'rocket :rps rps))

(defvar *rocket* (make-rocket)
  "default ROCKET object")

(defmethod connect ((obj rocket))
  (setf (con-socket obj)
        (usocket:socket-connect
         (con-host obj)
         (con-port obj)
         :element-type '(unsigned-byte 8))))

(defmethod connect :after ((obj rocket))
  (let ((stream (usocket:socket-stream (con-socket obj)))
        (response (make-array (length +SERVER-GREET+)))
        (client-greet (babel:string-to-octets +CLIENT-GREET+))
        (server-greet (babel:string-to-octets +SERVER-GREET+)))
    (write-sequence client-greet stream)
    (finish-output stream)
    (read-sequence response stream)
    (assert (equalp response server-greet))))

(defmethod disconnect ((obj rocket))
  (when (con-socket obj)
    (usocket:socket-close (con-socket obj))
    (setf (con-socket obj) nil)))

(defgeneric update (obj) (:method-combination progn))
(defmethod update progn ((obj state))
  (when (zerop (state-pausedp obj))
    (when (zerop (state-lmp obj))
      (setf (state-lmp obj) (local-time:timestamp-difference (local-time:now)
                                                             (state-stime obj))))
    (let* ((meter (local-time:timestamp-difference (local-time:now)
                                                   (state-stime obj)))
           (time-span (- meter (state-lmp obj))))
      (setf (state-lmp obj) meter)
      (setf (state-row obj) (+ (state-row obj) (* time-span (state-rps obj))))
      (change-row obj (state-row obj)))))

(defmethod (setf state-pausedp) :after (value obj)
  (when (zerop value)
    (setf (state-lmp obj) 0d0)))
