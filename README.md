# cl-art

Learning common lisp sketch.

# Description

Common lisp is a great programming language despite all the bad parts.

I've always wanted to do generative art so I'm gonna use this.

# Dependencies

I had to downgrade(kindof) sbcl because some dependencies no longer work. I'm using version 2.0.11.
get all the [[https://github.com/vydd/sketch#installation][sketch]] dependencies.

this project requires [[https://www.quicklisp.org/beta/][quicklisp]] so go ahead and get that. As a side note quicklisp is really cool 

# Usage

```bash
git clone git@github.com:DrAtomic/learn-sketch.git
cd learn-sketch
echo "(:tree \"$PWD\")" > ~/.config/common-lisp/source-registry.conf.d/1-learn-sketch.conf
sbcl
(ql:quickload "cl-art")
```
