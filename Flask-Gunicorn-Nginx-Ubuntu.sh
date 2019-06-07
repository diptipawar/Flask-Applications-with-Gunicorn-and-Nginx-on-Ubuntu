How To Serve Flask Applications with Gunicorn and Nginx on Ubuntu 14.04 

Introduction
In this guide, we will be setting up a simple Python application using the 
Flask web service on Ubuntu 14.04. The article aims to provide guideline
about how to set up the Gunicorn application server to launch the application 
and Nginx to act as a front end reverse proxy.

Install the Components from the Ubuntu Repositories
sudo pip install gunicorn flask
sudo apt-get install nginx 

Create a Python Virtual Environment
sudo pip install virtualenv
mkdir ~/myproject
cd ~/myproject
virtualenv myprojectenv

source myprojectenv/bin/activate


nano ~/myproject/myproject.py

code:

from flask import Flask
application = Flask(__name__)

@application.route("/")
def hello():
    return "<h1 style='color:blue'>Hello There!</h1>"

if __name__ == "__main__":
    application.run(host='0.0.0.0')
You can test your Flask app by typing:
python myproject.py


Run:  http://192.168.2.200:8000/

Hello There!
________________________________________________________

Create the WSGI Entry Point ( Web server gateway Interface)

Next, we will create a file that will serve as the entry point 
for our application. This will tell our Gunicorn server how to 
interact with the application. 

We will call the file wsgi.py:
nano ~/myproject/wsgi.py

code:
from myproject import application

if __name__ == "__main__":
    application.run()

Save and close the file when you are finished.

Testing Gunicorn's Ability to Serve the Project
cd ~/myproject
gunicorn --bind 0.0.0.0:8000 wsgi
http://server_domain_or_IP:8000
http://192.168.2.200:8000/
Hello There!
We're now done with our virtual environment, so we can deactivate it:
deactivate

______________________________________________________
For Ubuntu:
Create a systemd Unit File  

The next piece we need to take care of is the systemd service
 unit file. Creating a systemd unit file will allow Ubuntu's 
init system to automatically start Gunicorn and serve our 
Flask application whenever the server boots.

Create a unit file ending in .service within the /etc/systemd/system directory to begin:
sudo nano /etc/systemd/system/myproject.service
[Unit]
Description=Gunicorn instance to serve myproject
After=network.target
[Service]
User=rac
WorkingDirectory=/home/rac/myproject
ExecStart=/home/rac/myproject/myprojectenv/bin/gunicorn --bind 0.0.0.0:8000 -w 4 wsgi:app
Restart=always
[Install]
WantedBy=multi-user.target
_______________________________________________________________________________
For Centos6:
We are creating mypandemo service.

Path :

/etc/rc.d/init.d/mypandemo
---------------------------------------------------------------

#!/bin/bash
#/etc/rc.d/init.d/mypandemo

# Source function library.
. /etc/init.d/functions



start() {
    echo -n "Starting mypandemo: "
     
        #!/bin/bash

    cd /root/Python_AI/myproject
    #/root/Python_AI/Bajaj_Insurance_Demo/myproject/myprojectenv/bin/gunicorn --bind 0.0.0.0:5000 -w 4 wsgi
    /opt/rh/python27/root/usr/bin/gunicorn --daemon --timeout 120 --bind 0.0.0.0:8000 -w 2 wsgi

   
    return 0
}   

start

_______________________________________________________

Integration with NGINX
sudo nano /etc/nginx/sites-available/myproject
server {
    listen 80;
    server_name 192.168.2.200;
    location / {
        include proxy_params;
        proxy_pass http://192.168.2.200:8000;
    }
}
sudo ln -s /etc/nginx/sites-available/myproject /etc/nginx/sites-enabled
sudo nginx -t
sudo service nginx restart
http://192.168.2.200
get the output 
__________________________________________________________

Note: Two tire architecture (Flask and Gunicorn)
      Three tire architecture (Flask, Gunicorn and Nginx) 

