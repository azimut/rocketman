;;;; rocketman.lisp

;; TODO: reinitilize rocket instance?

(in-package #:rocketman)

(a:define-constant +CLIENT-GREET+
  "hello, synctracker!" :test #'equal)
(a:define-constant +SERVER-GREET+
  "hello, demo!" :test #'equal)

(defclass key ()
  ((row           :accessor key-row           :initarg :row)
   (value         :accessor key-value         :initarg :value)
   (interpolation :accessor key-interpolation :initarg :interpolation))
  (:documentation "track row element"))

(defclass state ()
  ((pausedp :accessor state-pausedp :initarg :pausedp)
   (row     :accessor state-row     :initarg :row :documentation "current row")
   (rps     :accessor state-rps     :initarg :rps :documentation "rows per second")
   (lmp     :accessor state-lmp     :initarg :lmp :documentation "last meter point")
   (name2id :accessor state-name2id :initarg :name2id)
   (tracks  :accessor state-tracks  :initarg :tracks))
  (:default-initargs
   :row 0f0
   :rps 10
   :lmp 0f0
   :pausedp 0
   :name2id (make-hash-table :test #'equal)
   :tracks (make-array 0 :adjustable t :fill-pointer 0)))

(defclass rocket (state)
  ((socket  :accessor con-socket  :initarg :socket)
   (host    :accessor con-host    :initarg :host)
   (port    :accessor con-port    :initarg :port))
  (:default-initargs
   :socket NIL
   :host "127.0.0.1"
   :port 1338)
  (:documentation "connection"))

(defparameter *rocket* (make-instance 'rocket))

(defun init-rocket ()
  (disconnect *rocket*)
  (connect    *rocket*))

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
      (setf (state-lmp obj) (* .001f0 (get-internal-real-time))))
    (let* ((meter (* .001f0 (get-internal-real-time)))
           (time-span (- meter (state-lmp obj))))
      (setf (state-lmp obj) meter)
      (setf (state-row obj) (+ (state-row obj) (* time-span (state-rps obj)))))))

(defmethod add-track ((obj rocket) name)
  (let ((stream (usocket:socket-stream (con-socket obj))))
    (write-byte 2 stream)
    (write-int (length name) stream)
    (write-sequence (babel:string-to-octets name) stream)
    (finish-output stream))
  (let ((id (length (state-tracks obj))))
    (vector-push-extend (list) (state-tracks obj))
    (setf (gethash name (state-name2id obj)) id)))

(defmethod change-row ((obj rocket) row)
  (let ((stream (usocket:socket-stream (con-socket obj))))
    (write-byte 3 stream)
    (write-int (floor row) stream)
    (finish-output stream)))

(defmethod (setf state-row) :before (value obj)
  (unless (= (state-row obj) value)
    (change-row obj value)))

(defmethod (setf state-pausedp) :after (value obj)
  (when (zerop value)
    (setf (state-lmp obj) 0f0)))
