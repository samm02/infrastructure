# CSESoc Infrastructure
Used to provision CSESoc owned servers and accounts

This repo uses git crypt to encrypt secrets. You'll need to be added to the users by another collaborator in order 
to decrypt secrets. See [git-crypt](https://github.com/AGWA/git-crypt) for more information.

## Repo Dependencies:

You'll need the following tools to do anything useful with this repo.

  - [Git crypt](https://github.com/AGWA/git-crypt).
  - [Ansible](http://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) 

## Running Playbooks

A playbook declares configuration and manual steps required to provision a machine. The playbooks in 
this repo can be found in the [playbooks](playbooks/) dir.

Before running playbooks, ensure you have decrypted the repo

```bash
git crypt unlock.
```

Failure to decrypt the repo will result in copying encrypted secrets to target servers.

### Install Ansible Dependencies

```bash
ansible-galaxy install -r requirements.yml
``` 

### Playbook Usage

```bash
# Provision CSE account
ansible-playbook  -l cse playbooks/cse-cgi.playbook.yml
# Provision Glados System
ansible-playbook  -l glados playbooks/glados-sys.playbook.yml
# Provision Glados Apps
ansible-playbook  -l glados playbooks/glados-apps.playbook.yml
```

Both the `cse-cgi.playbook.yml` and `glados-sys.playbook.yml` playbooks will provision the 
systems with the SSH `authorised_keys` defined in`ssh-access.playbook.yml`. 

### Secrets

In order to ensure all users of this repo have the latest set of configuration secrets, 
they are checked in with git-crypt. Unfortunately this opens a large risk to 
accidentally committing un-encrypted secrets.

When committing be diligent before pushing. You can query the encryption status at any 
time with `git crypt status` which will outline the files currently encrypted/not-encrypted.

## SSL

Read more about SSL (including how to renew certificates) in the [ssl dir](playbooks/files/ssl). After 
renewing certificates you will need to re-run playbooks to ensure the updated certs
are copied. 

## Adding Collaborators

To add a collaborator to this infra repo, you must:

- Add collaborator to the ssh authorised keys - see 
[playbooks/ssh-access.playbook.yml](playbooks/ssh-access.playbook.yml). Once added, you must re-provision all systems 
using the `ssh-access.playbook.yml` playbook
- Add collaborator to git-crypt: `git crypt add-gpg-user <user-id>`. The collaborator will need a GPG 
keypair under their control. 


