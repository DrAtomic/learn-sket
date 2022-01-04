(in-package #:cl-art)

(defclass particle ()
  ((pos
    :initarg :pos
    :initform (vector 0 0)
    :accessor pos)
   (vel
    :initarg :vel
    :initform (vector 0 0)
    :accessor vel)
   (acc
    :initarg :acc
    :initform (vector 0 0)
    :accessor acc)
   (max-speed
    :initarg :max-speed
    :initform 4
    :accessor max-speed)))

(defgeneric update (particle)
  (:documentation "update particle stuff"))

(defgeneric apply-force (particle force)
  (:documentation "apply force to the particle"))

(defgeneric show (particle)
  (:documentation "draws the particle"))

(defgeneric edges (particle width height)
  (:documentation "checks if its over the edge and then comes back"))

(defgeneric follow (particle vectors width-space height-space number-of-elm)
  (:documentation "checks the nearest flowfield vector and applies its force"))

(defmethod update ((obj particle))
  (setf (slot-value obj 'pos) (add-vec (pos obj) (vel obj)))
  (setf (slot-value obj 'vel) (add-vec (vel obj) (acc obj)))
  (if (> (magnitude (slot-value obj 'vel)) (slot-value obj 'max-speed))
      (setf (slot-value obj 'vel) (set-magnitude (vel obj) (max-speed obj))))
  (setf (slot-value obj 'acc) #(0 0)))

(defmethod apply-force ((obj particle) force)
  (setf (slot-value obj 'acc) (add-vec (acc obj) force)))

(defmethod show ((obj particle))
  (with-pen (make-pen :stroke +red+ :weight 10)
    (circle (svref (pos obj) 0) (svref (pos obj) 1) 10)))

(defmethod edges ((obj particle) width height)
  (let ((x (svref (pos obj) 0))
	(y (svref (pos obj) 1)))
    (if (> x width)  (setf (svref (pos obj) 0) 0))
    (if (< x 0)      (setf (svref (pos obj) 0) width))
    (if (> y height) (setf (svref (pos obj) 1) 0))
    (if (< y 0)      (setf (svref (pos obj) 1) height))))

(defmethod follow ((obj particle) vectors width-space height-space number-of-elm)
  (let* ((x (floor (svref (pos obj) 0) number-of-elm))
	 (y (floor (svref (pos obj) 1) number-of-elm))
	 (index (+ x (* y number-of-elm)))
	 (force (svref vectors index)))
    	 (apply-force obj force)))

(defun add-vec (vec1 vec2)
  (vector (+ (svref vec1 0) (svref vec2 0))
	  (+ (svref vec1 1) (svref vec2 1))))

(defun magnitude (vec)
  (let ((x (svref vec 0))
	(y (svref vec 1)))
    (sqrt (+ (* x x) (* y y)))))

(defun set-magnitude (vec new-mag)
  (let ((x (svref vec 0))
	(y (svref vec 1))
	(old-mag (magnitude vec)))
    (vector (* x (/ new-mag old-mag)) (* y (/ new-mag old-mag)))))
