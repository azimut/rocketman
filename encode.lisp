(in-package #:rocketman)

(defun encode-int-be (stream value size)
  (loop :for i :from (* (1- size) 8) :downto 0 :by 8
        :do (write-byte (ldb (byte 8 i) value) stream)))

(defun write-int (value stream)
  (encode-int-be stream value 4))
