(in-package #:rocketman)

(defun load-tracks ()
  (let* ((plump:*tag-dispatchers* plump:*xml-tags*)
         (node (plump:parse #p "/home/sendai/test.rocket"))
         (rows (parse-integer (plump:attribute (plump:first-child node) "ROWS")))
         (tracks (plump:get-elements-by-tag-name node "TRACK")))
    (values node
            rows
            tracks)))
