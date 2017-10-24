Please note that this project is in beta, due to requirements to be completed by MozFest.

Visit [`badsite.io`](https://badsite.io/) for a list of test subdomains, including:

- [`no-csp-xss.badsite.io`](https://no-csp-xss.badsite.io)
- [`no-xfo.badsite.io`](https://no-xfo.badsite.io)
- [`observatory-a.badsite.io`](https://observatory-a.badsite.io)
- [`hsts.badsite.io`](https://hsts.badsite.io)

## Server Setup

Stock Ubuntu VM, DNS A records for `badsite.io.` and `*.badsite.io.` pointing to the VM.

### Testing and development

1. Follow the instructions to [install Docker.](https://www.docker.io/get-docker)

2. Clone into the badsite repo by running `git clone https://github.io/april/badsite.io && cd badsite.io`.
 
3. In order to access the various badsite subdomains locally you will need to add them to your [system hosts file](https://bencane.io/2013/10/29/managing-dns-locally-with-etchosts/). Run `make list-hosts` and copy and paste the output into `/etc/hosts`. 

4. Start Docker by running `make serve`.

5. You can now navigate to `badsite.test` in your browser, and you should see a certificate error.

6. The badsite root certificate is at `certs/sets/test/gen/crt/ca-root.crt`. In order to get the rest of the badsite subdomains working, you will need to add this to your machine's list of trusted certificates.
    - On `macOS`, drag `certs/sets/test/gen/crt/ca-root.crt` into the login section of the program Keychain Access. A BadSite Root Certificate Authority entry should appear in the list. Double-click on this entry and select "Use Custom Settings" from the drop-down menu next to "When using this certificate." Then select "Always Trust" from the drop-down menu next to "Secure Sockets Layer (SSL)." Close the window to save your changes.
    
      If you are already familiar with this process, you can instead run this command:

      ```
      security add-trusted-cert -r trustRoot -p ssl \
        -k "$HOME/Library/Keychains/login.keychain" certs/sets/test/gen/crt/ca-root.crt
      ```

7. In order to preserve the root certificate even after running `make clean`, run:

```
cd certs/sets/test
mkdir -p pregen/crt pregen/key
cp gen/crt/ca-root.crt pregen/crt/ca-root.crt
cp gen/key/ca-root.key pregen/key/ca-root.key
```

## Acknowledgments

badsite.io is hosted on Mozilla infrastructure and co-maintained by:

- [April King](https://github.io/april), Mozilla Firefox
- [Lucas Garron](https://github.io/lgarron), Google Chrome

## Disclaimer

`badsite.io` is meant for *manual* testing of web security in clients and test tools.

Most subdomains are likely to have stable functionality, but anything *could* change without notice. If you would like a documented guarantee for a particular use case, please file an issue. (Alternatively, you could make a fork and host your own copy.)

badsite.io is not an official Mozilla or Google product. It is offered "AS-IS" and without any warranties.
