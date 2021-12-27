;;;; cl-art.lisp

(in-package #:cl-art)

(defsketch art
    ((title "simple rects")
     (width 800)
     (height 600)
     (copy-pixels t))
  (rect 300 10 100 100)
  (rect 100 550 100 100))

(defmethod setup ((instance art) &key &allow-other-keys)
  (background (gray 1)))

(make-instance 'cl-art:art)
