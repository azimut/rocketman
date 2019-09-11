(in-package #:rocketman)

(defmethod add-track :around ((obj rocket) name)
  "Ignore already added tracks on local state"
  (unless (member name (a:hash-table-keys (state-name2id obj))
                  :test #'string=)
    (call-next-method)))

(defmethod add-track ((obj rocket) name)
  (let ((stream (usocket:socket-stream (con-socket obj))))
    (write-byte 2 stream)
    (write-int (length name) stream)
    (write-sequence (babel:string-to-octets name) stream)
    (finish-output stream))
  (let ((new-id (length (state-tracks obj))))
    (vector-push-extend (list) (state-tracks obj))
    (setf (gethash name (state-name2id obj)) new-id)))

(defmethod pause-it ((obj rocket) value)
  (declare (type (integer 0 1) value))
  (let ((stream (usocket:socket-stream (con-socket obj))))
    (write-byte 4 stream)
    (write-byte value stream)
    (finish-output stream))
  (setf (state-pausedp obj) value))

(defmethod toggle-pause ((obj rocket))
  (if (zerop (state-pausedp obj))
      (pause-it obj 1)
      (pause-it obj 0)))

;; Handle: set state
;; Local:  set state + send msg

(defmethod change-row :around ((obj rocket) row)
  "While stored as DOUBLE an INTEGER is send"
  (call-next-method obj (floor row)))

(defmethod change-row ((obj rocket) row)
  (let ((stream (usocket:socket-stream (con-socket obj))))
    (write-byte 3 stream)
    (write-int row stream)
    (finish-output stream)))

(defmethod (setf state-row) :around (value obj)
  (when (not (= value (state-row obj)))
    (call-next-method)))

(defmethod set-row ((obj rocket) value)
  (setf (state-row obj) value)
  (change-row obj value))


