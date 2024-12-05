;;I use cddr because the first and two elements are . and .. respectively
(for-each load
	    (map-in-order (lambda (x)
			    (string-append "challenges/" x))
			  (cddr (scandir "challenges"))))
;;;Sadly, we have to depend on the scene writing to register themselves to the scene-running-name list
(for-each load
	  (map-in-order (lambda (x)
			  (string-append "scenes/" x))
			(cddr (scandir "scenes"))))

