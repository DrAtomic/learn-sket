;;;; cl-art.lisp

(in-package #:cl-art)

(defun make-grid (width height number-of-rect)
  (let ((width-space (/ width number-of-rect))
	(height-space (/ height number-of-rect)))
    (dotimes (x number-of-rect)
      (dotimes (y number-of-rect)
	(rect (* x width-space) (* y height-space) 100 100)))))

(defsketch art
    ((title "simple rects")
     (width 800)
     (height 600)
     (copy-pixels t))
  (background (gray 1))
  (make-grid width height 5))

(defmethod setup ((instance art) &key &allow-other-keys)
  (background (gray 1)))

(make-instance 'cl-art:art)
