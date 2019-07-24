(in-package #:rocketman)

;;(add-track "underwater:cam.x)
;;(get-track "underwater:cam.x")

(defmethod get-track :around ((obj rocket) (track-id string))
  (let ((id (gethash track-id (state-name2id obj))))
    (if id
        (get-track obj id)
        0f0)))

;; NUMBER

(declaim (inline interpolate))
(defun interpolate (first second row)
  (let ((dt (/ (- row (key-row first))
               (- (key-row second)))))
    ;; STEP = 0
    ;; LINEAR = 1
    ;; SMOOTH = 2
    ;; RAMP = 3
    (ecase (key-interpolation first)
      (0 (key-value first))
      (1 (+ (* (- (key-value second) (key-value first)) dt)
            (key-value first)))
      (2 (+ (* (- (key-value second) (key-value first)) (* dt dt (- 3 (* 2 dt))))
            (key-value first)))
      (3 (+ (* (- (key-value second) (key-value first)) (expt dt 2f0))
            (key-value first))))))

(defmethod get-track ((obj rocket) track-id)
  (let* ((track (aref (state-tracks obj) track-id))
         (n-tracks (length track))
         (row (state-row obj)))
    (cond ((= 0 n-tracks)
           (print "zero")
           (print track-id)
           (print track)
           0f0)
          ((< row (key-row (first track)))
           (print "zero one")
           0f0)
          ((= 1 n-tracks)
           (print "one")
           (key-value (first track)))
          (t (let ((top-pos (position row track :test #'< :key #'key-row)))
               (if top-pos
                   (interpolate (nth (1- top-pos) track)
                                (nth top-pos      track)
                                row)
                   (key-value (a:lastcar track))))))))

