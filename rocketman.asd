;;;; rocketman.asd

(asdf:defsystem #:rocketman
  :description "Describe rocketman here"
  :author "azimut <azimut.github@protonmail.com>"
  :license  "MIT"
  :version "0.0.1"
  :pathname "src"
  :serial t
  :depends-on (#:alexandria
               #:bordeaux-threads
               #:babel
               #:ieee-floats
               #:parse-float
               #:plump
               #:usocket)
  :components ((:file "package")
               (:file "decode")
               (:file "encode")
               (:file "rocketman")
               (:file "handlers")
               (:file "standalone")
               (:file "queries")
               (:file "file")))
