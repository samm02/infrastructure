# CSESoc Account Provisioner
This playbook is designed to configure the ~csesoc account and add
required CGI scripts and more.


### Run Local Dev

Run vagrant, setup a /fake/ CSE.

```
vagrant up
```

Run the playbook against local
```
ansible-playbook playbook.yml -l 192.168.101.100
```

### Run against real CSE Account (prod)

```
ansible-playbook playbook.yml -l cse.unsw.edu.au
```


## Git Crypt / Secrets
This repo uses git crypt to encrypt secrets. You'll need to be added to the users by another collaborator in order to decrypt secrets.