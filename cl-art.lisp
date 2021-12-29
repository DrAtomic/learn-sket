;;;; cl-art.lisp

(in-package #:cl-art)

(defun noise (list-of-offset)
  "copied from https://git.sr.ht/~aerique/black-tie/tree/master/item/src/perlin-noise.lisp"
  
  '())

(defun angle (x1 y1 x2 y2)
  "gets the angle from a line"
  (let ((a (atan (- y2 y1) (- x2 x1))))
    (if (< a 0)
	(+ a (* PI 2.0))
	a)))

(defun make-grid (width height number-of-elm)
  
  (let ((width-space (/ width number-of-elm))
	(height-space (/ height number-of-elm)))
    (dotimes (x number-of-elm)
      (dotimes (y number-of-elm)
	(with-pen (make-pen :stroke +black+ :weight 1)
	  (push-matrix)
	  (translate (* x width-space) (* y height-space))
	  (rotate 30)
	  (line 0 0 width-space 0)
	  (pop-matrix))))))

(defsketch art
    ((title "simple rects")
     (width 800)
     (height 800))
  (background (gray 1))
  (make-grid 800 800 20))

(defmethod setup ((instance art) &key &allow-other-keys)
  (background (gray 1))
)

(make-instance 'cl-art:art)
