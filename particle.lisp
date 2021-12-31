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
    :accessor acc)))

(defgeneric update (particle)
  (:documentation "update particle stuff"))

(defgeneric apply-force (particle force)
  (:documentation "apply force to the particle"))

(defgeneric show (particle)
  (:documentation "draws the particle"))

(defmethod update ((obj particle))
  (setf (slot-value obj 'pos) (add-vec (pos obj) (vel obj)))
  (setf (slot-value obj 'vel) (add-vec (vel obj) (acc obj)))
  (setf (slot-value obj 'acc) #(0 0)))

(defmethod apply-force ((obj particle) force)
  (setf (slot-value obj 'acc) (add-vec (acc obj) force)))

(defmethod show ((obj particle))
  (with-pen (make-pen :stroke +red+ :weight 10)
    (circle (svref (pos obj) 0) (svref (pos obj) 1) 10)))

(defun add-vec (vec1 vec2)
  (vector (+ (svref vec1 0) (svref vec2 0))
	  (+ (svref vec1 1) (svref vec2 1))))
