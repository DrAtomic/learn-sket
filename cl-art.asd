;;;; cl-art.asd

(asdf:defsystem #:cl-art
  :description "learning sketch"
  :license  "MIT"
  :version "0.0.1"
  :serial t
  :depends-on (#:sketch)
  :components ((:file "package")
               (:file "cl-art")))
