# The Automation Logic test

##### Given the following instructions:
> - Create a Vagrantfile that creates a single machine using this box: https://vagrantcloud.com/puppetlabs/boxes/ubuntu-14.04-64-nocm and installs the latest released version of your chosen configuration management tool.
- Install the nginx webserver via configuration management.
- Run a simple test using Vagrant's shell provisioner to ensure that nginx is listening on port 80

The test output is not very pretty, but if nginx is listening, you will see output similar to this on the screen shortly after the provisioning step is complete:

    ==> lb-node-1: tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      0          22265       7688/nginx

- Manage the contents of /etc/sudoers file so that Vagrant user can sudo without a password and that anyone in the admin group can sudo with a password.

To test this:

    vagrant ssh -c "sudo grep 'admin\|vagrant' /etc/sudoers" lb-node-1

> - Make the solution idempotent so that re-running the provisioning step will not restart nginx unless changes have been made

Saltstack does this by default.

> - Create a simple "Hello World" web application in your favourite language of choice

I did this in node.js - interestingly the helloworld app is on the front page of the node.js [website](https://nodejs.org/)

> - Extend the Vagrantfile to deploy this webapp to two additional vagrant machines and then configure the nginx to load balance between them.

I have hardcoded the useful number of webapps into the vagrantfile. If we need to add more to the vagrantfile, we need to increase the size of the loop

    "(1..2).each"

and remember to add the new addresses to the list :

    "lb_nodes" => [ "10.1.2.11", "10.1.2.12" ]

> - Test (in an automated fashion) that both app servers are working, and that the nginx is serving the content correctly.

I have created a nagios compatible testing script that is created dynamically on the loadbalancer. The test is not really conclusive since it does not test if the load is actually being balanced, however it will detect if there is a service outage.

    vagrant ssh -c "sudo /root/servicetest.sh" lb-node-1

### How to use this amazing "application"

1. Clone this repo to your machine

    git clone https://github.com/tajh/automationlogictest.git

2. Bring up the vagrant machines, note that if you are on a very slow connection, you may have to try a few times to get all of the package dependencies installed.

    cd automationlogictest
    vagrant up

3. I have hardcoded some IP addresses into the vagrant file for convenience.  You can test the loadbalanced app at http://10.1.2.2
The individual app servers are located at http://10.1.2.11:8080 and http://10.1.2.12:8080

4. To ensure your application stays up, add the nagios script found at /root/servicetest.sh on the lb-node-1 machine to your favorite nagios compatible monitoring service.
