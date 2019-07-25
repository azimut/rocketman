(in-package #:rocketman)

(defun decode-int-be (stream size)
  "big endian"
  (let ((int 0))
    (loop :for i :from (- size 1) :downto 0
          :do (setf (ldb (byte 8 (* 8 i)) int)
                    (read-byte stream)))
    int))

(defun read-int (stream)
  (decode-int-be stream 4))

(defun read-float (stream)
  (ieee-floats:decode-float32
   (read-int stream)))
