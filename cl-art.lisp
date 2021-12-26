;;;; cl-art.lisp

(in-package #:cl-art)

(defsketch art
    ((title "Brownian")
     (width 800)
     (height 600)
     (copy-pixels t)
     (pos (cons (/ width 2) (/ height 2))) (dir '(1 . 0))
     (pen (make-pen :stroke (gray 0.5) :fill (gray 0.5) :weight 1))
     (line-length 3)
     (points (make-array 256 :initial-element (cons 400 300)))
     (points-pointer 0))
  (flet ((draw (paces)
	   (dotimes (i paces)
	     (let ((new-pos (cons (+ (car pos) (car dir))
				  (+ (cdr pos) (cdr dir)))))
	       (with-pen pen
		 (line (car pos) (cdr pos) (car new-pos) (cdr new-pos)))
	       (setf pos new-pos))))
	 (rotate (a)
	   (let ((a (+ a (degrees (atan (cdr dir) (car dir))))))
	     (setf dir (cons (cos (radians a))
			     (sin (radians a)))))))
    (rotate (- (random 180) 90))
    (draw (+ (random line-length) line-length))
    (setf (car pos) (alexandria:clamp (car pos) -10 810)
	  (cdr pos) (alexandria:clamp (cdr pos) -10 610))))

(defmethod setup ((instance art) &key &allow-other-keys)
  (background (gray 1)))

(make-instance 'cl-art:art)
