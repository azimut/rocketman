;;;; package.lisp

(defpackage #:rocketman
  (:local-nicknames (#:a #:alexandria))
  (:use #:cl)
  (:export #:make-rocket
           #:run-standalone
           #:load-file
           #:add-track
           #:get-track
           #:update
           #:connect
           #:disconnect))
