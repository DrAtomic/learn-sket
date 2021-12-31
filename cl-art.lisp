;;;; cl-art.lisp

(in-package #:cl-art)

(defun angle (x1 y1 x2 y2)
  "gets the angle from a line"
  (let ((a (atan (- y2 y1) (- x2 x1))))
    (if (< a 0)
	(+ a (* PI 2.0))
	a)))

(sb-ext:defglobal zoff 0.0)

(defun make-grid (width height number-of-elm)
  (let* ((width-space (/ width number-of-elm))
	 (height-space (/ height number-of-elm))
	 (xoff 0.0)
	 (yoff 0.0)
	 (r (* 255 (perlin-noise-reference xoff yoff zoff))))
    (dotimes (x number-of-elm)
      (setf yoff 0.0)
      (setf xoff (+ 0.1 xoff))
      (dotimes (y number-of-elm)
	(setq r (* 255 (perlin-noise-reference xoff yoff zoff)))
	(setf yoff (+ 0.1 yoff))
	(with-pen (make-pen :stroke +black+ :weight 1)
	  (push-matrix)
	  (translate (* x width-space) (* y height-space))
	  (rotate r)
	  (line 0 0 width-space 0)
	  (pop-matrix)))
      (setf zoff (+ 0.0001 zoff)))))

(defsketch art
    ((title "simple rects")
     (width 800)
     (height 800))
  (background (gray 1))
  (make-grid 800 800 30))

(defmethod setup ((instance art) &key &allow-other-keys)
  (background (gray 1)))

(make-instance 'cl-art:art)
