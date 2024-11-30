;;I use cddr because the first and two elements are . and .. respectively
(for-each load
	  (map-in-order (lambda (x)
			  (string-append "challenges/" x))
			(cddr (scandir "challenges"))))
