;;;; cl-art.lisp

(in-package #:cl-art)

(sb-ext:defglobal zoff 0.0)

(defun make-particles (number-of-particles)
  (loop :for i :below number-of-particles
	:collect (make-instance 'particle
				:pos (vector (random 800) (random 800)))))

(defun vector-from-angle (angle)
  (vector (cos angle) (sin angle)))

(defun make-grid (width height number-of-elm)
  (let* ((width-space (/ width number-of-elm))
	 (height-space (/ height number-of-elm))
	 (xoff 0.0)
	 (yoff 0.0)
	 (r 0.0)
	 (v 0.0)
	 (index 0.0))
    (dotimes (x number-of-elm)
      (setf yoff 0.0)
      (setf xoff (+ 0.1 xoff))
      (dotimes (y number-of-elm)
	(setf r (* 255 (perlin-noise-reference xoff yoff zoff)))
	(setf v (vector-from-angle r))
	(setf yoff (+ 0.1 yoff))
	(setf index (+ y (* x number-of-elm)))
	(setf (svref flowfield index) v)
	(with-pen (make-pen :stroke +black+ :weight 1)
	  (push-matrix)
	  (translate (* x width-space) (* y height-space))
	  (rotate r)
	  (line 0 0 width-space 0)
	  (pop-matrix)))
      ;(setf zoff (+ 0.0001 zoff))
      )
    (loop :for i :in particles
	      :do (follow i flowfield width-space height-space number-of-elm)
		  (update i)
		  (edges i width height)
		  (show i))))

(defsketch art
    ((title "simple rects")
     (width 800)
     (height 800))
  (background (gray 1))
  (make-grid 800 800 30))

(defmethod setup ((instance art) &key &allow-other-keys)
  (setf flowfield (make-array (* 30 30)))
  (setf particles (make-particles 10))
  (background (gray 1)))

(make-instance 'cl-art:art)
