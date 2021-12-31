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

(setf p1 (make-instance 'particle :pos (vector 1 1)))
(pos p1)

(defmethod greet (obj)
  (format t "you are a ~a.~&" (type-of obj)))

(greet p1)
