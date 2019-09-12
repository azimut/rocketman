(in-package #:rocketman)

(declaim (inline interpolate))
(defun interpolate (first second row)
  (let ((dt (/ (- row (key-row first))
               (- (key-row second) (key-row first))))
        (dv (- (key-value second)
               (key-value first))))
    (declare (type single-float dv))
    (ecase (key-interpolation first)
      (0 (key-value first))
      (1 (+ (key-value first) (* dv dt)))
      (2 (+ (key-value first) (* dv (* dt dt (- 3 (* 2 dt))))))
      (3 (+ (key-value first) (* dv (expt dt 2)))))))

(defmethod get-track :around ((obj rocket) (track-id string))
  "Converts track name to id AND return zero if track is missing"
  (let ((id (gethash track-id (state-name2id obj))))
    (if id
        (get-track obj id)
        0f0)))

(defmethod get-track ((obj rocket) track-id)
  (let* ((track  (aref (state-tracks obj) track-id))
         (n-rows (length track))
         (row    (state-row obj)))
    (cond ((= 0 n-rows)
           0f0)
          ((< row (key-row (first track)))
           0f0)
          ((= 1 n-rows)
           (key-value (first track)))
          (t
           (let ((top-pos (position row track :test #'< :key #'key-row)))
             (if top-pos
                 (interpolate (nth (1- top-pos) track)
                              (nth     top-pos  track)
                              row)
                 (key-value (nth (1- n-rows) track))))))))
