(in-package #:rocketman)

;; TODO: handle  <group name="cube:" />
;; TODO: total rows??

(defmethod load-file :around (obj filename)
  (setf (fill-pointer (state-tracks obj)) 0)
  (call-next-method))

(defmethod load-file ((obj rocket) filename)
  (let* ((plump:*tag-dispatchers* plump:*xml-tags*)
         (node   (plump:parse (uiop:ensure-pathname filename)))
         (tracks (plump:get-elements-by-tag-name node "TRACK")))
    (loop :for track :in tracks
          :for n-track :from 0
          :for track-name := (plump:attribute track "NAME")
          :do (add-track obj track-name)
              (loop :for key :in (plump:get-elements-by-tag-name track "KEY")
                    :for key-row := (parse-integer (plump:attribute key "ROW"))
                    :for key-value := (parse-float:parse-float (plump:attribute key "VALUE"))
                    :for key-interpolation := (parse-integer (plump:attribute key "INTERPOLATION"))
                    :do (set-key obj n-track
                                 key-row
                                 key-value
                                 key-interpolation)))))
