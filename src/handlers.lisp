(in-package #:rocketman)

(defmethod set-key ((obj rocket) track-id row value interpolation)
  (let* ((track    (aref (state-tracks obj) track-id))
         (position (position row track :key #'key-row :test #'=)))
    (if position
        ;; Replace row values
        (setf (key-value         (nth position track)) value
              (key-interpolation (nth position track)) interpolation)
        ;; Push new row to list
        (progn (push (make-key :row row :value value :interpolation interpolation)
                     (aref (state-tracks obj) track-id))
               (sort (aref (state-tracks obj) track-id) #'<
                     :key #'key-row)))))

(defmethod handle-set-key ((obj rocket) stream)
  (let ((track-id      (read-int   stream))
        (row           (read-int   stream))
        (value         (read-float stream))
        (interpolation (read-byte  stream)))
    (set-key obj track-id row value interpolation)))
(defmethod handle-delete-key ((obj rocket) stream)
  (let* ((track-id (read-int stream))
         (row      (read-int stream))
         (keys     (aref (state-tracks obj) track-id)))
    (setf (aref (state-tracks obj) track-id)
          (remove row keys :key #'key-row :test #'=))))
(defmethod handle-set-row ((obj rocket) stream)
  (setf (state-row obj) (read-int stream)))
(defmethod handle-pause ((obj rocket) stream)
  (setf (state-pausedp obj) (read-byte stream)))
;; TODO: handle-save-tracks
(defmethod handle-save-tracks ((obj rocket) stream))

(defmethod update progn ((obj rocket))
  (let ((stream (usocket:socket-stream (con-socket obj))))
    (when (listen stream)
      (ecase (read-byte stream)
        (0 (handle-set-key     obj stream))
        (1 (handle-delete-key  obj stream))
        (3 (handle-set-row     obj stream))
        (4 (handle-pause       obj stream))
        (5 (handle-save-tracks obj stream))))))
