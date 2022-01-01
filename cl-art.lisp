;;;; cl-art.lisp

(in-package #:cl-art)

(sb-ext:defglobal zoff 0.0)

(defun make-particles (number-of-particles)
  (loop :for i :below number-of-particles
	:collect (make-instance 'particle)))

(defun print-particles (particles)
    (loop :for i :in particles
	  :do (print (pos i))))

(defun make-grid (width height number-of-elm particles)
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
      (setf zoff (+ 0.0001 zoff))
      (let ((diff 0))
	(loop :for i :in particles
	      :do (setf (svref (pos i) 0) (+ diff 100)
			(svref (pos i) 1) (+ diff 100))
		  (setf diff (+ 10 diff))
		  (show i))))))

(defsketch art
    ((title "simple rects")
     (width 800)
     (height 800))
  (let ((particles (make-particles 8)))
    (background (gray 1))
    (make-grid 800 800 30 particles)))

(defmethod setup ((instance art) &key &allow-other-keys)
  (background (gray 1)))

(make-instance 'cl-art:art)
