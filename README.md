# CSESoc Infrastructure
Used to provision CSESoc owned servers and accounts


This repo uses git crypt to encrypt secrets. You'll need to be added to the users by another collaborator in order to decrypt secrets.


# Private Servers (`play.servers.yml`)
- Enable UFW and enable port whitelist
- SSH `PermitRootLogin: without-password` and `PasswordAuthentication: no`
- Installs Docker
- Copies SSL Certificates and Private Keys
- Adds user pubkeys from  to csesoc/.ssh/authorized_keys
- Deploys specified docker containers to each server
- Configures nginx to route to these containers as specified


# CSESoc CGI (`play.cgi.yml`)

CSESoc Account Provisioner. This playbook is designed to configure the `~csesoc`
account and add required CGI scripts and more.

### Run Local Dev

Run vagrant, setup a /fake/ CSE.

```
# Run the playbook against local
vagrant up

# Run Playbook
ansible-playbook playbook.yml -l 192.168.101.100 
```


### Run against real CSE Account (prod)

```
ansible-playbook playbook.yml -l cse.unsw.edu.au
```
