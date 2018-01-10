# HOWTO

0. (skippable) Install vagrant; then `vagrant up; vagrant ssh -c 'ip a'`; Then save ip to `inventory` file. Unfortunatelly newer CentOS boxes dissalow password authentication (sic!), in order to use `setup_user.yml` change `/etc/ssh/sshd_config`.

1. Make the ansible user that has access to the machine saved in inventory. `ansible-playbook -i inventory setup_user.yml`. If you don't have root access via ssh key (ex. vagrant machine) you should add `--ask-pass` in order to log in with ssh password.
2. Then setup application with `ansible-playbook -i inventory setup_apps.yml`
3. Test deployed app with curl `curl -H 'Host: helloworld.local' machine_ip`. You can also add machine_ip to /etc/hosts, then use web browser.

This code is part of Ansible series on euro-linux.com. (Lang PL). It's not intended to be production used.

Exercises for readers:

- [ ] Change Nginx config so default server will return our app.
- [ ] Change application SECRET_KEY (in future we will encrypt it with ansible-vault)
- [ ] Add firewalld support, start service if not started, and open http/https ports (ssh might be also useful ;)).
