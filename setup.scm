(set! *random-state* (random-state-from-platform))

(use-modules (chickadee graphics path))

;;this is for use with scanning challenge folder and get the file names in it
(use-modules ((ice-9 ftw)
	      #:select (scandir)))
