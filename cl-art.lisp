;;;; cl-art.lisp

(in-package #:cl-art)


(defun make-grid (width height number-of-rect)
  (let ((width-space (/ width number-of-rect))
	(height-space (/ height number-of-rect)))
    (dotimes (x number-of-rect)
      (dotimes (y number-of-rect)
	(with-pen (make-pen :fill (color-filter-grayscale(hash-color (random 255))))
	  (rect (* x width-space)
		(* y height-space)
		height-space
		height-space))))))

(defsketch art
    ((title "simple rects")
     (width 800)
     (height 800)
     (copy-pixels t))
  (make-grid width height 200))

(defmethod setup ((instance art) &key &allow-other-keys)
  (background (gray 1)))

(make-instance 'cl-art:art)
