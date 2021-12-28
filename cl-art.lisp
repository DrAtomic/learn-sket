;;;; cl-art.lisp

(in-package #:cl-art)


(defun make-grid (width height number-of-elm)
  (let ((width-space (/ width number-of-elm))
	(height-space (/ height number-of-elm)))
    (dotimes (x number-of-elm)
      (dotimes (y number-of-elm)
	(with-pen (make-pen :stroke +black+ :weight 1))
	(push-matrix)
	(translate (* x width-space) (* y height-space))
	(line 0 0 width-space 0)
	(pop-matrix)))))

(defsketch art
    ((title "simple rects")
     (width 800)
     (height 800))
  (background (gray 1))
  (make-grid width height 10))

(defmethod setup ((instance art) &key &allow-other-keys)
  (background (gray 1)))

(make-instance 'cl-art:art)
