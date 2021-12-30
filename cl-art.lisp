;;;; cl-art.lisp

(in-package #:cl-art)

;;; perlin noise function from
;;; https://git.sr.ht/~aerique/black-tie/tree/master/item/src/config.lisp

(defparameter +pnp+
  #(151 160 137 91 90 15 131 13 201 95 96 53 194 233 7 225 140 36 103 30 69 142
    8 99 37 240 21 10 23 190 6 148 247 120 234 75 0 26 197 62 94 252 219 203
    117 35 11 32 57 177 33 88 237 149 56 87 174 20 125 136 171 168 68 175 74
    165 71 134 139 48 27 166 77 146 158 231 83 111 229 122 60 211 133 230 220
    105 92 41 55 46 245 40 244 102 143 54 65 25 63 161 1 216 80 73 209 76 132
    187 208 89 18 169 200 196 135 130 116 188 159 86 164 100 109 198 173 186 3
    64 52 217 226 250 124 123 5 202 38 147 118 126 255 82 85 212 207 206 59 227
    47 16 58 17 182 189 28 42 223 183 170 213 119 248 152 2 44 154 163 70 221
    153 101 155 167 43 172 9 129 22 39 253 19 98 108 110 79 113 224 232 178 185
    112 104 218 246 97 228 251 34 242 193 238 210 144 12 191 179 162 241 81 51
    145 235 249 14 239 107 49 192 214 31 181 199 106 157 184 84 204 176 115 121
    50 45 127 4 150 254 138 236 205 93 222 114 67 29 24 72 243 141 128 195 78
    66 215 61 156 180
    151 160 137 91 90 15 131 13 201 95 96 53 194 233 7 225 140 36 103 30 69 142
    8 99 37 240 21 10 23 190 6 148 247 120 234 75 0 26 197 62 94 252 219 203
    117 35 11 32 57 177 33 88 237 149 56 87 174 20 125 136 171 168 68 175 74
    165 71 134 139 48 27 166 77 146 158 231 83 111 229 122 60 211 133 230 220
    105 92 41 55 46 245 40 244 102 143 54 65 25 63 161 1 216 80 73 209 76 132
    187 208 89 18 169 200 196 135 130 116 188 159 86 164 100 109 198 173 186 3
    64 52 217 226 250 124 123 5 202 38 147 118 126 255 82 85 212 207 206 59 227
    47 16 58 17 182 189 28 42 223 183 170 213 119 248 152 2 44 154 163 70 221
    153 101 155 167 43 172 9 129 22 39 253 19 98 108 110 79 113 224 232 178 185
    112 104 218 246 97 228 251 34 242 193 238 210 144 12 191 179 162 241 81 51
    145 235 249 14 239 107 49 192 214 31 181 199 106 157 184 84 204 176 115 121
    50 45 127 4 150 254 138 236 205 93 222 114 67 29 24 72 243 141 128 195 78
    66 215 61 156 180))

(defun fade-ref (v)
  (* v v v (+ (* v (- (* v 6) 15)) 10)))


(defun grad-ref (hash x y z)
  (let* ((h (logand hash 15))
         (u (if (< h 8) x y))
         (v (if (< h 4) y (if (or (= h 12) (= h 14)) x z))))
    (+ (if (= (logand h 1) 0) u (- u))
       (if (= (logand h 2) 0) v (- v)))))


(defun lerp-ref (v a b)
  (+ a (* v (- b a))))


(defun perlin-noise-reference (x y z)
  "X, Y and Z should be floats for the best results."
  (let* ((xc (logand (floor x) 255))
         (yc (logand (floor y) 255))
         (zc (logand (floor z) 255))
         (x (- x (floor x)))  ; (x (mod x 1)) is faster in SBCL
         (y (- y (floor y)))  ; (y (mod y 1)) is faster in SBCL
         (z (- z (floor z)))  ; (z (mod z 1)) is faster in SBCL
         (u (fade-ref x))
         (v (fade-ref y))
         (w (fade-ref z))
         (a (+ (svref +pnp+ xc) yc))
         (aa (+ (svref +pnp+ a) zc))
         (ab (+ (svref +pnp+ (+ a 1)) zc))
         (b (+ (svref +pnp+ (+ xc 1)) yc))
         (ba (+ (svref +pnp+ b) zc))
         (bb (+ (svref +pnp+ (+ b 1)) zc)))
    (lerp-ref w (lerp-ref v (lerp-ref u (grad-ref aa x y z)
                                        (grad-ref ba (- x 1) y z))
                            (lerp-ref u (grad-ref ab x (- y 1) z)
                                        (grad-ref bb (- x 1) (- y 1) z)))
                (lerp-ref v (lerp-ref u (grad-ref (+ aa 1) x y (- z 1))
                                        (grad-ref (+ ba 1) (- x 1) y (- z 1)))
                            (lerp-ref u (grad-ref (+ ab 1) x (- y 1) (- z 1))
                                        (grad-ref (+ bb 1) (- x 1) (- y 1)
                                                  (- z 1)))))))

(defun angle (x1 y1 x2 y2)
  "gets the angle from a line"
  (let ((a (atan (- y2 y1) (- x2 x1))))
    (if (< a 0)
	(+ a (* PI 2.0))
	a)))

(setf zoff 0.0)

(defun make-grid (width height number-of-elm)
  (let* ((width-space (/ width number-of-elm))
	 (height-space (/ height number-of-elm)))
    (setq xoff 0.0)
    (dotimes (x number-of-elm)
      (setq yoff 0.0)
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
      (setf zoff (+ 0.001 zoff)))))

(defsketch art
    ((title "simple rects")
     (width 800)
     (height 800))
  (background (gray 1))
  (make-grid 800 800 30))

(defmethod setup ((instance art) &key &allow-other-keys)
  (background (gray 1)))

(make-instance 'cl-art:art)
