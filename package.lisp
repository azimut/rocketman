;;;; package.lisp

(defpackage #:rocketman
  (:local-nicknames (#:a #:alexandria))
  (:use #:cl)
  (:export #:make-rocket
           #:add-track
           #:get-track
           #:connect
           #:update
           #:disconnect))
