# csesoc.unsw.edu.au SSL Certificates

Hello reader! It's probably that time of year again where it's time to renew SSL 
certificates. No need to fear the unknown! It's all documented here! 😁

UNSW IT will issue certificates for free. There is no need to pay a third party 
for certificates. At the time of writing it is impossible to obtain 
certificates via a third party due to the CAA configuation on the 
csesoc.unsw.edu.au domain anyway:

```
dig CAA unsw.edu.au

; <<>> DiG 9.9.7-P3 <<>> CAA unsw.edu.au
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 23683
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 512
;; QUESTION SECTION:
;unsw.edu.au.			IN	CAA

;; ANSWER SECTION:
unsw.edu.au.		3589	IN	CAA	0 issue "quovadisglobal.com"

;; Query time: 99 msec
;; SERVER: 192.168.8.1#53(192.168.8.1)
;; WHEN: Thu Apr 12 20:13:43 AEST 2018
;; MSG SIZE  rcvd: 77
``` 

This means that letsencrypt cannot be used for automatic certificate renewal. This may 
change in the future, so keep your eyes out!

To request a certificate from UNSW IT you must generate a private key & CSR. 

```bash
openssl req -new -newkey rsa:4096 -nodes \
  -keyout csesoc.unsw.edu.au.key \
  -out csesoc.unsw.edu.au.csr \
  -config openssl.cnf
```

The config `openssl.cnf` is configured to request a certificate for the following domains:

- *.csesoc.unsw.edu.au
- csesoc.unsw.edu.au

If you need more domains for some reason, you can modify those in the `[alt_names]` section 
in `openssl.cnf`.

You can inspect the CSR to make sure everything looks OK:

```bash
openssl req -in csesoc.unsw.edu.au.csr -noout -text
```

UNSW IT will return signed certificate. Place it in this directory with the name 
`csesoc.unsw.edu.au.crt`.

Finally, you need to create the certificate bundle/chain that can be used by `nginx`. 
This can be done by simply appending the CA chain to the bottom of the file. i.e:

- Your cert
- CA intermediate cert
- CA cert  

You should be able to obtain the CA cert and intermediate certificates from the 
certificate authority that signed the certificate. At the time of writing, UNSW 
IT provided a link to these at the bottom of their reply email.
  
```bash
cat csesoc.unsw.edu.au.crt ca-intermediate.crt ca.crt > csesoc.unsw.edu.au.bundle.crt
``` 

Now, re-run the playbook and you'll be on your way! The certificates will be 
updated on the target host. 

Easy Peasy! Make sure you inspect the certificate and find out it's expiry date, 
set a reminder for 3 months before that to renew it again to make sure you don't
experience any downtime 😁
