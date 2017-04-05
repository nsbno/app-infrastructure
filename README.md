# Application infrastructure

### What is this?

This repo contains all the Terraform modules that are reusable across different applications. There is nothing wrong with creating a module in the application's repo, but if it is general enough put it here instead.

It is assumed that this repository is checked out "next to" the repos using it (i.e. both the applications and this repo should be cloned into the same folder).


### Creating certificates in AWS

Run the following command to request a certificate from AWS Certificate Manager (ACM). Replace `APPLICATION` by whatever you want to secure. You'll need the `aws` command installed.

```
aws acm request-certificate --domain-name APPLICATION.cloud.nsb.no --subject-alternative-names "*.APPLICATION.cloud.nsb.no" --domain-validation-options DomainName=APPLICATION.cloud.nsb.no,ValidationDomain=nsb.no DomainName="*.APPLICATION.cloud.nsb.no",ValidationDomain=nsb.no
```

This will trigger an email to be sent to the owners of `nsb.no` (at, among others `hostmaster@nsb.no`) who will need to approve the request.
