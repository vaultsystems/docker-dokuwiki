DokuWiki docker container
=========================


To run image:
-------------

	docker run -d -p 80:80 --name my_wiki mprasil/dokuwiki 

You can now visit the install page to configure your new DokuWiki wiki.

For example, if you are running container locally, you can acces the page 
in browser by going to http://127.0.0.1/install.php

To upate the image:
-------------------

First stop your container

	docker stop my_wiki

Then run new container just to hold the volumes

	docker run --volumes-from my_wiki --name my_wiki_data busybox true

Now you can remove old container

	docker rm my_wiki

..and run a new one (you built, pulled before)

	docker run -d -p 80:80 --name my_wiki --volumes-from my_wiki_data mprasil/dokuwiki 

afterwards you can remove data container if you want

	docker rm my_wiki_data

(or keep it for next update, takes no space anyway..)

Optimizing your wiki
--------------------

Lighttpd configuration also includes rewrites, so you can enable 
nice URLs in settings (Advanced -> Nice URLs, set to ".htaccess")

For better performance enable xsendfile in settings.
Set to proprietary lighttpd header (for lighttpd < 1.5)

Build your own
--------------

	docker build -t my_dokuwiki .
