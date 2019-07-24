(in-package #:rocketman)

(defvar *rocket-thread* nil)

(defun run-rocket ()
  (when (and (con-socket *rocket*)
             (not *rocket-thread*))
    (setf *rocket-thread*
          (bt:make-thread (lambda ()
                            (loop (update *rocket*)
                                  (sleep #.(/ 60f0))))
                          :name "ROCKET"))))

(defmethod disconnect :around ((obj rocket))
  (when *rocket-thread*
    (when (bt:thread-alive-p *rocket-thread*)
      (bt:destroy-thread *rocket-thread*))
    (setf *rocket-thread* nil))
  (call-next-method))
