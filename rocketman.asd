;;;; rocketman.asd

(asdf:defsystem #:rocketman
  :description "Describe rocketman here"
  :author "azimut <azimut.github@protonmail.com>"
  :license  "MIT"
  :version "0.0.1"
  :serial t
  :depends-on (#:alexandria
               #:bordeaux-threads
               #:babel
               #:ieee-floats
               #:plump
               #:usocket)
  :components ((:file "package")
               (:file "decode")
               (:file "encode")
               (:file "rocketman")
               (:file "receive")
               (:file "standalone")
               (:file "file")))