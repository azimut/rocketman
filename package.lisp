;;;; package.lisp

(defpackage #:rocketman
  (:local-nicknames (#:a #:alexandria))
  (:use #:cl)
  (:export #:make-rocket
           #:load-file
           #:add-track
           #:get-track
           #:update
           #:connect
           #:disconnect))
