# About this repo
This repo is used to provision CSESoc owned servers and accounts. It uses git crypt to encrypt secrets. You'll need to be added by another collaborator in order to decrypt secrets. See [git-crypt](https://github.com/AGWA/git-crypt) for more information.

## Repo Dependencies:

You'll need the following tools to do anything useful with this repo.

  - [Git crypt](https://github.com/AGWA/git-crypt).
  - [Ansible](http://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) 

# Servers under management

### CSESoc CSE Account

The CSE account is used for hosting services that depend on CSE provided services, such as `mlalias` and `pp`. The account is completely provisioned using playbooks in this repo.

### Wheatley - `wheatley.cse.unsw.edu.au` 

Wheatley is a server running on a CSE managed hypervisor. It is provisioned using playbooks in this repo. We moved from away from `glados` to `wheatley` in April 2018.

Wheatley runs the following services:

- Rancher Frontend/UI
- Rancher Agent: Wheatley can run docker containers. 

**Backups**

Data in the `/containers` directory is backed up to the `ssh://csesoc@cse.unsw.edu.au:~/backups` every night at midnight.

# Permitting User Access

For the most part, collaborators can simply be added as users to the Rancher instance, and **do not** need SSH access to the underlying hosts. This will give those users permissions to launch new stacks and manage them. 

# Handover

To add a new infrastructure collaborator you must:

1. Add the user to the git-crypt collaborators for this repo (`git crypt add-gpg-user foo@bar.com`). This will create a new commit, giving user access to the secrets in the repo. You will need to have imported the user's GPG identity's public key to your machine.
2. Add the user's ssh public key to the authorised_keys in `ssh-access.playbook.yml` and apply the playbook to all hosts in the inventory (`ansible-playbook playbooks/ssh-access.playbook.yml`). This will permit the new collaborator SSH access to all CSESoc owned hosts.


# Secrets

In order to ensure all users of this repo have the latest set of configuration secrets, they are checked in with git-crypt. Unfortunately this opens a large risk to accidentally committing un-encrypted secrets.

When committing be diligent before pushing. You can query the encryption status at any time with `git crypt status` which will outline the files currently encrypted/not-encrypted.

## Decrypting the repo

To access the secrets stored in this repo, you must decrypt it. In order to be able to decrypt it, another user must have added you as a git-crypt collaborator.

```bash
git crypt unlock.
```

# Using Ansible / Running Playbooks

A playbook declares configuration and manual steps required to provision a machine. The playbooks in this repo can be found in the [playbooks](playbooks/) dir.

Before running playbooks, ensure you have decrypted the repo. Failure to decrypt the repo will result in copying encrypted secrets to target servers.

**Install Ansible Dependencies**

```bash
ansible-galaxy install -r requirements.yml
``` 

## Playbook Usage

```bash
# Provision all hosts SSH authorized_keys
ansible-playbook  playbooks/ssh-access.playbook.yml
# Provision CSE account
ansible-playbook  -l cse playbooks/cse-cgi.playbook.yml
# Provision Wheatley System
ansible-playbook  -l glados playbooks/wheatley-sys.playbook.yml
# Provision Wheatley Apps
ansible-playbook  -l glados playbooks/wheatley-apps.playbook.yml
```

The `wheatley-sys.playbook.yml` playbook will provision the system with the SSH `authorised_keys` defined in`ssh-access.playbook.yml`. This playbook can be individually run on other hosts to configure SSH access.  

# SSL Certificates
Read more about SSL (including how to renew certificates) in the [ssl dir](ssl). 

After renewing certificates you will need to re-run playbooks to ensure the updated certs are copied. 

# Rancher

Rancher is open source software that combines everything an organization needs to adopt and run containers in production.

All CSESoc services must be deployed via Rancher. Deploying an application within Rancher will mean it is monitored and guaranteed to be backed up. In addition to this, it will mean that inbound traffic can be easily routed to it and terminated with an SSL certificate at no additional effort to the deployer. 

## Accessing Rancher
The rancher UI is exposed on port `7654` over `ssl`. Port `7654` is blocked outside of UNSW so you must either be connected to the CSE VPN or be inside the UNSW network. [https://wheatley.cse.unsw.edu.au:7654]()

Alternatively, you can access the UI outside of UNSW by using an SSL local tunnel:

```bash
ssh -L 7654:127.0.0.1:7654 csesoc@wheatley.cse.unsw.edu.au
``` 

Once connected, you should be able to access the UI on [https://localhost:7654]().


## Services/Stacks 

The following stacks are currently provisioned. The docker/rancher compose files can be found in the [rancher]() directory. These configurations have had secrets removed and would need to be re-added in the event of a re-deployment.

### CSESoc Website
The CSESoc Website stack is deployed with a collection of containers.
- `csesoc-website`: The website django application
- `load-balancer`: Handles URL/host pattern matching.
- `www-redirect`: Redirects non-www traffic to [www.csesoc.unsw.edu.au]()
- `media-admin`: Provides a web UI for uploading static assets to the `/static/media` directory. It is accessible via [https://www.csesoc.unsw.edu.au/media-admin]().


### Bark Server
Bark server is a simple single container deployment running the bark backend server. 

### Web Load Balancer

`web-load-balancer` is a special stack - It binds to the host's port `80` and port `443` and has the task of reverse proxying traffic into the applications deployed on the hosts. 

By default, all traffic on port `80` is redirect to it's `HTTPS` counterpart on port `443`. This is done via the `geldim/https-redirect` container.

## Auto Deploy on master push

TODO (NW) - fill out this section.
